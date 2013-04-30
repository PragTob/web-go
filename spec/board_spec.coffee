describe 'Board', ->

  board = null

  beforeEach ->
    board = initBoard(3)


  describe 'initialization', ->
    it 'is initialized with an empty moves array', ->
      expect(board.moves).toEqual []

  describe 'get_field', ->
    it 'gets the color at the specified position', ->
      play_move(create_move(1, 2, BLACK), board)
      expect(get_field(1, 2, board)).toBe BLACK

    it 'gets the color at the top left', ->
      play_move(create_move(0, 0, WHITE), board)
      expect(get_field(0,0,board)).toBe WHITE

    it 'gets the color at the bottom right', ->
      play_move(create_move(2, 2, WHITE), board)
      expect(get_field(2,2,board)).toBe WHITE

    it 'gets the empty value', ->
      expect(get_field(1, 1, board)).toBe EMPTY

    it 'returns the neutral color for x-values smaller than 0', ->
      expect(get_field(-1, 2, board)).toBe NEUTRAL

    it 'returns the neutral color for y-values smaller than 0', ->
      expect(get_field(1, -1, board)).toBe NEUTRAL

    it 'returns the neutral color for x-values greater than the board length', ->
      expect(get_field(3, 2, board)).toBe NEUTRAL

    it 'returns the neutral color for y-values greater than the board length', ->
      expect(get_field(1, 3, board)).toBe NEUTRAL

  describe 'print_board', ->

    it 'prints a beautiful board', ->
      play_move(create_move(1, 0, BLACK), board)
      play_move(create_move(0, 2, WHITE), board)
      expect(print_board(board)).toEqual " X \n   \nO  \n"