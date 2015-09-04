create_stone = (x, y, color)->
  x: x
  y: y
  color: color

create_pass_move = (color)->
  pass = create_stone(null, null, color)
  pass.captures = []
  pass


# assumes that the move is valid (doesn't bother checking)
makeValidMove = (stone, board) ->
  unless is_pass_move(stone)
    set_stone(stone, board)
    assignGroup(stone, board)
    captures = capture_stones_with(stone, board)
    stone.captures = captures
  board.moves.push stone

countLiberties = (stone, board)->
  emptyNeighbours(stone, board).length

play_stone = (stone, board) ->
  if is_valid_move(stone, board)
    makeValidMove(stone, board)
  else
    throw "Illegal move Exception!"

is_pass_move = (stone)-> (stone.x == null) or (stone.y == null)

other_color = (color)->
  if color == BLACK
    WHITE
  else
    BLACK

has_liberties = (stone)->
  if stone.group
    stone.group.libertyCount > 0
  else
    # check if there is a neighbouring empty field OR a neighboring group of
    # the same color with 2+ liberties

is_valid_move = (stone, board) ->

  field_is_unoccupied = (stone, board)->
    get_color(stone.x, stone.y, board) == EMPTY

  is_no_double_move = (move, board)->
    if board.moves.length == 0
      true
    else
      get_last_move(board).color != move.color

  is_no_suicide_move = (move, board)->
    has_liberties(move, board) or is_capturing_stones(move, board)

  is_capturing_stones = (move, board)->
    # we don't want to modify the original board as this is just a test
    copied_board = copy_board(board)
    set_move(move, copied_board)
    neighbours = enemy_neighbours(move, copied_board)
    not _.every neighbours, (stone)-> has_liberties(stone, copied_board)

  is_no_illegal_ko_move = (move, board, captures)->

    isFirstOrSecondMove = (board)-> board.moves.length <= 1

    captures_of_move = (move, board)->
      copied_board = copy_board(board)
      set_move(stone, copied_board)
      capture_stones_with(stone, copied_board)


    return true if isFirstOrSecondMove(board)
    last_move = get_last_move(board)
    return true if last_move.captures.length != 1
    captures = captures_of_move(stone, board)
    return true if captures.length != 1
    not (is_same_move(last_move.captures[0], move) and
      is_same_move(captures[0], last_move))


  is_no_double_move(stone, board) and
  (is_pass_move(stone) or
    (field_is_unoccupied(stone, board) and
    is_no_suicide_move(stone, board) and
    is_no_illegal_ko_move(stone, board)))

is_same_move = (move, other_move)->
  move.x == other_move.x &&
  move.y == other_move.y &&
  move.color == other_move.color

capture_stones_with = (stone, board)->

  take_captures = (stone, board, captive_color)->
    captures = []
    # prevent recapturing the same stones/group? TODO
    if stone.color == captive_color
      group = stone.group
      captures = removeGroup(group, board)
      giveBackLiberties(group)
      captures.push stone
    captures

  giveBackLiberties = (group)->
    # it might be ok not to delete the liberties associated with other groups
    # as when they would need that information (because they were removed) from
    # the board, then other groups would have taken their place
    for key, enemyGroup of group.liberties
      enemyGroup.libertyCount += 1

  removeGroup = (group, board)->
    _.each group.stones, (stone)->
      removeStone(stone, board)
    group.stones

  removeStone = (stone, board)->
    empty_move = create_stone(stone.x, stone.y, EMPTY)
    set_move(empty_move, board)

  enemy_color = other_color(stone.color)
  captures = []
  unless is_pass_move(stone)
    _.each enemy_neighbours(stone, board), (stone)->
      unless has_liberties(stone)
        captures = captures.concat take_captures(stone, board, enemy_color)
  captures

is_eye = (move, board)->

  is_eye_shape = (move, board)->
    neighbours = neighbouring_stones(move.x, move.y, board)
    _.all neighbours, (neighbour)->
      neighbour.color == move.color or neighbour.color == NEUTRAL

  diagonal_stone_colors = (move, board)->
    x = move.x
    y = move.y
    [get_color(x + 1, y + 1, board), get_color(x + 1, y - 1, board),
     get_color(x - 1, y + 1, board), get_color(x - 1, y - 1, board)]

  is_edge_move = (move, board)->
    move.x == 0 or move.y == 0 or
    move.x == (board.length - 1) or move.y == (board.length - 1)

  get_enemy_diagonals_count = (move, board)->
    diagonal_stones = diagonal_stone_colors(move, board)
    opponent_color = other_color(move.color)
    _.select(diagonal_stones, (color)-> color == opponent_color).length

  is_real_eye = (move, board)->
    enemy_diagonals_count = get_enemy_diagonals_count(move, board)
    enemy_diagonals_count == 0 or
    (not is_edge_move(move, board) and enemy_diagonals_count < 2)

  if is_pass_move(move)
    false
  else
    is_eye_shape(move, board) and is_real_eye(move, board)
