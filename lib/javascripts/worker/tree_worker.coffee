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
current_node_id = 0
current_nodes = []
current_playouts = 0

initMcts = (board)->
  root             = create_root(board)
  own_color        = determine_move_color(board)
  current_playouts = 0
  root.id          = current_node_id
  current_node_id++

initWorker = ->
  worker = new Worker('playout_worker.js')
  worker.addEventListener('message', handleWorkerAnswer)
  worker.addEventListener('error', (message)->
    self.post({type: 'Error', message: 'Error ' + message.data}))
  giveWorkerWork(worker)

handleWorkerAnswer = (message)->
  answer_node_id   = message.data.node_id
  has_won          = message.data.has_won
  giveWorkerWork(message.target)
  real_node        = findNode(answer_node_id)
  backpropagate(real_node, has_won)
  current_playouts++

findNode = (node_id)->
  for i in [0...current_nodes.length]
    node = current_nodes[i]
    if node.id == node_id
      current_nodes.splice(i, 1)
      return node

giveWorkerWork = (worker)->
  if current_playouts < max_playouts
    selected_node = select(root)
    new_child     = expand(selected_node)
    new_child.id  = current_node_id
    current_node_id++
    current_nodes.push new_child
    worker.postMessage {node: new_child, own_color: own_color}
  else
    best_node = select_best_node root
    self.postMessage {type: 'result', move: best_node.move }

self.onmessage = (message)->
  max_playouts = message.data.max_playouts
  board        = message.data.board
  initMcts(board)
  initWorker() for i in [0..NUM_WORKERS]
  self.postMessage('got your message!')