playoutBenchmark = ->
  suite = new Benchmark.Suite
  suite.add('playing a random 9x9 game', -> playout_for_board(initBoard(9)))
       .add('playing a random 13x13 game', -> playout_for_board(initBoard(13)))
       .add('playing a random 19x19 game', -> playout_for_board(initBoard(19)))
       .on('cycle', (event)->
          $('#perf_log').append('<p>' + String(event.target) + '</p>'))
       .on('complete', -> $('#perf_log').append 'all done in here')
       .run(async: true)

$ ->
  $('#playout_benchmark').click playoutBenchmark
