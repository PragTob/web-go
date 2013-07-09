describe 'random_move_generation', ->
  board = null

  beforeEach -> board = initBoard(3)

  it 'creates a valid move', ->
    move = generate_random_move_for(board)
    expect(is_valid_move(move, board)).toBeTruthy()

  it 'starts out with a black move', ->
    move = generate_random_move_for(board)
    expect(move.color).toEqual BLACK

  it 'generates a white move after a black move was played', ->
    play_stone(create_stone(1, 2, BLACK), board)
    move = generate_random_move_for(board)
    expect(move.color).toEqual WHITE

  it 'creates a pass move when it can not find a valid move', ->
    mini_board = initBoard(1)
    lil_move = create_stone(0, 0, BLACK)
    set_stone(lil_move, mini_board)
    mini_board.moves.push lil_move
    move = generate_random_move_for(mini_board)
    expect(is_pass_move(move)).toBeTruthy()