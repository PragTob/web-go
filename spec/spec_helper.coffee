init3x3Board = ->
  board = []
  for i in [0..2]
    board.push []
    for j in [0..2]
      board[i][j] = EMPTY