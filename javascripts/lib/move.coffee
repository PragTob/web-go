BLACK = 1
WHITE = -1
EMPTY = 0
NEUTRAL = 2

create_move = (x, y, color)->
  x: x
  y: y
  color: color

play_move = (move, board) ->
  board[move.x][move.y] = move.color

is_valid_move = (move, board) ->
  true