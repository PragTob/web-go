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

is_out_of_bounds = (x, y, board) ->
  board_size = board.length # assumes an always quadratic board
  if (x < 0) or (y < 0) or (x >= board_size) or (y >= board_size)
    true
  else
    false

get_stone = (x, y, board) ->
  if is_out_of_bounds(x, y, board)
    NEUTRAL
  else
    board[y][x]

create_coordinate = (x, y)->
  x: x
  y: y

all_neighbours = (x, y, board)->
  _.map all_neighbouring_coordinates(x, y), (coordinate)->
    get_stone(coordinate.x, coordinate.y, board)

all_neighbouring_coordinates = (x, y)->
  [create_coordinate(x, y - 1), create_coordinate(x, y + 1),
   create_coordinate(x - 1, y), create_coordinate(x + 1, y)]


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