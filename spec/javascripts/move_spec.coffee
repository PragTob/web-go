describe 'moves', ->
  board = null
  move = null
  capture_board = null

  initMove = -> move = create_stone 0, 0, BLACK

  create_one_capture_board = ->
    board_string = """
                   -X-
                   XO-
                   -X-
                   """
    board_from_string(board_string)

  capture_one_stone_move = -> create_stone(2, 1, BLACK)

  captured_one_stone_board = ->
    capture_board = create_one_capture_board()
    play_stone(capture_one_stone_move(), capture_board)
    capture_board


  create_2_capture_board = ->
    string = """
             -XX-
             XOO-
             -XX-
             ----
             """
    board_from_string(string)

  capture_2_stones_move = -> create_stone(3, 1, BLACK)

  captured_2_stones_board = ->
    capture_board = create_2_capture_board()
    play_stone(capture_2_stones_move(), capture_board)
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
      expect(is_valid_move(move, board)).toBeTruthy()

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
      expect(is_valid_move(move, board)).toBeTruthy()

    it 'is true for a pass move', ->
      move = create_pass_move(BLACK)
      expect(is_valid_move(move, board)).toBeTruthy()

    describe 'bugs/regressions', ->
      suicide_board = ->
        board_string = """
                       XXXX-XXO-
                       XO-XXXOXO
                       OOOXXXOXX
                       XXOXXXOXO
                       XXOXOOOOO
                       -XXOOOOXO
                       OXXO-OXXO
                       OOOOOOX--
                       OO--O-O-O
                       """
        board_from_string(board_string)

      suicide_board_move = -> create_stone(0, 5, BLACK)

      it 'is not  valid move as it is a suicide', ->
        expect(is_valid_move(suicide_board_move(), suicide_board())).toBeFalsy()

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
      board = create_one_capture_board()
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
      board = create_one_capture_board()
      set_move(create_stone(2, 1, BLACK), board)
      stone = get_stone(1, 1, board)
      expect(has_liberties(stone, board)).toBeFalsy()

    it 'is falsy for a turtle capture', ->
      board = create_2_capture_board()
      stone = get_stone(1, 1, board)
      set_move(create_stone(3, 1, BLACK), board)
      expect(has_liberties(stone, board)).toBeFalsy()

  describe 'capturing stones', ->
    capture_move = null
    describe 'simple capture', ->
      beforeEach ->
        capture_board = create_one_capture_board()
        capture_move = capture_one_stone_move()
        play_stone(capture_move, capture_board)

      it 'handles a simple capture and clears out the captured stone', ->
        expect(get_color(1, 1, capture_board)).toEqual EMPTY

      it 'saves the captures on the move', ->
        expect(capture_move.captures.length).toEqual(1)

    describe '2 captures', ->
      beforeEach ->
        capture_board = create_2_capture_board()
        capture_move = capture_2_stones_move()
        play_stone(capture_move, capture_board)

      it 'cleans up the two captured stones', ->
        expect(get_color(1, 1, capture_board)).toEqual EMPTY
        expect(get_color(2, 1, capture_board)).toEqual EMPTY


      it 'increases the captures of the capture move', ->
        expect(capture_move.captures.length).toEqual(2)

  describe 'capturing_stones_with', ->
    capture_board = null
    capture_move = null

    describe 'one capture', ->
      beforeEach ->
        capture_board = create_one_capture_board()
        capture_move = capture_one_stone_move()
        set_move(capture_move, capture_board)

      it 'returns an array with a single captured stone', ->
        captures = capture_stones_with(capture_move, capture_board)
        expect(captures.length).toEqual 1

      it 'captures the right stone', ->
        stone_to_be_captured = get_stone(1, 1, capture_board)
        captures = capture_stones_with(capture_move, capture_board)
        expect(captures).toEqual [stone_to_be_captured]

    describe '2 captures', ->
      beforeEach ->
        capture_board = create_2_capture_board()
        capture_move = capture_2_stones_move()
        set_move(capture_move, capture_board)

      it 'returns an array with a single captured stone', ->
        captures = capture_stones_with(capture_move, capture_board)
        expect(captures.length).toEqual 2

      it 'captures the right stones', ->
        first_to_be_captured = get_stone(1, 1, capture_board)
        second_to_be_captured = get_stone(2, 1, capture_board)
        captures = capture_stones_with(capture_move, capture_board)
        expect(captures).toContain first_to_be_captured
        expect(captures).toContain second_to_be_captured

    describe 'capturing 2 groups', ->

      create_capture_2_groups_board = ->
        board_string = """
                       -X-X-
                       XO-OX
                       -X-X-
                       -----
                       -----
                       """
        board_from_string(board_string)

      capture_2_groups_move = ->
        create_stone(2, 1, BLACK)

      beforeEach ->
        capture_board = create_capture_2_groups_board()
        capture_move = capture_2_groups_move()
        set_move(capture_move, capture_board)

      it 'captures 2 stones', ->
        captures = capture_stones_with(capture_move, capture_board)
        expect(captures.length).toEqual 2

      it 'captures the right 2 tones', ->
        first_to_be_captured = get_stone(1, 1, capture_board)
        second_to_be_captured = get_stone(3, 1, capture_board)
        captures = capture_stones_with(capture_move, capture_board)
        expect(captures).toContain first_to_be_captured
        expect(captures).toContain second_to_be_captured

  describe 'is_same_move', ->

    it 'returns true for identical moves', ->
      move1 = create_stone(1, 2, BLACK)
      move2 = create_stone(1, 2, BLACK)
      expect(is_same_move(move1, move2)).toBeTruthy()

    it 'returns false for a different color', ->
      move1 = create_stone(1, 2, BLACK)
      move2 = create_stone(1, 2, WHITE)
      expect(is_same_move(move1, move2)).toBeFalsy()

    it 'returns false for a different coordinate', ->
      move1 = create_stone(1, 3, BLACK)
      move2 = create_stone(1, 2, BLACK)
      expect(is_same_move(move1, move2)).toBeFalsy()



  describe 'KO', ->
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

  describe 'is_Eye', ->
    eye_move = null
    eye_board = null

    it 'is false for a pass move', ->
      expect(is_eye(create_pass_move(BLACK))).toBeFalsy()

    describe 'in the middle of the board', ->
      create_eye_board = ->
        board_string = """
                       -X-
                       X-X
                       -X-
                       """
        board_from_string(board_string)

      beforeEach ->
        eye_board = create_eye_board()
        eye_move = create_stone(1, 1, BLACK)

      it 'is an eye for black', ->
        expect(is_eye(eye_move, eye_board)).toBeTruthy()

      it 'is not an eye for white', ->
        eye_move.color = WHITE
        expect(is_eye(eye_move, eye_board)).toBeFalsy()

      it 'is still an eye with one of the diagonals occupied by the enemy', ->
        diagonal_move = create_stone(0, 0, WHITE)
        set_move diagonal_move, eye_board
        expect(is_eye(eye_move, eye_board)).toBeTruthy()

      it 'is no longer an eye with two diagonals occupied by the enemy', ->
        diagonal_move_1 = create_stone(0, 0, WHITE)
        diagonal_move_2 = create_stone(2, 2, WHITE)
        set_move diagonal_move_1, eye_board
        set_move diagonal_move_2, eye_board
        expect(is_eye(eye_move, eye_board)).toBeFalsy()

    describe 'on the edge of the board', ->
      create_edge_eye_board = ->
        board_string = """
                       X--
                       -X-
                       X--
                       """
        board_from_string(board_string)

      beforeEach ->
        eye_board = create_edge_eye_board()
        eye_move = create_stone(0, 1, BLACK)

      it 'is an eye', ->
        expect(is_eye(eye_move, eye_board)).toBeTruthy()

      it 'is not an eye for white', ->
        eye_move.color = WHITE
        expect(is_eye(eye_move, eye_board)).toBeFalsy()

      it 'is not an eye any longer with one diagonal occupied', ->
        diagonal_move = create_stone(1, 0, WHITE)
        set_move(diagonal_move, eye_board)
        expect(is_eye(eye_move, eye_board)).toBeFalsy()



