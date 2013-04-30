describe 'play move', ->

  board = null
  move = null

  initBoard = ->
    board = []
    for i in [0..2]
      board.push []
      for j in [0..2] 
        board[i][j] = null

  initMove = -> move = create_move 0, 0, BLACK

  beforeEach ->
    initBoard()
    initMove()


  it 'creates a move with the right x', ->
    expect(move.x).toBe(0)

  it 'creates a move with the right y', ->
    expect(move.y).toBe(0)

  it 'creates a move with the right color', ->
    expect(move.color).toBe(BLACK)

  it 'can make a black move', ->
    move = create_move 0, 0, BLACK
    play_move move, board
    expect(board[0][0]).toBe(BLACK)