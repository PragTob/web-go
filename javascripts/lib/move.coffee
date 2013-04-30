BLACK = 1
WHITE = -1
EMPTY = 0
NEUTRAL = 2

create_move = (x, y, color)->
  x: x
  y: y
  color: color

play_move = (move, board) ->
  board[move.x][move.y] = move.color
  board.moves.push move

is_valid_move = (move, board) ->

  field_is_occupied = (field)-> field != EMPTY
  is_double_move = (move, board)->
    if board.moves.length >= 1
      last_move = board.moves[board.moves.length - 1]
      last_move.color == move.color
    else
      false


  field = get_field move.x, move.y, board
  return false if field_is_occupied(field) or is_double_move(move, board)
  true