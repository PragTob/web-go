GO_STONE = "<div class='go-stone'></div>"
COLOR_TO_CLASS = {}
COLOR_TO_CLASS[BLACK] = 'black'
COLOR_TO_CLASS[WHITE] = 'white'
MAX_PLAYOUTS = 1000

board = null

handleWorkerAnswer = (message)->
  answer_node_id   = message.data.node_id
  has_won          = message.data.has_won
  giveWorkerWork(message.target)
  real_node        = findNode(answer_node_id)
  backpropagate(real_node, has_won)
  mctsData.current_playouts++

findNode = (node_id)->

  deleteNode = (nodes, index)->
    nodes.splice(i, 1)

  for i in [0...mctsData.current_nodes.length]
    node = mctsData.current_nodes[i]
    if node.id == node_id
      deleteNode(mctsData.current_nodes, i)
      return node

giveWorkerWork = (worker)->
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

scaleBoardTo = (number)->
  stretchRowsTo = (number)->
    line = $('table.go-board tr:nth-child(2)')
    duplicate = line.clone()
    for i in [1..(number - 3)]
      line.after duplicate
      line = duplicate
      duplicate = line.clone()

  stretchColumnsTo = (number)->
    $('table.go-board tr').each (i, row)->
      cell = $(row).find(':nth-child(2)')
      duplicate = cell.clone()

      for i in [1..(number - 3)]
        cell.after duplicate
        cell = duplicate
        duplicate = cell.clone()

  numberIntersections = ->
    $('table.go-board tr').each (y, row)->
      $(row).children().each (x, cell)->
        $cell = $(cell)
        $cell.attr('data-y', y)
        $cell.attr('data-x', x)

  stretchRowsTo(number)
  stretchColumnsTo(number)
  numberIntersections()

set_move_on_ui_board = (move)->
  $target_cell = $("table.go-board tr:nth-child(#{move.y + 1}) td:nth-child(#{move.x + 1})")
  stone = $(GO_STONE)
  stone.addClass(COLOR_TO_CLASS[move.color])
  $target_cell.append(stone)

create_move_from_ui_move = ($td, color)->
  create_stone(($td.data('x')),
               ($td.data('y')),
               color)

clean_board = ->
  $('.go-board td').each (i, cell)->
    $(cell).empty()

update_ui_board = (board)->
  clean_board()
  all_fields_do board, (x, y, color)->
    if (color == BLACK) || (color == WHITE)
      set_move_on_ui_board create_stone(x, y, color)

$ ->
  current_color = BLACK
  board_size = 9
  scaleBoardTo(board_size)
  board = initBoard(board_size)

  createWorkers()

  $('.go-board td').click ->
    if $(this).is(':empty') && current_color == BLACK
        move = create_move_from_ui_move($(this), current_color)
        play_stone(move, board)
        update_ui_board(board)
        current_color = WHITE
        startMcts(board)
        update_ui_board(board)
        current_color = BLACK
