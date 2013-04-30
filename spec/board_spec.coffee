describe 'Board', ->

  board = null

  beforeEach ->
    board = init3x3Board()

  describe 'get_field', ->

    it 'gets the color at the specified position', ->
      board[1][2] = BLACK
      expect(get_field(1, 2, board)).toBe BLACK

    it 'gets the color at the top left', ->
      board[0][0] = WHITE
      expect(get_field(0,0,board)).toBe WHITE

    it 'gets the color at the bottom right', ->
      board[2][2] = WHITE
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