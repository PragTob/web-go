$ ->
  suite = new Benchmark.Suite
  suite.add('playing a random 9x9 game', -> playout_for_board(initBoard(9)))
       .add('playing a random 13x13 game', -> playout_for_board(initBoard(13)))
       .add('playing a random 19x19 game', -> playout_for_board(initBoard(19)))
       .on('cycle', (event)-> console.log(String(event.target)))
       .on('complete', -> console.log 'all done in here')
       .run()