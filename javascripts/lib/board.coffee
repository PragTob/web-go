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
    board[y][x]

print_board = (board)->

  sign_for_color = (color)->
    mapping = {}
    mapping[BLACK] = "X"
    mapping[WHITE] = "O"
    mapping[EMPTY] = " "

    mapping[color]

  result = ""
  for y in [0...board.length]
    for x in [0...board.length]
      result += sign_for_color(get_field(x, y, board))
    result += "\n"

  result