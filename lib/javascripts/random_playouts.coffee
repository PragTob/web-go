KOMI = 6.5

generate_random_move_for = (board)->

  random_coordinate = (size)-> Math.floor(Math.random() * size)

  get_maximum_tries = (size)-> 2 * size * size

  create_ramdom_move = (size, color, tries, maximum_tries)->
    if tries <= maximum_tries
      create_stone(random_coordinate(size), random_coordinate(size), color)
    else
      create_pass_move(color)

  size = board.size
  maximum_tries = get_maximum_tries(size)
  color = determine_move_color(board)
  tries = 0
  move = create_ramdom_move(size, color, tries, maximum_tries)
  tries += 1
  until is_plausible_move(move, board)
    move = create_ramdom_move(size, color, tries, maximum_tries)
    tries += 1
  move

determine_move_color = (board)->
  if board.moves.length == 0
    BLACK
  else
    other_color(get_last_move(board).color)

is_plausible_move = (move, board)->
  is_valid_move(move, board) and not is_eye(move, board)

get_all_plausible_moves = (board)->
  move_color = determine_move_color(board)
  plausible_moves = []
  all_fields_do board, (x, y, field_color)->
    if field_color == EMPTY
      move = create_stone(x, y, move_color)
      plausible_moves.push move if is_plausible_move(move, board)
  plausible_moves

is_finished_game = (board)->
  if board.moves.length > 2
    is_pass_move(get_last_move(board)) && (is_pass_move(board.moves[board.moves.length - 2]))

playout_for_board = (board)->
  until is_finished_game(board)
    move = generate_random_move_for(board)
    play_stone(move, board)
  board

score_game = (board)->

  init_score =  ->
    score = {}
    score[WHITE] = KOMI
    score[BLACK] = 0
    score

  count_score = (board, score)->
    all_fields_do board, (x, y, color)->
      if color != EMPTY
        score[color] += 1
      else
        determine_score_for_empty(x, y, board, score)

  determine_score_for_empty = (x, y, board, score)->
    colored_neighbours = _.select(neighbouring_stones(x, y, board), (stone)->
      stone.color == BLACK or stone.color == WHITE)
    if colored_neighbours.length >= 1
      neighbour_color = colored_neighbours[0].color
      all_same_color = _.all(colored_neighbours, (neighbour)->
        neighbour.color == neighbour_color)
      score[neighbour_color] += 1 if all_same_color

  determine_winner = (score)->
    if score[WHITE] > score[BLACK]
      score.winner = WHITE
    else
      score.winner = BLACK

  score = init_score()
  count_score(board, score)
  determine_winner(score)
  score



