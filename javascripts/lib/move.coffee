BLACK = 1
WHITE = -1
EMPTY = 0
NEUTRAL = 2

create_move = (x, y, color)->
  x: x
  y: y
  color: color

create_pass_move = (color)-> create_move(null, null, color)

set_move = (move, board)-> board[move.y][move.x] = move.color

play_move = (move, board) ->
  unless is_pass_move(move)
    if is_valid_move(move, board)
      board[move.y][move.x] = move.color
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

    is_visited = (x, y, visited_mapping)->
      get_stone(x, y, visited_mapping) == true

    visit = (x, y, visited_mapping)->
      visited_move =
        x:      x,
        y:      y,
        color:  true
      set_move(visited_move, visited_mapping)

    opponent_color = other_color(move.color)
    visited_map = initBoard(board.length) # needed to prevent infinite recursion

    all_neighbours_satisfy (x, y, board)->
      return false if is_visited(x, y, visited_map)
      visit(x, y, visited_map)
      stone = get_stone(x, y, board)
      switch stone
        when EMPTY then true
        when NEUTRAL then false
        when opponent_color then false
        when move.color then all_neighbours_satisfy(stone_has_no_liberties)
        else throw 'we should never end up here'




  is_suicide_move = (move, board)->

#  captures_stones = (move, board)

  field = get_stone move.x, move.y, board
  return false if field_is_occupied(field) or is_double_move(move, board)
  true