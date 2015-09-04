BLACK = 1
WHITE = -1
EMPTY = undefined
NEUTRAL = 2
VISITED = true

initBoard = (size)->
  board = new Array size
  for y in [0...size]
    board[y] = new Array size
    for x in [0...size]
      set_stone(create_stone(x, y, EMPTY), board)

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
  unless is_pass_move(move) or is_out_of_bounds move.x, move.y, board
    set_stone(move, board)

set_stone = (stone, board)-> board[stone.y][stone.x] = stone

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
    get_stone(x, y, board)?.color

get_stone = (x, y, board)->
  if is_out_of_bounds(x, y, board)
    create_stone(x, y, NEUTRAL)
  else
    board[y][x]

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

BACK_MAPPING = {}
BACK_MAPPING["X"] = BLACK
BACK_MAPPING["O"] = WHITE
BACK_MAPPING["-"] = EMPTY

board_to_string = (board)->
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
      color = color_for_sign(lines[y][x])
      if (color == WHITE) || (color == BLACK)
        makeValidMove(create_stone(x, y, color), board)

  board
