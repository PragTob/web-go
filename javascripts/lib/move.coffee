BLACK = 1
WHITE = -1
EMPTY = 0
NEUTRAL = 2
VISITED = true

create_stone = (x, y, color)->
  x: x
  y: y
  color: color

create_pass_move = (color)-> create_stone(null, null, color)

play_stone = (stone, board) ->
  unless is_pass_move(stone)
    if is_valid_move(stone, board)
      set_move(stone, board)
      captures = capture_stones_with(stone, board)
      stone.captures = captures
    else
      throw "Illegal move Exception!"
  board.moves.push stone

is_pass_move = (stone)-> (stone.x == null) or (stone.y == null)

other_color = (color)->
  if color == BLACK
    WHITE
  else
    BLACK

has_liberties = (stone, board)->

  is_visited = (stone, visited_mapping)->
    get_color(stone.x, stone.y, visited_mapping) == VISITED

  visit = (stone, visited_mapping)->
    visited_move = create_stone(stone.x, stone.y, VISITED)
    set_move(visited_move, visited_mapping)

  is_liberty = (stone, board, visited_map, color)->
      switch stone.color
        when EMPTY then true
        when NEUTRAL then false
        when other_color(color) then false
        when color
          search_for_liberties  stone.x,
                                stone.y,
                                board,
                                visited_map,
                                color
        else throw 'we should never end up here when checking for liberties'

  search_for_liberties = (x, y, board, visited_map, color) ->
    neighbours = neighbouring_stones(x, y, board)
    unvisited_neighbours = _.reject neighbours, (stone)->
      is_visited(stone, visited_map)
      
    _.each unvisited_neighbours, (stone)-> visit(stone, visited_map)
    _.any unvisited_neighbours, (stone)->
      is_liberty(stone, board, visited_map, color)

  visited_map = initBoard(board.length)
  search_for_liberties(stone.x, stone.y, board, visited_map, stone.color)

is_valid_move = (stone, board) ->

  field_is_unoccupied = (stone, board)->
    get_color(stone.x, stone.y, board) == EMPTY

  is_no_double_move = (move, board)->
    if board.moves.length == 0
      true
    else
      last_move = board.moves[board.moves.length - 1]
      last_move.color != move.color

  is_no_suicide_move = (move, board)->
    has_liberties(move, board) or is_capturing_stones(move, board)

  is_capturing_stones = (move, board)->
    # we don't want to modify the original board as this is just a test
    copied_board = copy_board(board)
    set_move(move, copied_board)
    neighbours = enemy_neighbours(move, copied_board)
    not _.every neighbours, (stone)-> has_liberties(stone, copied_board)

  is_no_illegal_ko_move = (move, board, captures)->

    last_move_and_current_move_captured_exactly_one = (captures, last_move) ->
      captures.length == 1 && last_move.captures.length == 1

    is_first_move = (board)-> board.moves.length == 0

    captures_of_move = (move, board)->
      copied_board = copy_board(board)
      set_move(stone, copied_board)
      capture_stones_with(stone, copied_board)


    return true if is_first_move(board)
    last_move = board.moves[board.moves.length - 1]
    captures = captures_of_move(stone, board)
    not (last_move_and_current_move_captured_exactly_one(captures, last_move) and
    is_same_move(last_move.captures[0], move))


  field_is_unoccupied(stone, board) and
  is_no_double_move(stone, board) and
  is_no_suicide_move(stone, board) and
  is_no_illegal_ko_move(stone, board)

is_same_move = (move, other_move)->
  move.x == other_move.x &&
  move.y == other_move.y &&
  move.color == other_move.color

capture_stones_with = (stone, board)->

  take_captures = (stone, board, captive_color, captures = [])->
    if stone.color == captive_color
      remove_stone(stone, board)
      increase_prisoner_count(board, captive_color)
      captures.push stone
      neighbours = neighbouring_stones(stone.x, stone.y, board)
      _.each neighbours, (stone)->
        take_captures(stone, board, captive_color, captures)
      captures

  remove_stone = (stone, board) ->
    empty_move = create_stone(stone.x, stone.y, EMPTY)
    set_move(empty_move, board)

  increase_prisoner_count = (board, captive_color)->
    own_color = other_color(captive_color)
    board.prisoners[own_color] += 1


  enemy_color = other_color(stone.color)
  captures = []
  _.each enemy_neighbours(stone, board), (stone)->
    unless has_liberties(stone, board)
      captures = captures.concat take_captures(stone, board, enemy_color)
  captures

