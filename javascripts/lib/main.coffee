scaleBoardTo19 = ->
  stretchRowsTo19 = ->
    line = $('table.go-board tr:nth-child(2)')
    duplicate = line.clone()
    for i in [1..16]
      line.after duplicate
      line = duplicate
      duplicate = line.clone()

  stretchColumnsTo19 = ->
    $('table.go-board tr').each (i, row)->
      cell = $(row).find(':nth-child(2)')
      duplicate = cell.clone()

      for i in [1..16]
        cell.after duplicate
        cell = duplicate
        duplicate = cell.clone()


  stretchRowsTo19();
  stretchColumnsTo19()



$ ->
  console.log 'weehheeee'
  scaleBoardTo19()