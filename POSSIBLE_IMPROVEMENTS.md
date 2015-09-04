# Possible improvements

Possible improvements that could be applied to the bot.

## More efficient playouts
More efficient playouts means more playouts, means more data, means better moves being chosen hopefully.
A lot of these are hypothetical and running the benchmark will show if they are really worth it.

* have groups concept that counts liberties of groups as they are played --> faster detection for captures etc. (no more board copies)
* keep a list of valid moves to easily pick from
* don't let play_stone recheck the validity of a move, assume it is valid
* stop the simulation at an earlier point (before putting all stones on the field)
* have a virtually extended board where fields that are not in the field are `NEUTRAL` to avoid range checks.
* lazy operations (Iterator/Enumerator like) when possible, such as finding a neighboring friendly stone
* make neighbour stones methods not create separate arrays (add them straight to it)
* Avoid creating stone objects all of the time (`get_stone` function)
  * put actual stone objects on the board to be returned (becomes more viable once we don't copy the damn board anymore)
  * just pass around x, y and the color all the time (ewwwwwwww)
* Better out of bounds handling for neighbouring stones etc. (just return a smaller array instead of creating fake neutral stounes)

## Algorithmic
MCTS improvements & co.

* RAVE (apply every move to the tree)



## Features
* work with Japanese counting rules
* make it possible to choose between moves
* Show confidence level of AI
* show map with "hot areas" (where does the AI want to play)
* sense of time to play in timed matches
