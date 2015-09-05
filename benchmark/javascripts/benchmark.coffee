logResult = (event)->
  $('#perf_log').append('<p>' + String(event.target) + '</p>')

completeBenchmark = -> $('#perf_log').append 'all done in here'

playoutBenchmark = ->
  suite = new Benchmark.Suite
  suite.add('playing a random 9x9 game', -> playout_for_board(initBoard(9)))
       .add('playing a random 13x13 game', -> playout_for_board(initBoard(13)))
       .add('playing a random 19x19 game', -> playout_for_board(initBoard(19)))
       .on('cycle', logResult)
       .on('complete', completeBenchmark)
       .run(async: true)

mctsBenchmark = ->
  suite = new Benchmark.Suite
  console.log 'start'
  suite.add('mcts a 9x9 game with 100 playouts', -> mcts(initBoard(9), 100))
       .add('mcts a 13x13 game with 100 playouts', -> mcts(initBoard(13), 100))
       .add('mcts a 19x19 game with 100 playouts', -> mcts(initBoard(19), 100))
       .on('cycle', logResult)
       .on('complete', completeBenchmark)
       .run(async: true)

workerBenchmark = ->

  workerMainCode = (size)->
    board = initBoard(size)
    finished_board = playout_for_board(board)
    score_game(finished_board)

  suite = new Benchmark.Suite
  console.log 'start'
  suite.add('Worker main code on 9x9 (playout + score)', -> workerMainCode(9))
       .add('Worker main code on 13x13 (playout + score)', -> workerMainCode(13))
       .add('Worker main code on 19x19 (playout + score)', -> workerMainCode(19))
       .on('cycle', logResult)
       .on('complete', completeBenchmark)
       .run(async: true)

$ ->
  $('#playout_benchmark').click playoutBenchmark
  $('#mcts-benchmark').click mctsBenchmark
  $('#worker-benchmark').click workerBenchmark
