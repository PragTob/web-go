BLACK = 1
WHITE = -1
EMPTY = 0
NEUTRAL = 2
VISITED = true

create_move = (x, y, color)->
  x: x
  y: y
  color: color

create_pass_move = (color)-> create_move(null, null, color)

set_move = (move, board)->
  set_stone(move, board) unless is_out_of_bounds move.x, move.y, board

set_stone = (move, board)-> board[move.y][move.x] = move.color


play_move = (move, board) ->
  unless is_pass_move(move)
    if is_valid_move(move, board)
      set_move(move, board)
      capture_stones(move, board)
    else
      console.log "invalid move:"
      console.log move
      console.log print_board(board)
      throw "Not a valid move! This should never happen!!!"
  board.moves.push move

is_pass_move = (move)-> (move.x == null) or (move.y == null)

other_color = (color)->
  if color == BLACK
    WHITE
  else
    BLACK

coord_has_liberties = (coord, board)->
  move = create_move(coord.x, coord.y, get_stone(coord.x, coord.y, board))
  has_liberties(move, board)

enemy_neighbours = (move, copy_board)->
  neighbours = neighbouring_coordinates(move.x, move.y)
  _.select neighbours, (coord)->
    get_stone(coord.x, coord.y, copy_board) == other_color(move.color)

has_liberties = (move, board)->

  is_visited = (coordinate, visited_mapping)->
    get_stone(coordinate.x, coordinate.y, visited_mapping) == VISITED

  visit = (coordinate, visited_mapping)->
    visited_move = create_move(coordinate.x, coordinate.y, VISITED)
    set_move(visited_move, visited_mapping)

  is_liberty = (coordinate, board, visited_map, color)->
      stone = get_stone(coordinate.x, coordinate.y, board)
      switch stone
        when EMPTY then true
        when NEUTRAL then false
        when other_color(color) then false
        when color
          search_for_liberties  coordinate.x,
                                coordinate.y,
                                board,
                                visited_map,
                                color
        else throw 'we should never end up here'

  search_for_liberties = (x, y, board, visited_map, color) ->
    neighbours = neighbouring_coordinates(x, y)
    unvisited_neighbours = _.reject neighbours, (coordinate)->
      is_visited(coordinate, visited_map)
    _.each unvisited_neighbours, (coordinate)-> visit(coordinate, visited_map)
    _.any unvisited_neighbours, (coordinate)->
      is_liberty(coordinate, board, visited_map, color)

  visited_map = initBoard(board.length)
  search_for_liberties(move.x, move.y, board, visited_map, move.color)

is_valid_move = (move, board) ->

  field_is_occupied = (field)-> field != EMPTY

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
    enemy_neighbours = enemy_neighbours(move, copy_board);

    not _.every enemy_neighbours, (coord)->

  stone = get_stone move.x, move.y, board
  if (field_is_occupied(stone) or
     is_double_move(move, board) or
     is_suicide_move(move, board))
    false
  else
    true

capture_stones = (move, board)->

  take_captures = (coordinate, board, captive_color)->
    stone = get_stone(coordinate.x, coordinate.y, board)
    if stone == captive_color
      remove_stone(coordinate, board)
      increase_prisoner_count(board, captive_color)
      neighbours = neighbouring_coordinates(coordinate.x, coordinate.y)
      _.each neighbours, (coord)-> take_captures(coord, board, captive_color)

  remove_stone = (coordinate, board) ->
    empty_move = create_move(coordinate.x, coordinate.y, EMPTY)
    set_stone(empty_move, board)

  increase_prisoner_count = (board, captive_color)->
    own_color = other_color(captive_color)
    board.prisoners[own_color] += 1


  enemy_color = other_color(move.color)
  _.each enemy_neighbours(move, board), (coordinate)->
    unless coord_has_liberties(coordinate, board)
      take_captures(coordinate, board, enemy_color)


