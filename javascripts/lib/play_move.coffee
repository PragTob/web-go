BLACK = 1
WHITE = -1

create_move = (x, y, color)->
  x: x
  y: y
  color: color

play_move = (move, board) ->
  board[move.x][move.y] = move.color