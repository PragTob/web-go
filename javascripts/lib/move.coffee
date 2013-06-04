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
  unless is_out_of_bounds move.x, move.y, board
    board[move.y][move.x] = move.color

play_move = (move, board) ->
  unless is_pass_move(move)
    if is_valid_move(move, board)
      set_move(move, board)
    else
      throw "Not a valid move! This should never happen!!!"
  board.moves.push move

is_pass_move = (move)-> (move.x == null) or (move.y == null)

is_valid_move = (move, board) ->

  field_is_occupied = (field)-> field != EMPTY

  is_double_move = (move, board)->
    if board.moves.length >= 1
      last_move = board.moves[board.moves.length - 1]
      last_move.color == move.color
    else
      false

  other_color = (color)->
    if color == BLACK
      WHITE
    else
      BLACK

  has_liberties = (move, board)->

    is_visited = (coordinate, visited_mapping)->
      get_stone(coordinate.x, coordinate.y, visited_mapping) == VISITED

    visit = (coordinate, visited_mapping)->
      visited_move = create_move(coordinate.x, coordinate.y, VISITED)
      set_move(visited_move, visited_mapping)

    is_liberty_for_function = (color, board, visited_map)->
      (coordinate)->
        stone = get_stone(coordinate.x, coordinate.y, board)
        switch stone
          when EMPTY then true
          when NEUTRAL then false
          when other_color(color) then false
          when color
            search_for_liberties coordinate.x, coordinate.y, board, visited_map, this
          else throw 'we should never end up here'


    search_for_liberties = (x, y, board, visited_map, is_liberty) ->
      neighbours = all_neighbouring_coordinates(x, y)
      unvisited_neighbours = _.reject neighbours, (coordinate)->
        is_visited(coordinate, visited_map)
      _.each unvisited_neighbours, (coordinate)-> visit(coordinate, visited_map)
      _.any unvisited_neighbours, (coordinate)-> is_liberty(coordinate)

    visited_map = initBoard(board.length)
    is_liberty = is_liberty_for_function(move.color, board, visited_map)
    search_for_liberties(move.x, move.y, board, visited_map, is_liberty)

  is_suicide_move = (move, board)-> !has_liberties(move, board)

#  captures_stones = (move, board)

  stone = get_stone move.x, move.y, board
  if (field_is_occupied(stone) or
     is_double_move(move, board) or
     is_suicide_move(move, board))
    false
  else
    true