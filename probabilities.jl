
include("mp-datastructures.jl")
include("mp-functions.jl")
using Plots
pyplot()

"""    probabilities(ngames, nmoves)
returns percentage (%) probabilities of landing on each square"""
function probabilities(ngames, nmoves)
    countsquares = fill(0, 40)
    for game in 1:ngames
        mygame = newgame(1500)
        for move in 1:nmoves
            visited = taketurn!(mygame)
            # mygame.currentplayer = 1 + (mygame.currentplayer % length(mygame.players))
            for i in visited
                countsquares[i] += 1
            end
        end
    end
    probs = 100 * countsquares ./ sum(countsquares)
    return probs
end

@time probs = probabilities(100_000, 80)
x = [i.name for i in origsquares]
fig = plot(probs
    ,xticks=(1:40, x)
    ,seriestype=:bar, legend=false, size=(900,600)
    ,title="Probabilities of Finishing on Square"
    ,xrotation=90, xtickfontsize=9
    ,ytickfontsize=10, gridalpha=.5
)
