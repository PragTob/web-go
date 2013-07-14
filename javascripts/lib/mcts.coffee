create_node = (board, move, parent)->
  node =
    board: board
    move: move
    parent: parent
    wins: 0
    visits: 0
    children: []
  node

add_children_for_node = (node)->

  create_child_node = (node, move)->
    board = copy_board(node.board)
    play_stone(move, board)
    child = create_node(board, move, node)
    node.children.push child

  all_plausible_moves = get_all_plausible_moves(node.board)
  _.each all_plausible_moves, (move)-> create_child_node(node, move)

create_root = (board)->
  root = create_node(board, null, null)
  add_children_for_node(root)
  root


mcts = (board) ->


  root = create_root(board)
  add_children_for_node(root)
