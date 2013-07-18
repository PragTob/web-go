BLACK = 1
WHITE = -1
EMPTY = undefined
NEUTRAL = 2
VISITED = true
NEUTRAL_SPACE_MODIFIER = 2

initBoard = (size)->
  size = size + NEUTRAL_SPACE_MODIFIER
  board = new Array size
  for i in [0...size]
    array = new Array size
    array[0] = NEUTRAL
    array[array.length - 1] = NEUTRAL
    board[i] = array
  for i in [1...size - 1]
    board[0][i] = NEUTRAL
    board[board.length - 1][i] = NEUTRAL
  board.length = size - 2
  board.moves = []
  board

copy_board = (board)->

  deep_copy_2_dimensional_array = (array)->
    copy = []
    for i in [0...array.length]
      copy.push array[i].slice(0)
    copy

  copy = deep_copy_2_dimensional_array(board)
  copy.moves = board.moves.slice(0)
  copy


set_move = (move, board)->
  set_stone(move, board) unless is_pass_move(move)


set_stone = (stone, board)-> board[stone.y + 1][stone.x + 1] = stone.color

is_empty = (collection)-> collection.length == 0

get_color = (x, y, board)->
  console.log board
  board[y + 1][x + 1]

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

is_equal_board = (board_1, board_2)->
  # stackoverflow: http://stackoverflow.com/questions/11142666/is-there-an-idiomatic-way-to-test-array-equality-in-coffeescript
  '' + board_1 is '' + board_2

get_last_move = (board)->
  if board.moves.length >= 1
    board.moves[board.moves.length - 1]
  else
    null

all_fields_do = (board, func)->
  for y in [0...board.length]
    for x in [0...board.length]
      func(x, y, get_color(x,y, board))

SIGN_MAPPING = {}
SIGN_MAPPING[BLACK] = "X"
SIGN_MAPPING[WHITE] = "O"
SIGN_MAPPING[EMPTY] = "-"
SIGN_MAPPING[NEUTRAL] = '_'

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
