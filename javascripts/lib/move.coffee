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

set_move = (move, board)->
  set_stone(move, board) unless is_out_of_bounds move.x, move.y, board

set_stone = (stone, board)-> board[stone.y][stone.x] = stone.color


play_stone = (stone, board) ->
  unless is_pass_move(stone)
    if is_valid_move(stone, board)
      set_move(stone, board)
      capture_stones_with(stone, board)
    else
      throw "Not a valid move! This should never happen!!!"
  board.moves.push stone

is_pass_move = (stone)-> (stone.x == null) or (stone.y == null)

other_color = (color)->
  if color == BLACK
    WHITE
  else
    BLACK

enemy_neighbours = (my_stone, board)->
  neighbours = neighbouring_stones(my_stone.x, my_stone.y, board)
  enemy_color = other_color(my_stone.color)
  _.select neighbours, (neighbouring_stone)->
    neighbouring_stone.color == enemy_color

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
        else throw 'we should never end up here'

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
    copy_board = board.clone()
    set_move(move, copy_board)
    enemy_neighbours = enemy_neighbours(move, copy_board)
    not _.every enemy_neighbours, (stone)-> has_liberties(stone, copy_board)
      
  if (field_is_occupied(stone, board) or
     is_double_move(stone, board) or
     is_suicide_move(stone, board))
    false
  else
    true

capture_stones_with = (stone, board)->

  take_captures = (stone, board, captive_color)->
    if stone.color == captive_color
      remove_stone(stone, board)
      increase_prisoner_count(board, captive_color)
      neighbours = neighbouring_stones(stone.x, stone.y, board)
      _.each neighbours, (stone)-> take_captures(stone, board, captive_color)

  remove_stone = (stone, board) ->
    empty_move = create_stone(stone.x, stone.y, EMPTY)
    set_move(empty_move, board)

  increase_prisoner_count = (board, captive_color)->
    own_color = other_color(captive_color)
    board.prisoners[own_color] += 1


  enemy_color = other_color(stone.color)
  console.log stone
  console.log enemy_neighbours(stone, board)
  _.each enemy_neighbours(stone, board), (stone)->
    unless has_liberties(stone, board)
      console.log 'no liberties!!!'
      take_captures(stone, board, enemy_color)


