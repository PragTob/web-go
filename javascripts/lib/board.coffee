initBoard = (size)->
  board = []
  for i in [0...size]
    board.push []
    for j in [0...size]
      board[i][j] = EMPTY
  board.moves = []
  board

get_field = (x, y, board) ->
  is_out_of_bounds = (x, y, board) ->
    board_size = board.length # assumes an always quadratic board
    if (x < 0) or (y < 0) or (x >= board_size) or (y >= board_size)
      true
    else
      false

  if is_out_of_bounds(x, y, board)
    NEUTRAL
  else
    board[x][y]