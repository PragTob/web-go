UCT_BIAS_FACTOR = 2
DEFAULT_PLAYOUTS = 1000
NUM_WORKERS = 4
playoutWorkers = []

create_node = (board, move, parent)->
  node =
    move: move
    board: board
    parent: parent
    wins: 0
    visits: 0
    children: []
    untried_moves: get_all_plausible_moves(board)
  node

create_root = (board)->
  create_node(board, null, null)

select = (root)->
  selected_node = root
  while selected_node.untried_moves.length <= 0
    selected_node = uct_select_child(selected_node)
  selected_node

uct_value_for = (node) ->
  # note to self, Math.log is Math.ln so this is fine
  node.wins/node.visits + UCT_BIAS_FACTOR * Math.sqrt(Math.log(node.parent.visits)/node.visits)

uct_select_child = (node)->
  max_value = 0
  max_node = null
  _.each node.children, (child)->
    new_value = uct_value_for child
    if new_value > max_value
      max_node = child
      max_value = new_value
  max_node

# idea for expansion, just expand after x visits
expand = (node)->
  create_child_node = (parent, move)->
    board = copy_board(parent.board)
    play_stone(move, board)
    child = create_node(board, move, parent)
    parent.children.push child
    child

  move = node.untried_moves.pop()
  create_child_node(node, move)

rollout = (node, own_color)->
  playout_board = copy_board(node.board)
  finished_board = playout_for_board(playout_board)
  score_game(finished_board).winner == own_color

is_end_of_tree = (node)-> node == null

backpropagate = (node, have_won)->
  if have_won
    win_modifier = 1
  else
    win_modifier = 0

  until is_end_of_tree(node)
    node.visits += 1
    node.wins += win_modifier
    node = node.parent

select_best_node = (node)->
  best_node = null
  best_win_average = 0
  _.each node.children, (child)->
    win_average = child.wins / child.visits
    if win_average >= best_win_average
      best_win_average = win_average
      best_node = child

  best_node

explore_tree = (root, own_color)->
  selected_node = select(root)
  new_child = expand(selected_node)
  have_won = rollout(new_child, own_color)
  backpropagate(new_child, have_won)

mcts = (board, playouts = DEFAULT_PLAYOUTS)->
  root = create_root(board)
  own_color = determine_move_color(board)

  for i in [0...playouts]
    explore_tree(root, own_color)

  best_node = select_best_node root
  best_node.move

createWorkers = (n, mctsData)->
  answerMethod = (message)-> handleWorkerAnswer(message, mctsData)
  for i in [1..n]
    worker = new Worker 'lib/javascripts/worker/playout_worker.js'
    worker.addEventListener('message', answerMethod)
    worker.addEventListener('error', (message)->
      console.log 'Worker error message:' + message.data)
    playoutWorkers.push worker

handleWorkerAnswer = (message, mctsData)->
  answer_node_id   = message.data.node_id
  has_won          = message.data.has_won
  giveWorkerWork(message.target, mctsData)
  real_node        = findNode(answer_node_id)
  backpropagate(real_node, has_won)
  mctsData.current_playouts++

giveWorkerWork = (worker, mctsData)->
  console.log mctsData.current_playouts if mctsData.current_playouts % 10 == 0
  if mctsData.current_playouts < mctsData.max_playouts
    selected_node = select(mctsData.root)
    new_child     = expand(selected_node)
    new_child.id  = mctsData.current_node_id
    mctsData.current_node_id++
    mctsData.current_nodes.push new_child
    worker.postMessage {node: new_child, own_color: mctsData.own_color}
  else
    unless mctsData.sent_result
      console.log 'sent result'
      best_node = select_best_node mctsData.root
      bestMove  = best_node.move
      mctsData.sent_result = true
      play_stone(bestMove, board)
      set_move_on_ui_board(bestMove)

webWorkerMcts = (board, moveCallback, playouts = DEFAULT_PLAYOUTS)->
  mctsData =
    board:            board
    current_nodes:    []
    current_playouts: 0
    own_color:        determine_move_color(board)
    root:             create_root(board)
    sentResult:       false
    max_playouts:     MAX_PLAYOUTS
    current_node_id:  1
  mctsData.root.id    = 0

  createWorkers(NUM_WORKERS, mctsData) if playoutWorkers.length == 0
  giveWorkerWork(worker, mctsData) for worker in playoutWorkers
