GO_STONE = "<div class='go-stone'></div>"
COLOR_TO_CLASS = {}
COLOR_TO_CLASS[BLACK] = 'black'
COLOR_TO_CLASS[WHITE] = 'white'

board = null
worker = null

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

start_mcts = (board)->
  console.log board
  worker.postMessage(board: board, max_playouts: 10)

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
  console.log board

  worker = new Worker 'lib/javascripts/worker/tree_worker.js'
  worker.addEventListener 'message', (message)->
    if message.type == 'Error'
      console.log message.data.message
    else
      if message.type == 'result'
        move = message.data.move
        play_stone(move, board)
        set_move_on_ui_board(move)
      else
        console.log message.data

  worker.addEventListener('error', (message)->
    console.log 'Worker error message:' + message.data)

  $('.go-board td').click ->
    if $(this).is(':empty') && current_color == BLACK
        move = create_move_from_ui_move($(this), current_color)
        play_stone(move, board)
        update_ui_board(board)
        current_color = WHITE
        start_mcts(board)
        update_ui_board(board)
        current_color = BLACK
