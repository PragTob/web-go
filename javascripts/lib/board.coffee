initBoard = (size)->
  board = []
  for i in [0...size]
    board.push []
    for j in [0...size]
      board[i][j] = EMPTY
  board.moves = []
  board.prisoners = {}
  board.prisoners[BLACK] = 0
  board.prisoners[WHITE] = 0
  board

get_stone = (x, y, board) ->
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

#get_stone_above = (x, y, board)-> get_stone(x, y - 1, board)
#get_stone_below = (x, y, board)-> get_stone(x, y + 1, board)
#get_stone_left = (x, y, board)-> get_stone(x - 1, y, board)
#get_stone_right = (x, y, board)-> get_stone(x + 1, y, board)

all_neighbours_satisfy = (x, y, board, criteria_func)->
  criteria_func(x, y - 1, board) and
  criteria_func(x, y + 1, board) and
  criteria_func(x - 1, y, board) and
  criteria_func(x + 1, y, board)


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
      result += sign_for_color(get_stone(x, y, board))
    result += "\n"

  result