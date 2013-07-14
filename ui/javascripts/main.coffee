GO_STONE = "<div class='go-stone'></div>"


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

$ ->
  current_color = BLACK
  scaleBoardTo(9)
  $('.go-board td').click ->
    if $(this).is(':empty')
      stone = $(GO_STONE)
      if current_color == BLACK
        stone.addClass('black')
        current_color = WHITE
      else
        stone.addClass('white')
        current_color = BLACK

      $(this).append(stone)