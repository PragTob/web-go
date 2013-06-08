describe 'Board', ->
  board = null

  beforeEach ->
    board = initBoard(3)


  describe 'initialization', ->
    it 'is initialized with an empty moves array', ->
      expect(board.moves).toEqual []

    it 'is initialized with 0 black prisoners', ->
      expect(board.prisoners[BLACK]).toEqual(0)

    it 'is initialized with 0 white prisoners', ->
      expect(board.prisoners[WHITE]).toEqual(0)

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

    describe 'print_board', ->
      it 'prints a beautiful board', ->
        set_move(create_stone(1, 0, BLACK), board)
        set_move(create_stone(0, 2, WHITE), board)
        expect(print_board(board)).toEqual board_string


    describe 'board_from_string', ->
      it 'takes a simple string and creates a corresponging board', ->
        board = board_from_string(board_string)
        expect(get_color(0, 0, board)).toBe EMPTY
        expect(get_color(1, 0, board)).toBe BLACK
        expect(get_color(0, 2, board)).toBe WHITE
