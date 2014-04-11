GO_STONE = "<div class='go-stone'></div>"
COLOR_TO_CLASS = {}
COLOR_TO_CLASS[BLACK] = 'black'
COLOR_TO_CLASS[WHITE] = 'white'

scaleBoardTo = (number)->
  stretchRowsTo = (number)->
    line = $('table.go-board tr:nth-child(2)')
    duplicate = line.clone()
    for i in [1..number - 3]
      line.after duplicate
      line = duplicate
      duplicate = line.clone()

  stretchColumnsTo = (number)->
    $('table.go-board tr').each (i, row)->
      cell = $(row).find(':nth-child(2)')
      duplicate = cell.clone()

      for i in [1..number - 3]
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
  move = mcts(board, 1000)
  play_stone(move, board)
  set_move_on_ui_board(move)

set_move_on_ui_board = (move)->
  $target_cell = $("table.go-board tr:nth-child(#{move.y + 1}) td:nth-child(#{move.x + 1})")
  stone = $(GO_STONE)
  stone.addClass(COLOR_TO_CLASS[move.color])
  $target_cell.append(stone)

create_move_from_ui_move = ($td, color)->
  create_stone(($td.data('x')),
               ($td.data('y')),
               color)

$ ->
  current_color = BLACK
  board_size = 9
  scaleBoardTo(board_size)
  board = initBoard(board_size)

  $('.go-board td').click ->
    if $(this).is(':empty')
      stone = $(GO_STONE)
      if current_color == BLACK
        stone.addClass('black')
        move = create_move_from_ui_move($(this), current_color)
        play_stone(move, board)
        current_color = WHITE
        start_mcts(board)
        current_color = BLACK

      $(this).append(stone)