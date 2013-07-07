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

  field_is_occupied = (stone, board)->
    get_color(stone.x, stone.y, board) != EMPTY

  is_double_move = (move, board)->
    if board.moves.length >= 1
      last_move = board.moves[board.moves.length - 1]
      last_move.color == move.color
    else
      false

  is_suicide_move = (move, board)->
    not (has_liberties(move, board) or is_capturing_stones(move, board))

  is_capturing_stones = (move, board)->
    # we don't want to modify the original board as this is just a test
    copied_board = copy_board(board)
    set_move(move, copied_board)
    neighbours = enemy_neighbours(move, copied_board)
    not _.every neighbours, (stone)-> has_liberties(stone, copied_board)

  is_forbidden_ko_move = (move, board, captures)->
    return false if board.moves.length == 0
    last_move = board.moves[board.moves.length - 1]
    if captures.length == 1 && last_move.captures.length == 1
      capture = last_move.captures[0]
      if capture.x == move.x && capture.y == move.y && capture.color == move.color
        true
      else
        false
    else
      false


      
  if (field_is_occupied(stone, board) or is_double_move(stone, board))
    false
  else
    copied_board = copy_board(board)
    set_move(stone, copied_board)
    captures = capture_stones_with(stone, copied_board)
    if !is_empty(captures) or has_liberties(stone, copied_board)
      if !is_forbidden_ko_move(stone, board, captures)
        true
      else
        false
    else
      false

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

