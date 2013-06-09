describe 'moves', ->
  board = null
  move = null
  capture_board = null

  initMove = -> move = create_stone 0, 0, BLACK

  create_simple_capture_board = ->
    board_string = """
                   -X-
                   XO-
                   -X-
                   """
    board_from_string(board_string)

  capture_one_stone = ->
    capture_board = create_simple_capture_board()
    play_stone(create_stone(2, 1, BLACK), capture_board)
    capture_board


  create_2_capture_board = ->
    string = """
             -XX-
             XOO-
             -XX-
             ----
             """
    board_from_string(string)

  capture_2_stones = ->
    capture_board = create_2_capture_board()
    play_stone(create_stone(3, 1, BLACK), capture_board)
    capture_board

  create_ko_board = ->
    string = """
             -XO-
             X-XO
             -XO-
             ----
             """
    board_from_string(string)

  beforeEach ->
    board = initBoard(3)
    initMove()

  describe 'create_stone', ->
    it 'creates a move with the right x', ->
      expect(move.x).toBe(0)

    it 'creates a move with the right y', ->
      expect(move.y).toBe(0)

    it 'creates a move with the right color', ->
      expect(move.color).toBe(BLACK)

  describe 'other_color', ->
    it 'returns black for white', ->
      expect(other_color(BLACK)).toBe(WHITE)

    it 'returns white for black', ->
      expect(other_color(WHITE)).toBe(BLACK)

  describe 'play_stone', ->
    beforeEach ->
      play_stone move, board

    it 'can make a black move', ->
      expect(get_color(0, 0, board)).toBe(BLACK)

    it 'saves the moves in the moves list', ->
      expect(board.moves[0]).toEqual move

    it 'also saves the next move in the list', ->
      next_move = create_stone 1, 1, WHITE
      play_stone(next_move, board)
      expect(board.moves[1]).toEqual next_move

    it 'is legal to pass', ->
      pass = create_pass_move()
      play_stone(pass, board)
      expect(is_pass_move(board.moves[1])).toBeTruthy()

  describe 'is_valid_move', ->
    it 'is a valid move', ->
      expect(is_valid_move(move, board)).toBeTruthy

    it 'can not play moves if the field is already occupied', ->
      set_move move, board
      move = create_stone 0, 0, WHITE
      expect(is_valid_move(move, board)).toBeFalsy()

    it 'can not play moves by the same color in succession', ->
      first_move = create_stone 0, 0, BLACK
      second_move = create_stone 1, 1, BLACK
      play_stone first_move, board
      expect(is_valid_move(second_move, board)).toBeFalsy()

    it 'does not allow suicide moves', ->
      string = """
               -X-
               X-X
               -X-
               """
      board = board_from_string(string)
      move = create_stone(1, 1, WHITE)
      expect(is_valid_move(move, board)).toBeFalsy()

    it "checks if stones are captured so that it's not a suicide move", ->
      board = create_ko_board()
      move = create_stone(1, 1, WHITE)
      expect(is_valid_move(move, board)).toBeTruthy

  describe 'has_liberties', ->
    it 'is true for a single lonely stone', ->
      board = initBoard(3)
      stone = create_stone(1, 1, BLACK)
      set_move(stone, board)
      expect(has_liberties(stone, board)).toBeTruthy()

    it 'is true on the edge of the board', ->
      board = initBoard(3)
      stone = create_stone(0, 0, BLACK)
      set_move(stone, board)
      expect(has_liberties(stone, board)).toBeTruthy()

    it 'is true even with just one liberty', ->
      board = create_simple_capture_board()
      stone = get_stone(1, 1, board)
      expect(has_liberties(stone, board)).toBeTruthy()

    it 'is true even if just one stone of the group has the liberty', ->
      board = create_2_capture_board()
      stone = get_stone(1, 1, board)
      expect(has_liberties(stone, board)).toBeTruthy()

    it 'is falsy for a surrounded corner stone', ->
      board = initBoard(3)
      stone = create_stone(0, 0, BLACK)
      set_move(stone, board)
      set_move(create_stone(0, 1, WHITE), board)
      set_move(create_stone(1, 0, WHITE), board)
      expect(has_liberties(stone, board)).toBeFalsy()

    it 'is falsy for a classic star catch', ->
      board = create_simple_capture_board()
      set_move(create_stone(2, 1, BLACK), board)
      stone = get_stone(1, 1, board)
      expect(has_liberties(stone, board)).toBeFalsy()

    it 'is falsy for a turtle capture', ->
      board = create_2_capture_board()
      stone = get_stone(1, 1, board)
      set_move(create_stone(3, 1, BLACK), board)
      expect(has_liberties(stone, board)).toBeFalsy()

  describe 'capturing stones', ->
    describe 'simple capture', ->
      beforeEach ->
        capture_board = capture_one_stone()

      it 'handles a simple capture and clears out the captured stone', ->
        expect(get_color(1, 1, capture_board)).toEqual EMPTY

      it 'increases the prisoner count of the capturerer', ->
        expect(capture_board.prisoners[BLACK]).toEqual(1)

    describe '2 captures', ->
      beforeEach ->
        capture_board = capture_2_stones()

      it 'cleans up the two captured stones', ->
        expect(get_color(1, 1, capture_board)).toEqual EMPTY
        expect(get_color(2, 1, capture_board)).toEqual EMPTY


      it 'increases the prisoner count of the capturerer by 2', ->
        expect(capture_board.prisoners[BLACK]).toEqual(2)

  xdescribe 'KO', ->
    ko_board = null

    beforeEach ->
      ko_board = create_ko_board()

    first_ko_capture = (board)->
      play_stone(create_stone(1, 1, WHITE), board)
      board


    it 'can play the first ko move and capture the stone',->
      ko_board = first_ko_capture(ko_board)
      expect(get_color(2, 1, ko_board)).toEqual(EMPTY)

    it 'is not legal to capture the ko back immediately', ->
      ko_board = first_ko_capture(ko_board)
      move = create_stone(2, 1, BLACK)
      expect(is_valid_move(move, ko_board)).toBeFalsy()

    it 'is ok to play somewhere else after the KO', ->
      ko_board = first_ko_capture(ko_board)
      move = create_stone(0, 3, BLACK)
      expect(is_valid_move(move, ko_board)).toBeTruthy()

    it 'is ok to close the KO after a threat or something', ->
      ko_board = first_ko_capture(ko_board)
      play_stone(create_stone(0, 3, BLACK), ko_board)
      move = create_stone(2, 1, WHITE)
      expect(is_valid_move(move, ko_board)).toBeTruthy()

    it 'is ok to take the stone after a ko threat has been answered', ->
      ko_board = first_ko_capture(ko_board)
      play_stone(create_stone(0, 3, BLACK), ko_board)
      play_stone(create_stone(2, 3, WHITE), ko_board)
      move = create_stone(2, 1, BLACK)
      expect(is_valid_move(move, ko_board)).toBeTruthy()
