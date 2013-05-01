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

  describe 'get_stone', ->
    it 'gets the color at the specified position', ->
      play_move(create_move(1, 2, BLACK), board)
      expect(get_stone(1, 2, board)).toBe BLACK

    it 'gets the color at the top left', ->
      play_move(create_move(0, 0, WHITE), board)
      expect(get_stone(0,0,board)).toBe WHITE

    it 'gets the color at the bottom right', ->
      play_move(create_move(2, 2, WHITE), board)
      expect(get_stone(2,2,board)).toBe WHITE

    it 'gets the empty value', ->
      expect(get_stone(1, 1, board)).toBe EMPTY

    it 'returns the neutral color for x-values smaller than 0', ->
      expect(get_stone(-1, 2, board)).toBe NEUTRAL

    it 'returns the neutral color for y-values smaller than 0', ->
      expect(get_stone(1, -1, board)).toBe NEUTRAL

    it 'returns the neutral color for x-values greater than the board length', ->
      expect(get_stone(3, 2, board)).toBe NEUTRAL

    it 'returns the neutral color for y-values greater than the board length', ->
      expect(get_stone(1, 3, board)).toBe NEUTRAL


  describe 'all_neighbours_satisfy', ->
    neighbour_board = null

    create_neighbour_board = ->
      #        X
      #       X
      #        X
      example_board = initBoard(7)
      play_move(create_move(2, 2, BLACK), example_board)
      play_move(create_pass_move(WHITE), example_board)
      play_move(create_move(1, 3, BLACK), example_board)
      play_move(create_pass_move(WHITE), example_board)
      play_move(create_move(2, 4, BLACK), example_board)
      example_board

    is_colored = (color)->
      (x, y, board)-> color == get_stone(x, y, board)

    beforeEach ->
      neighbour_board = create_neighbour_board()

    it 'works to check if all surrounding stones are black when they are', ->
      play_move(create_pass_move(WHITE), neighbour_board)
      play_move(create_move(3, 3, BLACK), neighbour_board)
      all_black = all_neighbours_satisfy(2, 3, neighbour_board, is_colored(BLACK))
      expect(all_black).toBeTruthy()

    it 'works to check if all surrounding stones are black when they are not', ->
      play_move(create_move(3, 3, WHITE), neighbour_board)
      all_black = all_neighbours_satisfy(2, 3, neighbour_board, is_colored(BLACK))
      expect(all_black).toBeFalsy()

  describe 'print_board', ->

    it 'prints a beautiful board', ->
      play_move(create_move(1, 0, BLACK), board)
      play_move(create_move(0, 2, WHITE), board)
      expect(print_board(board)).toEqual " X \n   \nO  \n"