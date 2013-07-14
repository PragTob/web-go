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

  small_first_line_board = ->
    board_string = """
                   -X
                   OX
                   """
    board_from_string(board_string)

  it 'can generate a random move on the first line', ->
    board = small_first_line_board()
    move = generate_random_move_for(board)
    expect(move).toEqual create_stone(0, 0, BLACK)

describe 'scoring (chinese/area)', ->

  it 'knows about Komi', ->
    board = initBoard(1)
    expect(score_game(board)[WHITE] > 6).toBeTruthy()

  it 'has no points on an empty board for black', ->
    board = initBoard(1)
    expect(score_game(board)[BLACK]).toEqual 0

  it 'scores a tiny game right', ->
    board_string = """
                   -XXO-
                   XXO-O
                   -XOO-
                   XXOOO
                   XXXXO
                   """
    board = board_from_string(board_string)
    score = score_game(board)
    expect(score[BLACK]).toEqual(13)
    expect(score[WHITE]).toEqual(12 + KOMI)
    expect(score.winner).toEqual WHITE
