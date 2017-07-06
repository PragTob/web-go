forceNextMoveToBe = (color, board)->
  oppositeColor = other_color(color)
  board.moves.push create_pass_move(oppositeColor)

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
    forceNextMoveToBe(BLACK, board)
    old_max_try = MAXIMUM_TRY_MODIFICATOR
    # minimize chances of falsely creating a pass move
    # (false in the context of this spec)
    MAXIMUM_TRY_MODIFICATOR = 200
    move = generate_random_move_for(board)
    MAXIMUM_TRY_MODIFICATOR = old_max_try
    expect(move).toEqual create_stone(0, 0, BLACK)

finished_tiny_game = ->
  board_string = """
                 -XXO-
                 XXO-O
                 -XOO-
                 XXOOO
                 XXXXO
                 """
  board_from_string(board_string)

describe 'scoring (chinese/area)', ->

  it 'knows about Komi', ->
    board = initBoard(1)
    expect(score_game(board)[WHITE]).toBeGreaterThan 6

  it 'has no points on an empty board for black', ->
    board = initBoard(1)
    expect(score_game(board)[BLACK]).toEqual 0

  it 'scores a tiny game right', ->
    board = finished_tiny_game()
    score = score_game(board)
    expect(score[BLACK]).toEqual(13)
    expect(score[WHITE]).toEqual(12 + KOMI)
    expect(score.winner).toEqual WHITE

describe 'get_all_plausible_moves', ->
  it 'marks all moves as plausible for an empty board', ->
    board = initBoard(3)
    expect(get_all_plausible_moves(board).length).toEqual 9

  it 'generates black moves for an empty board', ->
    board = initBoard(3)
    all_black = _.every get_all_plausible_moves(board), (move)-> move.color == BLACK
    expect(all_black).toBeTruthy()

  it 'generates all white moves if a black move has been played before', ->
    board = initBoard(3)
    play_stone(create_stone(1, 1, BLACK), board)
    all_white = _.every get_all_plausible_moves(board), (move)-> move.color == WHITE
    expect(all_white).toBeTruthy()

  it 'does not find any moves for a finished game', ->
    board = finished_tiny_game()
    expect(get_all_plausible_moves(board).length).toEqual 0

  describe 'finds the right number of moves for a tiny game', ->
    board = null

    tiny_game = ->
      board_string = """
                     -X--O
                     X-OO-
                     XXOOO
                     X-X-X
                     """
      board_from_string(board_string)

    beforeEach -> board = tiny_game()

    it 'finds the right number of black moves', ->
      forceNextMoveToBe(BLACK, board)
      expect(get_all_plausible_moves(board).length).toEqual 5

    it 'finds the right number of white moves', ->
      forceNextMoveToBe(WHITE, board)
      expect(get_all_plausible_moves(board).length).toEqual 4
