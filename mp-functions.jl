
import Random
# using Profile # only used for code profiling

# actiontypes
# "none"
# "pay" -- QTY gives amount
# "community"
# "chance"
# "jail"
# "goto" -- QTY gives location code to mode to
# "receive" -- QTY gives amount
# "getoutofjail" -- QTY 1 for chestcards. 2 for chancecards
# "goback" -- QTY gives n steps backward
# "10each" -- receive $10 from each player
# "repairs" -- For each house pay £25. For each hotel pay £100
# "st_repairs" -- Pay £40 per house, £115 per hotel
# "rent" -- pay rent to owner
# "station" -- pay rent to owner
# "utility" -- pay rent to owner

### FUNCTIONS ###
"""    spend!(g::Game, qty)
Spend money on taxes, fines, rent, etc. Players balance is reduced."""
function spend!(g::Game, qty)
    p = g.players[g.currentplayer]
    p.money -= qty
end

"""    community!(g::Game, qty)
Draw community chest card and do player actions. qty is ignored"""
function community!(g::Game, qty)
    # use modulo to cycle through 1 to ncards
    n = g.chestN
    # println(g.chestcards[n])
    doActions!(g, g.chestcards[n])
    # n could change if getoutofjail card is removed by doActions!
    n = g.chestN
    ncards = length(g.chestcards)
    g.chestN = 1 + n % ncards
end

"""    chance!(g::Game, qty)
Draw chance card and do player actions. qty is ignored"""
function chance!(g::Game, qty)
    # use modulo to cycle through 1 to ncards
    n = g.chanceN
    # println(g.chancecards[n])
    doActions!(g, g.chancecards[n])
    # n could change if getoutofjail card is removed by doActions!
    n = g.chanceN
    ncards = length(g.chancecards)
    g.chanceN = 1 + n % ncards
end

"""    toJail!(g::Game, qty)
Send player straight to Jail, do not collect 200. qty is ignored"""
function toJail!(g::Game, qty)
    p = g.players[g.currentplayer]
    p.injail = true
    p.location = 11
end

"""    goto!(g::Game, n)
Player goes to square, and does any player actions. Collect 200 if passing go."""
function goto!(g::Game, n)
    p = g.players[g.currentplayer]
    # get 200 if passing go
    if n < p.location
        p.money += 200
    end
    p.location = n
    doActions!(g, g.squares[n])
end

"""    receive!(g::Game, qty)
Receive money from cards, etc. Players balance to increase."""
function receive!(g::Game, qty)
    p = g.players[g.currentplayer]
    p.money += qty
end

"""    outofjailcard!(g::Game, qty)
Receive get out of jail free card. qty is ignored. Remove card from stack."""
function outofjailcard!(g::Game, qty)
    p = g.players[g.currentplayer]
    p.getoutjailfree += 1
    if qty == 1 # chestcards
        deleteat!(g.chestcards, g.chestN)
        g.chestN -= 1
    else
        deleteat!(g.chancecards, g.chanceN)
        g.chanceN -= 1
    end
end

"""    goback!(g::Game, n)
Go back n squares and do any actions"""
function goback!(g::Game, n)
    p = g.players[g.currentplayer]
    loc = 1 + (p.location + 39 - n) % 40
    p.location = loc
    doActions!(g, g.squares[loc])
end

"""    receive10all!(g::Game, qty)
Receive 10 pounds from each player. qty is ignored"""
function receive10all!(g::Game, qty)
    cp = g.players[g.currentplayer]
    # filter() to exclude the currentplayer from the list
    for p in filter(x -> x.i != g.currentplayer, g.players)
        cp.money += 10
        p.money -= 10
    end
end

"""    repairs!(g::Game, qty)
Pay 25 per house, and 100 per hotel. qty is ignored"""
function repairs!(g::Game, qty)
    p = g.players[g.currentplayer]
    for n in p.owned
        square = g.squares[n]
        # built is 5 for hotel
        if square.built == 5
            p.money -= 100
        else
            p.money -= 25 * square.built
        end
    end
end

"""    st_repairs!(g::Game, qty)
Pay 40 per house, and 115 per hotel. qty is ignored"""
function st_repairs!(g::Game, qty)
    p = g.players[g.currentplayer]
    for n in p.owned
        square = g.squares[n]
        # built is 5 for hotel
        if square.built == 5
            p.money -= 115
        else
            p.money -= 40 * square.built
        end
    end
end

"""    payrent!(g::Game, qty)
Pay rent to owner of property. qty is ignored"""
function payrent!(g::Game, qty)
    # check square is owned and that owner is not yourself
    # see if whole set owned
    # lookup rent
    # transfer from player to player
    p = g.players[g.currentplayer]
    square = g.squares[p.location]
    owner = square.owner
    if owner != 0 && p.i != owner
        samecolor = filter(x -> x.color == square.color, g.squares)
        if all(x -> x.owner == owner, samecolor)
            if square.built == 0
                amount = 2 * square.rents[1]
            else
                amount = square.rents[square.built + 1]
            end
        else
            amount = square.rents[square.built + 1]
        end
        p.money -= amount
        g.players[owner].money += amount
    end
end

"""    paystation!(g::Game, qty)
Pay rent to owner of station. qty is ignored.
1 station 25; 2 stations 50; 3 stations 100; 4 stations 200"""
function paystation!(g::Game, qty)
    # check square is owned and that owner is not yourself
    # count no. of stations owned
    # work out rent
    # transfer from player to player
    p = g.players[g.currentplayer]
    square = g.squares[p.location]
    owner = square.owner
    if owner != 0  &&  p.i != owner
        n = count(
            x -> x.owner == owner && x.actiontype == "station"
            ,g.squares
        )
        amount = 25 * 2^(n-1)
        p.money -= amount
        g.players[owner].money += amount
    end
end

"""    payutility!(g::Game, qty)
Pay rent to owner of utility. qty is ignored.
One utility 4 x rollval; both utilities 10 x rollval"""
function payutility!(g::Game, qty)
    # check square is owned and that owner is not yourself
    # count no. of utilities owned
    # work out rent
    # transfer from player to player
    p = g.players[g.currentplayer]
    square = g.squares[p.location]
    owner = square.owner
    if owner != 0  &&  p.i != owner
        n = count(
            x -> x.owner == owner && x.actiontype == "utility"
            ,g.squares
        )
        amount = 4*rollval + (n-1)*6*rollval
        p.money -= amount
        g.players[owner].money += amount
    end
end

"""    donothing(a, b)
Callable function that returns nothing. Needed by doActions! function."""
donothing(a, b) = nothing

const actiondefs = Dict{String, Any}(
    "pay" => spend!,
    "community" => community!,
    "chance" => chance!,
    "jail" => toJail!,
    "goto" => goto!,
    "receive" => receive!,
    "getoutofjail" => outofjailcard!,
    "goback" => goback!,
    "10each" => receive10all!,
    "repairs" => repairs!,
    "st_repairs" => st_repairs!,
    "rent" => payrent!,
    "station" => paystation!,
    "utility" => payutility!,
    "none" => donothing
)
"""    doActions!(g::Game, item::Union{Square,Community,Chance})
Lookup actions based on text string in data tables and execute"""
function doActions!(g::Game, item::Union{Square,Community,Chance})
    # actiondefs is a dictionary of callable functions
    # example: "jail" maps to toJail!(g, QTY)
    actiondefs[item.actiontype](g, item.actionQTY)
end

"""    goforward!(g::Game, n)
Go forward n squares."""
function goforward!(g::Game, n)
    p = g.players[g.currentplayer]
    loc = 1 + (p.location + n-1) % 40
    goto!(g, loc)
end

"""    releasejail!(g::Game)
Release player from jail. Either deduct £50 or use getoutofjailfree card."""
function releasejail!(g::Game)
    p = g.players[g.currentplayer]
    if p.getoutjailfree > 0
        nchest = length(g.chestcards)
        nchance = length(g.chancecards)
        # return to community chest or chance cards
        if nchest < 16 # stack not full
            append!(g.chestcards, [origchestcards[16]])
            g.chestN += 1
        else
            append!(g.chancecards, [origchancecards[16]])
            g.chanceN += 1
        end
        p.getoutjailfree -= 1
    else
        p.money -= 50
    end
    p.injail = false
end

### TESTS ###
# rollval = 5
# # Player(i, owned, location, injail, money, getoutjailfree)
# p1 = Player(1, [7], 1, false, 1500, 0)
# p2 = Player(2, [], 1, false, 1500, 0)
# p3 = Player(3, [], 1, false, 1500, 0)
# g1 = Game(1, [p1, p2, p3], origsquares, 1, origchestcards, 16, origchancecards)
# g1.squares[7].owner = 2 # angel islington
# g1.squares[9].owner = 2 # euston road
# g1.squares[10].owner = 2 # pentonville road
# g1.squares[6].owner = 2 # kings cross
# g1.squares[16].owner = 2 # marylebone
# g1.squares[13].owner = 3 # electric
# g1.squares[29].owner = 3 # water
# println(g1.players[g1.currentplayer])
# @time spend!(g1, 501)
# println(g1.players[g1.currentplayer])
# @time chance!(g1, 0)
# println(g1.players[g1.currentplayer])
# @time goforward!(g1, 6)
# println(g1.players[g1.currentplayer])
# g1.players


"""    roll()
Roll the dice. returns total of 2 throws and whether double was thrown.
"""
function roll()
    a, b = floor(Int, 1 + 6*rand()), floor(Int, 1 + 6*rand())
    isdouble = (a==b)
    return a + b, isdouble
end

"""    taketurn!(g::Game)
Player takes his turn to go. Roll dice. If 3rd double to Jail. Move to square. Do actions. Repeat if doubles.
Returns list of squares visited by player."""
function taketurn!(g::Game)
    # need to store dice value as utility rents calculated from dice roll
    global rollval
    doubles = 0
    squaresvisited = []
    p = g.players[g.currentplayer]
    if p.injail
        releasejail!(g)
    end
    while true
        if p.injail
            break
        end
        rollval, isdouble = roll()
        if isdouble
            doubles += 1
            if doubles == 3
                toJail!(g, 0)
                push!(squaresvisited, p.location)
                break
            end
            goforward!(g, rollval)
            push!(squaresvisited, p.location)
            continue
        end # if
        goforward!(g, rollval)
        push!(squaresvisited, p.location)
        break
    end # while
    return squaresvisited
end

"""    newgame(money...)
Setup new game with empty board. Args gives the start money of the players.
Number of players is inferred from number of arguments. eg
newgame(1500, 1500) gives player1 1500 and player2 1500"""
function newgame(money...)
    # Player(i, owned, location, injail, money, getoutjailfree)
    players = [
        Player(i, [], 1, false, amount, 0)
        for (i, amount) in enumerate(money)
    ]
    cardscom = Random.shuffle(origchestcards)
    cardscha = Random.shuffle(origchancecards)
    # Game(currentplayer, players, squares, chestN, chestcards, chanceN, chancecards)
    return Game(1, players, deepcopy(origsquares), 1, cardscom, 1, cardscha)
end

"""    buildproperty(g::Game, builds)
Set ownership of land and build level of properties. builds is n x 3 array.
The columns of the array are:
[square, owner, built]
square = number from 1 to 40.
owner = number denoting player.
built = 0 for nothing; 1,2,3,4 for houses; 5 for hotel"""
function buildproperty!(g::Game, builds)
    for data in builds
        n = data[1]
        owner = data[2]
        g.squares[n].owner = owner
        g.squares[n].built = data[3]
        if owner > 0
            player = g.players[owner]
            push!(player.owned, n)
        end
    end
end

### TESTS ###
# function testing(niter)
#     # define players
#     # Player(i, owned, location, injail, money, getoutjailfree)
#     p1 = Player(1, [], 1, false, 1500, 0)
#     p2 = Player(2, [6, 7, 9, 10, 16], 1, false, 1500, 0)
#     p3 = Player(3, [13, 29], 1, false, 1500, 0)
#     cardscom = Random.shuffle(origchestcards)
#     cardscha = Random.shuffle(origchancecards)
#     # Game(currentplayer, players, squares, chestN, chestcards, chanceN, chancecards)
#     mygame = Game(1, [p1, p2, p3], deepcopy(origsquares), 1, cardscom, 1, cardscha)
#     # define properties owned
#     mygame.squares[7].owner = 2 # angel islington
#     mygame.squares[9].owner = 2 # euston road
#     mygame.squares[10].owner = 2 # pentonville road
#     mygame.squares[7].built = 4 # angel islington
#     mygame.squares[9].built = 4 # euston road
#     mygame.squares[10].built = 4 # pentonville road
#     mygame.squares[6].owner = 2 # kings cross
#     mygame.squares[16].owner = 2 # marylebone
#     mygame.squares[13].owner = 3 # electric
#     mygame.squares[29].owner = 3 # water
#     # begin iterations
#     for iterN in 1:niter
#         taketurn!(mygame)
#         mygame.currentplayer = 1 + (mygame.currentplayer % length(mygame.players))
#         # println(iterN, ", ", mygame.players[3])
#     end
#     display(mygame.players)
# end
# @time testing(500)
# Profile.clear()
# Profile.init(n = 10^7, delay = 0.0001)
# @profile testing(5_000_000)
# Profile.print(IOContext(stdout, :displaysize => (24, 500)))
