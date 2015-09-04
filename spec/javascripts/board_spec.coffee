describe 'Board', ->
  board = null

  beforeEach ->
    board = initBoard(3)

  describe 'initialization', ->
    it 'is initialized with an empty moves array', ->
      expect(board.moves).toEqual []

  describe 'is_empty', ->
    it 'returns true for an empty Array', ->
      expect(is_empty([])).toBeTruthy()

    it 'returns false for a non empty Arra', ->
      expect(is_empty([1])).toBeFalsy()

  describe 'get_color', ->
    it 'gets the color at the specified position', ->
      set_move(create_stone(1, 2, BLACK), board)
      expect(get_color(1, 2, board)).toBe BLACK

    it 'gets the color at the top left', ->
      set_move(create_stone(0, 0, WHITE), board)
      expect(get_color(0,0,board)).toBe WHITE

    it 'gets the color at the bottom right', ->
      set_move(create_stone(2, 2, WHITE), board)
      expect(get_color(2,2,board)).toBe WHITE

    it 'gets the empty value', ->
      expect(get_color(1, 1, board)).toBe EMPTY

    it 'returns neutral for x-values smaller than 0', ->
      expect(get_color(-1, 2, board)).toBe NEUTRAL

    it 'returns neutral for y-values smaller than 0', ->
      expect(get_color(1, -1, board)).toBe NEUTRAL

    it 'returns neutral for x-values greater than the board length', ->
      expect(get_color(3, 2, board)).toBe NEUTRAL

    it 'returns neutral for y-values greater than the board length', ->
      expect(get_color(1, 3, board)).toBe NEUTRAL

  describe 'copy_board', ->

    it 'copies the board itself over with values', ->
      set_move(create_stone(1, 2, BLACK), board)
      copy = copy_board board
      expect(get_color(1, 2, copy)).toEqual BLACK

    it 'copies the moves property over', ->
      move = create_stone(1, 1, BLACK)
      board.moves.push move
      copy = copy_board(board)
      expect(copy.moves).toEqual board.moves

    it 'does not alter the original', ->
      copy = copy_board(board)
      set_move(create_stone(1, 1, WHITE), copy)
      expect(get_color(1, 1, board)).toEqual EMPTY

    it 'should not be the same', ->
      copy = copy_board(board)
      expect(copy == board).toBeFalsy


  describe 'neighbours', ->
    neighbour_board = null
    neighbours = null

    create_neighbour_board = ->
      board_string = """
                     -X-
                     X--
                     -X-
                     """
      board_from_string(board_string)

    is_colored = (color)->
      (stone)-> color == stone.color

    return_color = (stone)->
      switch stone.color
        when BLACK then 'black'
        when WHITE then 'white'
        else 'neutral'

    beforeEach ->
      neighbour_board = create_neighbour_board()

    describe 'neighbouring_stones', ->
      describe 'with a black move played', ->
        beforeEach ->
          set_move(create_stone(2, 1, BLACK), neighbour_board)
          neighbours = neighbouring_stones(1, 1, neighbour_board)

        it 'counts 4 black stones', ->
          color_mapping = _.countBy(neighbours, return_color)
          expect(color_mapping['black']).toBe(4)


        it 'works to check if all surrounding stones are black when they are', ->
          all_black = _.every(neighbours, is_colored(BLACK))
          expect(all_black).toBeTruthy()

      describe 'with a white move played', ->
        beforeEach ->
          set_move(create_stone(2, 1, WHITE), neighbour_board)
          neighbours = neighbouring_stones(1, 1, neighbour_board)

        it 'counts 3 black stones and one white', ->
          color_mapping = _.countBy(neighbours, return_color)
          expect(color_mapping['black']).toBe(3)
          expect(color_mapping['white']).toBe(1)

        it 'works to check if all surrounding stones are black when its wrong', ->
          all_black = _.every(neighbours, is_colored(BLACK))
          expect(all_black).toBeFalsy()

    describe 'enemy_neighbours', ->
      it 'retutns an empty array if there are no neighbours', ->
        stone = get_stone(1, 0, neighbour_board)
        neighbours = enemy_neighbours(stone, neighbour_board)
        expect(is_empty(neighbours)).toBeTruthy()

      it 'returns an empty array if all the neighbours are friends', ->
        stone = create_stone(1, 1, BLACK)
        set_move(stone, neighbour_board)
        neighbours = enemy_neighbours(stone, neighbour_board)
        expect(is_empty(neighbours)).toBeTruthy()

      it 'returns an array with as many elements as enemies', ->
        stone = create_stone(1, 1, WHITE)
        set_move(stone, neighbour_board)
        neighbours = enemy_neighbours(stone, neighbour_board)
        expect(neighbours.length).toBe 3


  describe 'string conversions', ->
    board_string = """
                    -X-
                    ---
                    O--
                    """

    describe 'board_to_string', ->
      it 'prints a beautiful board', ->
        set_move(create_stone(1, 0, BLACK), board)
        set_move(create_stone(0, 2, WHITE), board)
        expect(board_to_string(board)).toEqual board_string


    describe 'board_from_string', ->
      board = null

      beforeEach ->
        board = board_from_string(board_string)

      it 'takes a simple string and creates a corresponging board', ->
        expect(get_color(0, 0, board)).toBe EMPTY
        expect(get_color(1, 0, board)).toBe BLACK
        expect(get_color(0, 2, board)).toBe WHITE

      it 'also assigns the stones their groups (black stone)', ->
        blackStone = get_stone(1, 0, board)
        blackGroup = blackStone.group
        expect(blackGroup.libertyCount).toBe 1
        expect(blackGroup.stones[0]).toBe blackStone

      it 'also assigns the stones their groups (white stone)', ->
        whiteStone = get_stone(0, 2, board)
        whiteGroup = whiteStone.group
        expect(whiteGroup.libertyCount).toBe 1
        expect(whiteGroup.stones[0]).toBe whiteStone

  describe 'is_equal_board', ->
    it 'is true for empty boards of the same size', ->
      expect(is_equal_board(initBoard(3), initBoard(3))).toBeTruthy()

    it 'is false for empty boards of different size', ->
      expect(is_equal_board(initBoard(2), initBoard(3))).toBeFalsy()

    it 'is falsy when one of the boards has a move played', ->
      board = initBoard(3)
      set_move(create_stone(1, 1, BLACK), board)
      expect(is_equal_board(board, initBoard(3))).toBeFalsy()

    it 'is true when both boards have the same move played', ->
      board_1 = initBoard(3)
      board_2 = initBoard(3)
      move = create_stone(1, 1, BLACK)
      set_move(move, board_1)
      set_move(move, board_2)
      expect(is_equal_board(board_1, board_2)).toBeTruthy()

    describe 'with a preset board', ->
      string = """
               ---
               X-O
               -XO
               """
      board_1 = null
      board_2 = null

      beforeEach ->
        board_1 = board_from_string(string)
        board_2 = board_from_string(string)

      it 'is true', ->
        expect(is_equal_board(board_1, board_2)).toBeTruthy()

      it 'is false when one board has a move applied', ->
        set_move(create_stone(0, 0, BLACK), board_1)
        expect(is_equal_board(board_1, board_2)).toBeFalsy()

      it 'is wrong if one of the existing stones is changed', ->
        set_move(create_stone(0, 1, WHITE), board_1)
        expect(is_equal_board(board_1, board_2)).toBeFalsy()

  describe 'get_last_move', ->
    it 'returns the last move', ->
      move = create_stone(1, 2, BLACK)
      play_stone(move, board)
      expect(get_last_move(board)).toEqual move

    it 'returns null if there is no last move', ->
      expect(get_last_move(board)).toBeNull()

  describe 'all_fields_do', ->
    call_count = null

    verify_calls_to_color = (stone_color, number)->
      all_fields_do(board, (x, y, color)-> call_count++ if color == stone_color)
      expect(call_count).toEqual number

    all_fields_board = ->
      board_string = """
                     XO-
                     XO-
                     XXO
                     """
      board_from_string(board_string)

    beforeEach ->
      board = all_fields_board()
      call_count = 0

    it 'calls the function for every field', ->
      all_fields_do(board, -> call_count++)
      expect(call_count).toEqual 9

    it 'has all the black stones', ->
      verify_calls_to_color(BLACK, 4)

    it 'has all the white stones', ->
      verify_calls_to_color(WHITE, 3)

    it 'has all the empty stones', ->
      verify_calls_to_color(EMPTY, 2)
