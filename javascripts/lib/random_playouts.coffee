MAXIMUM_CREATION_TRIES = 1000

generate_random_move_for = (board)->

  determine_move_color = (board)->
    if board.moves.length == 0
      BLACK
    else
      other_color(get_last_move(board).color)

  random_coordinate = (size)-> Math.floor(Math.random() * size)

  create_ramdom_move = (size, color, tries)->
    if tries <= MAXIMUM_CREATION_TRIES
      create_stone(random_coordinate(size), random_coordinate(size), color)
    else
      create_pass_move(color)

  size = board.length
  color = determine_move_color(board)
  tries = 0
  move = create_ramdom_move(size, color, tries)
  tries += 1
  until is_valid_move(move, board) and not is_eye(move, board)
    move = create_ramdom_move(size, color, tries)
    tries += 1
  move


is_finished_game = (board)->
  if board.moves.length > 2
    is_pass_move(get_last_move(board)) && (is_pass_move(board.moves[board.moves.length - 2]))

playout_for_board = (board)->
  until is_finished_game(board)
    move = generate_random_move_for(board)
    play_stone(move, board)
  board