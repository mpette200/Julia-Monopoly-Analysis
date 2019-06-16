
include("mp-datastructures.jl")
include("mp-functions.jl")
using Plots
pyplot()

# [squarenumber, owner, built]
# built = 0 for nothing; 1,2,3,4 for houses; 5 for hotel
buildings = [
    [2, 0, 0], # Old Kent Road,        brown
    [4, 0, 0], # Whitechapel Road,    brown
    [6, 0, 0], # Kings Cross Station
    [7, 0, 0], # The Angel Islington, cyan
    [9, 0, 0], # Euston Road,         cyan
    [10, 0, 0], # Pentonville Road,   cyan
    [12, 0, 0], # Pall Mall,          pink
    [13, 0, 0], # Electric Company
    [14, 0, 0], # Whitehall,          pink
    [15, 0, 0], # Northumberland Avenue, pink
    [16, 0, 0], # Marylebone Station
    [17, 1, 5], # Bow Street,         orange
    [19, 1, 5], # Marlborough Street, orange
    [20, 1, 5], # Vine Street,        orange
    [22, 0, 0], # Strand,             red
    [24, 0, 0], # Fleet Street,       red
    [25, 0, 0], # Trafalgar Square,   red
    [26, 0, 0], # Fenchurch Street Station
    [27, 0, 0], # Leicester Square,   yellow
    [28, 0, 0], # Coventry Street,    yellow
    [29, 0, 0], # Water Works
    [30, 0, 0], # Piccadilly,         yellow
    [32, 0, 0], # Regent Street,      green
    [33, 0, 0], # Oxford Street,      green
    [35, 0, 0], # Bond Street,        green
    [36, 0, 0], # Liverpool Street Station, 
    [38, 2, 5], # Park Lane,          blue
    [40, 2, 5] # Mayfair,             blue
]

"""    linearfit(x, y)
Computes least squares fit straight line between scattered x and y points.
Returns pair of points as an x-array and y-array that can be used to directly plot a straight line"""
function linearfit(x, y)
    # sum_xx is sum of squares of x, sum_xy is sum of x*y
    sum_xx = sum(x -> x^2, x)
    sum_xy = sum(x .* y)
    n = length(x)
    # y = bx + a where b is slope and a is intercept
    slope = (n*sum_xy - sum(x)*sum(y)) /
            (n*sum_xx - sum(x)^2)
    intercept = (sum(y) - slope*sum(x)) / n
    xpoints = [minimum(x), maximum(x)]
    ypoints = slope .* xpoints .+ intercept
    return xpoints, ypoints
end

"""    simulatemoney(ngames, nmoves, builddata)
Setup new game with 2 players. Define ownership and build level of properties.
Each game lasts for nmoves and the game is repeated ngames times.
function returns 3 arrays: the move number; player1 balance; player 2 balance
The columns of the builddata array are:
[square, owner, built]
square = number from 1 to 40.
owner = number denoting player.
built = 0 for nothing; 1,2,3,4 for houses; 5 for hotel"""
function simulatemoney(ngames, nmoves, builddata)
    moveN = []
    balance1 = []
    balance2 = []
    for game in 1:ngames
        mygame = newgame(300, 300)
        buildproperty!(mygame, builddata)
        # random starting point
        for player in mygame.players
            player.location = rand(1:40)
        end
        for move in 1:nmoves
            currentplayer = mygame.players[mygame.currentplayer]
            visited = taketurn!(mygame)
            # gather results
            push!(moveN, move)
            push!(balance1, mygame.players[1].money)
            push!(balance2, mygame.players[2].money)
            # use modulo to loop around all players
            nextperson = 1 + (mygame.currentplayer % length(mygame.players))
            mygame.currentplayer = nextperson
        end
    end
    return moveN, balance1, balance2
end

x, y1, y2 = simulatemoney(200, 80, buildings)
x1trend, y1trend = linearfit(x, y1)
x2trend, y2trend = linearfit(x, y2)
p1 = plot(x, y1, title="Player 1 owns hotels on\nBow Street, Marlborough Street, Vine Street"
    ,seriestype=:scatter, seriescolor="brown")
p1 = plot!(x1trend, y1trend, seriescolor="blue", linewidth=2)
p2 = plot(x, y2, title="Player 2 owns hotels on\nMayfair, Park Lane"
    ,seriestype=:scatter, seriescolor="green")
p2 = plot!(x2trend, y2trend, seriescolor="blue", linewidth=2)
p4 = plot(p1, p2
    ,link=:all, size=(1000, 500)
    ,markeralpha=.08, markersize=4.5, markerstrokewidth=0
    ,gridalpha=.5, legend=false
    ,xlabel="Move Number", ylabel="Balance (£)"
    ,tickfontsize=10)
