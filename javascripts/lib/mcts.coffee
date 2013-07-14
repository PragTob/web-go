UCT_BIAS_FACTOR = 2
PLAYOUTS = 2

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
  root = create_node(board, null, null)

uct_value_for = (node) ->
  # note to self, Math.log is Math.ln so this is fine
  node.wins/node.visits + UCT_BIAS_FACTOR * Math.sqrt(Math.log(node.parent.visits)/node.visits)

uct_select_child = (node)->
  max_value = 0
  max_node = null
  _.each node.children, (child)->
    new_value = uct_value_for child
    max_node = child if new_value > max_value
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

rollout = (node)->
  finished_board = playout_for_board(node.board)
  score_game(finished_board).winner

is_root_node = (node)-> node.parent != null


backpropagate = (winner, node, own_color)->
  if winner == own_color
    win_modifier = 1
  else
    win_modifier = 0

  until is_root_node(node)
    node.visits += 1
    node.wins += win_modifier

select_best_move = (node)->
  best_move = null
  best_win_average = 0
  _.each node.children, (node)->
    win_average = node.wins / node.visits
    if win_average >= best_win_average
      best_move = node.move

  best_move

mcts = (board) ->
  root = create_root(board)
  own_color = determine_move_color(board)

  for i in [0...PLAYOUTS]
    selected_node = root
    while selected_node.untried_moves.length < 0
      selected_node = uct_select_child(root)
    new_child = expand(selected_node)
    winner = rollout(new_child)
    backpropagate(winner, new_child, own_color)

  select_best_move root
