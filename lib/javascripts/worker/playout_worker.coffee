importScripts '../../../vendor/javascripts/underscore.js',
  '../board.js',
  '../group.js',
  '../move.js',
  '../random_playouts.js',
  '../mcts.js'

self.onmessage = (message)->
  node = message.data.node
  board = node.board
  own_color = message.data.own_color
  finished_board = playout_for_board(board)
  has_won = score_game(finished_board).winner == own_color
  self.postMessage {node_id: node.id, has_won: has_won}
