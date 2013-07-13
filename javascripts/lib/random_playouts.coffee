MAXIMUM_CREATION_TRIES = 1000

generate_random_move_for = (board)->

  determine_move_color = (board)->
    if board.moves.length == 0
      BLACK
    else
      other_color(get_last_move(board).color)

  random_coordinate = (size)-> Math.floor(Math.random() * size) + 1

  create_ramdom_move = (size, color, tries)->
    if tries <= MAXIMUM_CREATION_TRIES
      tries += 1
      create_stone(random_coordinate(size), random_coordinate(size), color)
    else
      create_pass_move(color)

  size = board.length
  color = determine_move_color(board)
  move = create_ramdom_move(size, color, 0)
  move = create_ramdom_move(size, color, tries) until is_valid_move(move, board)
  move
