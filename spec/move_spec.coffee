describe 'moves', ->

  board = null
  move = null

  create_ko_board = ->
    ko_board = initBoard(7)
    play_move(create_move(2, 2, BLACK), ko_board)
    play_move(create_move(3, 2, WHITE), ko_board)
    play_move(create_move(1, 3, BLACK), ko_board)
    play_move(create_move(4, 3, WHITE), ko_board)
    play_move(create_move(2, 4, BLACK), ko_board)
    play_move(create_move(3, 4, WHITE), ko_board)
    play_move(create_move(3, 3, BLACK), ko_board)
    play_move(create_move(2, 3, WHITE), ko_board)
    console.log print_board(ko_board)

  initMove = -> move = create_move 0, 0, BLACK

  beforeEach ->
    board = initBoard(3)
    initMove()

  describe 'create_move', ->
    it 'creates a move with the right x', ->
      expect(move.x).toBe(0)

    it 'creates a move with the right y', ->
      expect(move.y).toBe(0)

    it 'creates a move with the right color', ->
      expect(move.color).toBe(BLACK)


  describe 'play_move', ->

    beforeEach ->
      play_move move, board

    it 'can make a black move', ->
      expect(get_field(0, 0, board)).toBe(BLACK)

    it 'saves the moves in the moves list', ->
      expect(board.moves[0]).toEqual move

    it 'also saves the next move in the list', ->
      next_move = create_move 1, 1, WHITE
      play_move(next_move, board)
      expect(board.moves[1]).toEqual next_move

  describe 'is_valid_move', ->
    it 'is a valid move', ->
      expect(is_valid_move(move, board)).toBeTruthy

    it 'can not play moves if the field is already occupied', ->
      play_move move, board
      move = create_move 0, 0, WHITE
      expect(is_valid_move(move, board)).toBeFalsy()

    it 'can not play moves by the same color in succession', ->
      first_move = create_move 0, 0, BLACK
      second_move = create_move 1, 1, BLACK
      play_move first_move, board
      console.log board
      expect(is_valid_move(second_move, board)).toBeFalsy()

    describe 'KO', ->

      beforeEach ->
        ko_board = create_ko_board()

      it 'bla',->