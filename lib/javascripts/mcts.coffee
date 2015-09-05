UCT_BIAS_FACTOR = 2
DEFAULT_PLAYOUTS = 1000

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
