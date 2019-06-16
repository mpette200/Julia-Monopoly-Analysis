
### DATA STRUCTURES ###
"""    Player(i, owned::Array, location, injail, money, getoutjailfree)"""
mutable struct Player
    i::Integer
    owned::Array{Integer}
    location::Integer
    injail::Bool
    money::Integer
    getoutjailfree::Integer
end
"""    Square(i, name, color, owner, actiontype, actionQTY, built, rents::Array)
Square.built = 0 for nothing; 1,2,3,4 for houses; 5 for hotel"""
mutable struct Square
    i::Integer
    name::String
    color::String
    owner::Integer
    actiontype::String
    actionQTY::Integer
    built::Integer
    rents::Array{Integer}
end
"""    Community(i, description, actiontype, actionQTY)"""
struct Community
    i::Integer
    description::String
    actiontype::String
    actionQTY::Integer
end
"""    Chance(i, description, actiontype, actionQTY)"""
struct Chance
    i::Integer
    description::String
    actiontype::String
    actionQTY::Integer
end
"""    Game(currentplayer, players, squares, chestN, chestcards, chanceN, chancecards)"""
mutable struct Game
    currentplayer::Integer
    players::Array{Player}
    squares::Array{Square}
    chestN::Integer
    chestcards::Array{Community}
    chanceN::Integer
    chancecards::Array{Chance}
end

### DATA TABLES ###
"""    Square(i, name, color, owner, actiontype, actionQTY, built, rents::Array)
Square.built = 0 for nothing; 1,2,3,4 for houses; 5 for hotel"""
const origsquares = [
    Square(1, "Go", "", 0, "none", 0, 0, []),
    Square(2, "Old Kent Road", "brown", 0, "rent", 0, 0, [2, 10, 30, 90, 160, 250]),
    Square(3, "Community Chest", "", 0, "community", 0, 0, []),
    Square(4, "Whitechapel Road", "brown", 0, "rent", 0, 0, [4, 20, 60, 180, 320, 450]),
    Square(5, "Income Tax", "", 0, "pay", 200, 0, []),
    Square(6, "Kings Cross Station", "", 0, "station", 0, 0, []),
    Square(7, "The Angel Islington", "cyan", 0, "rent", 0, 0, [6, 30, 90, 270, 400, 550]),
    Square(8, "Chance", "", 0, "chance", 0, 0, []),
    Square(9, "Euston Road", "cyan", 0, "rent", 0, 0, [6, 30, 90, 270, 400, 550]),
    Square(10, "Pentonville Road", "cyan", 0, "rent", 0, 0, [8, 40, 100, 300, 450, 600]),
    Square(11, "Jail", "", 0, "none", 0, 0, []),
    Square(12, "Pall Mall", "pink", 0, "rent", 0, 0, [10, 50, 150, 450, 625, 750]),
    Square(13, "Electric Company", "", 0, "utility", 0, 0, []),
    Square(14, "Whitehall", "pink", 0, "rent", 0, 0, [10, 50, 150, 450, 625, 750]),
    Square(15, "Northumberland Avenue", "pink", 0, "rent", 0, 0, [12, 60, 180, 500, 700, 900]),
    Square(16, "Marylebone Station", "", 0, "station", 0, 0, []),
    Square(17, "Bow Street", "orange", 0, "rent", 0, 0, [14, 70, 200, 550, 750, 950]),
    Square(18, "Community Chest", "", 0, "community", 0, 0, []),
    Square(19, "Marlborough Street", "orange", 0, "rent", 0, 0, [14, 70, 200, 550, 750, 950]),
    Square(20, "Vine Street", "orange", 0, "rent", 0, 0, [16, 80, 220, 600, 800, 1000]),
    Square(21, "Free Parking", "", 0, "none", 0, 0, []),
    Square(22, "Strand", "red", 0, "rent", 0, 0, [18, 90, 250, 700, 875, 1050]),
    Square(23, "Chance", "", 0, "chance", 0, 0, []),
    Square(24, "Fleet Street", "red", 0, "rent", 0, 0, [18, 90, 250, 700, 875, 1050]),
    Square(25, "Trafalgar Square", "red", 0, "rent", 0, 0, [20, 100, 300, 750, 925, 1100]),
    Square(26, "Fenchurch Street Station", "", 0, "station", 0, 0, []),
    Square(27, "Leicester Square", "yellow", 0, "rent", 0, 0, [22, 110, 330, 800, 975, 1150]),
    Square(28, "Coventry Street", "yellow", 0, "rent", 0, 0, [22, 110, 330, 800, 975, 1150]),
    Square(29, "Water Works", "", 0, "utility", 0, 0, []),
    Square(30, "Piccadilly", "yellow", 0, "rent", 0, 0, [24, 120, 360, 850, 1025, 1200]),
    Square(31, "Go To Jail", "", 0, "jail", 0, 0, []),
    Square(32, "Regent Street", "green", 0, "rent", 0, 0, [26, 130, 390, 900, 1100, 1275]),
    Square(33, "Oxford Street", "green", 0, "rent", 0, 0, [26, 130, 390, 900, 1100, 1275]),
    Square(34, "Community Chest", "", 0, "community", 0, 0, []),
    Square(35, "Bond Street", "green", 0, "rent", 0, 0, [28, 150, 450, 1000, 1200, 1400]),
    Square(36, "Liverpool Street Station", "", 0, "station", 0, 0, []),
    Square(37, "Chance", "", 0, "chance", 0, 0, []),
    Square(38, "Park Lane", "blue", 0, "rent", 0, 0, [35, 175, 500, 1100, 1300, 1500]),
    Square(39, "Super Tax", "", 0, "pay", 100, 0, []),
    Square(40, "Mayfair", "blue", 0, "rent", 0, 0, [50, 200, 600, 1400, 1700, 2000])
]
const origchestcards = [
    Community(1, "Advance to Go", "goto", 1),
    Community(2, "Go back to Old Kent Road", "goto", 2),
    Community(3, "Go to jail. Move directly to jail. Do not pass Go. Do not collect £200", "jail", 0),
    Community(4, "Pay hospital £100", "pay", 100),
    Community(5, "Doctor's fee. Pay £50", "pay", 50),
    Community(6, "Pay your insurance premium £50", "pay", 50),
    Community(7, "Bank error in your favour. Collect £200", "receive", 200),
    Community(8, "Annuity matures. Collect £100", "receive", 100),
    Community(9, "You inherit £100", "receive", 100),
    Community(10, "From sale of stock you get £50", "receive", 50),
    Community(11, "Receive interest on 7% preference shares: £25", "receive", 25),
    Community(12, "Income tax refund. Collect £20", "receive", 20),
    Community(13, "You have won second prize in a beauty contest. Collect £10", "receive", 10),
    Community(14, "It is your birthday. Collect £10 from each player", "10each", 0),
    Community(15, "Get out of jail free. This card may be kept until needed or sold", "getoutofjail", 1),
    Community(16, "Pay a £10 fine or take a Chance", "pay", 10)
]
const origchancecards = [
    Chance(1, "Advance to Go", "goto", 1),
    Chance(2, "Go to jail. Move directly to jail. Do not pass Go. Do not collect £200", "jail", 0),
    Chance(3, "Advance to Pall Mall. If you pass Go collection £200", "goto", 12),
    Chance(4, "Take a trip to Marylebone Station and if you pass Go collect £200", "goto", 16),
    Chance(5, "Advance to Trafalgar Square. If you pass Go collect £200", "goto", 25),
    Chance(6, "Advance to Mayfair", "goto", 40),
    Chance(7, "Go back three spaces", "goback", 3),
    Chance(8, "Make general repairs on all of your houses. For each house pay £25. For each hotel pay £100", "repairs", 0),
    Chance(9, "You are assessed for street repairs: £40 per house; £115 per hotel", "st_repairs", 0),
    Chance(10, "Pay school fees of £150", "pay", 150),
    Chance(11, "Drunk in charge fine £20", "pay", 20),
    Chance(12, "Speeding fine £15", "pay", 15),
    Chance(13, "Your building loan matures. Receive £150", "receive", 150),
    Chance(14, "You have won a crossword competition. Collect £100", "receive", 100),
    Chance(15, "Bank pays you dividend of £50", "receive", 50),
    Chance(16, "Get out of jail free. This card may be kept until needed or sold", "getoutofjail", 2)
]

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
