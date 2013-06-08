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

set_move = (move, board)->
  set_stone(move, board) unless is_out_of_bounds move.x, move.y, board

set_stone = (stone, board)-> board[stone.y][stone.x] = stone.color

is_empty = (collection)-> collection.length == 0

is_out_of_bounds = (x, y, board) ->
  board_size = board.length # assumes an always quadratic board
  if (x < 0) or (y < 0) or (x >= board_size) or (y >= board_size)
    true
  else
    false

get_color = (x, y, board)->
  if is_out_of_bounds(x, y, board)
    NEUTRAL
  else
    board[y][x]

get_stone = (x, y, board)->
  x: x
  y: y
  color: get_color(x, y, board)


neighbouring_stones = (x, y, board)->
  [get_stone(x, y - 1, board), get_stone(x, y + 1, board),
   get_stone(x - 1, y, board), get_stone(x + 1, y, board)]

enemy_neighbours = (my_stone, board)->
  neighbours = neighbouring_stones(my_stone.x, my_stone.y, board)
  enemy_color = other_color(my_stone.color)
  _.select neighbours, (neighbouring_stone)->
    neighbouring_stone.color == enemy_color



SIGN_MAPPING = {}
SIGN_MAPPING[BLACK] = "X"
SIGN_MAPPING[WHITE] = "O"
SIGN_MAPPING[EMPTY] = "-"

BACK_MAPPING = {}
BACK_MAPPING["X"] = BLACK
BACK_MAPPING["O"] = WHITE
BACK_MAPPING["-"] = EMPTY

print_board = (board)->
  sign_for_color = (color)->
    SIGN_MAPPING[color]

  result = ""
  for y in [0...board.length]
    for x in [0...board.length]
      result += sign_for_color(get_color(x, y, board))
    result += "\n"

  result[0..-2] #remove last \n

board_from_string = (string)->

  color_for_sign = (sign)->
    BACK_MAPPING[sign]

  lines = string.split "\n"
  #assumes quadratic boards as it should be
  board_size = lines.length
  board = initBoard(board_size)
  for y in [0...board_size]
    for x in [0...board_size]
      set_move(create_stone(x, y, color_for_sign(lines[y][x])), board)

  board
