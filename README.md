## Monopoly Analysis
### Intro
This project is totally inspired by the video:
(https://www.youtube.com/results?search_query=mathematics+of+winning+monopoly)

[Monopoly](https://en.wikipedia.org/wiki/Monopoly_(game)) is a board game where players buy and trade properties, developing them with houses and hotels. Players collect rent from their opponents, with the goal being to drive them into bankruptcy.

In the youtube video, mathematicians Matt Parker and Hannah Fry go through some Python code to simulate the game. I aim to do similar but with the new upcoming language [Julia](https://julialang.org)

### Goals
#### 1. Use Julia (https://julialang.org)
Julia is built for performance, so hopefully this means more iterations, and less time waiting for the computer to crunch the numbers. Also, monopoly has a really complicated set of rules, so I'd like to check out how simple and how human-readable it is possible to make the code, in an area where object-oriented languages might traditionally be used.

#### 2. Probabilities of landing on certain squares [02_probabilities.ipynb](02_probabilities.ipynb)
This is mainly to check whether my results tie up with what others have done.

#### 3. Going around the empty board [03_emptyboard.ipynb](03_emptyboard.ipynb)
In monopoly you get some money just from passing go (£200) and randomly from community chest and chance cards. The simulation generates some charts of this money flow. In order to bankrupt someone, you need to take money away from them faster than they can earn it. The charts indicate how much rent you'd need to be taking to stand a reasonable chance of bankrupting them.

#### 4. Comparing property groups [04_comparisons.ipynb](04_comparisons.ipynb)
Everyone wants to know whether one set of properties is better than another, eg. is green better than orange? are the train stations good? The idea is to setup a game with two players where for example one player owns green and one player owns orange. Send them around the board and generate charts of the money flow to see which is better.

#### 5. Likelihood of getting a colour set
Monopoly is all about getting a complete colour set as you can't build until you have a set. If you send 4 people around the board and they all buy up properties they land on, how likely is it any one person will end with a complete set? If you are unable to get a complete set by landing on the right squares then you'll have to agree a trade with other players.

#### 6. Optimisations
Julia is all about speed, right. How to optimise the code to run faster?

### Notes
Examples including plots are in the Jupyter notebook format and can be viewed directly on Github.
Need Julia's Plots library and PyPlot for plotting, everything else just uses Julia standard library.
Coding guidelines - All functions should have docstrings right from the start. Try to divide a program into functions as soon as possible. Follow Julia convention to append ! to functions that modify their arguments. Use spaces for indents. Try to keep line lengths short but only where this improves readability. Avoid directly iterating over indices, instead try to use features of the language such as zip(), enumerate(), map(), filter(), where practicable. Prefer keyword arguments to function calls.

Licensed under [MIT](LICENSE) terms
