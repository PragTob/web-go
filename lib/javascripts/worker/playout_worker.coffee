importScripts '../../../vendor/javascripts/underscore.js',
  '../board.js',
  '../move.js',
  '../random_playouts.js',
  '../mcts.js'

self.onmessage = (message)->
  node = message.data.node
  board = node.board
  own_color = message.data.own_color
  finished_board = playout_for_board(board)
  have_won = score_game(finished_board).winner == own_color
  self.postMessage {node: node, have_won: have_won}