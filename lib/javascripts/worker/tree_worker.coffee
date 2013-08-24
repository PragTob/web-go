importScripts '../../../vendor/javascripts/underscore.js',
              '../board.js',
              '../move.js',
              '../random_playouts.js',
              '../mcts.js'

NUM_WORKERS = 4

max_playouts = null
board = null
root = null
own_color = null
current_nodes = []
current_playouts = 0

initMcts = (board)->
  root = create_root(board)
  own_color = determine_move_color(board)
  current_playouts = 0

handleWorkerAnswer = (message)->
  node = message.data.node
  have_won = message.data.have_won
  giveWorkerWork(message.target)
  real_node = findNode(node)
  backpropagate(real_node, have_won)
  current_playouts++

findNode = (worker_node)->
  for n in current_nodes
    if is_equal_board(n.board, worker_node.board)
      current_nodes.remove(n)
      return n

giveWorkerWork = (worker)->
  if current_playouts < max_playouts
    self.postMessage(root)
    selected_node = select(root)
    new_child = expand(selected_node)
    current_nodes.push new_child
    worker.postMessage {node: new_child, own_color: own_color}
  else
    best_node = select_best_node root
    self.postMessage {type: 'result', move: best_node.move }

initWorker = ->
  worker = new Worker('playout_worker.js')
  worker.addEventListener('message', handleWorkerAnswer)
  worker.addEventListener('error', (message)->
    self.post({type: 'Error', message: 'Error ' + message.data}))
  giveWorkerWork(worker)

self.onmessage = (message)->
  max_playouts = message.data.max_playouts
  board    = message.data.board
  initMcts(board)
  initWorker() for i in [0..NUM_WORKERS]
  self.postMessage('got your message!')