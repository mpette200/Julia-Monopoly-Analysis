
include("mp-datastructures.jl")
include("mp-functions.jl")
using Plots
pyplot()

"""    emptyboard(ngames, nmoves)
Player just loops around an empty board. Returns move number and money as n x 2 array.
Move numbers - out[:,1]
Money - out[:,2]"""
function emptyboard(ngames, nmoves)
    n = ngames * nmoves
    out = zeros(n,2)
    i = 0
    for game in 1:ngames
        mygame = newgame(1500)
        # random starting point
        currentplayer = mygame.players[mygame.currentplayer]
        currentplayer.location = rand(1:40)
        for move in 1:nmoves
            i += 1
            currentplayer = mygame.players[mygame.currentplayer]
            visited = taketurn!(mygame)
            out[i,:] = [move, currentplayer.money]
        end
    end
    return out
end

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

@time balances = emptyboard(200, 80)
x = balances[:,1]
y = balances[:,2]
xtrend, ytrend = linearfit(x, y)
plot(x, y
    ,seriestype=:scatter, seriesalpha=.08, seriescolor="brown"
    ,markerstrokewidth=0, markersize=4.5
    ,gridalpha=.5, legend=false
    ,title="Just Going Around The Empty Board"
    ,xlabel="Move Number", ylabel="Balance (£)"
    ,tickfontsize=10)
plot!(xtrend, ytrend, seriescolor="blue", linewidth=2)
