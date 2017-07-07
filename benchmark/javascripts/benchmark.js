// Generated by CoffeeScript 1.11.1
var completeBenchmark, logResult, mctsBenchmark, playoutBenchmark, workerBenchmark;

logResult = function(event) {
  $('#perf_log').append('<p>' + String(event.target) + '</p>');
};

completeBenchmark = function() {
  $('#perf_log').append('all done in here');
};

playoutBenchmark = function() {
  var suite = new Benchmark.Suite;
  suite.add('playing a random 9x9 game', function() {
    playout_for_board(initBoard(9));
  }).add('playing a random 13x13 game', function() {
    playout_for_board(initBoard(13));
  }).add('playing a random 19x19 game', function() {
    playout_for_board(initBoard(19));
  }).on('cycle', logResult).on('complete', completeBenchmark).run({
    async: true
  });
};

mctsBenchmark = function() {
  var suite = new Benchmark.Suite;
  suite.add('mcts a 9x9 game with 100 playouts', function() {
    mcts(initBoard(9), 100);
  }).add('mcts a 13x13 game with 100 playouts', function() {
    mcts(initBoard(13), 100);
  }).add('mcts a 19x19 game with 100 playouts', function() {
    mcts(initBoard(19), 100);
  }).on('cycle', logResult).on('complete', completeBenchmark).run({
    async: true
  });
};

workerBenchmark = function() {
  var suite, workerMainCode;
  workerMainCode = function(size) {
    var board, finished_board;
    board = initBoard(size);
    finished_board = playout_for_board(board);
    score_game(finished_board);
  };
  suite = new Benchmark.Suite;
  suite.add('Worker main code on 9x9 (playout + score)', function() {
    workerMainCode(9);
  }).add('Worker main code on 13x13 (playout + score)', function() {
    workerMainCode(13);
  }).add('Worker main code on 19x19 (playout + score)', function() {
    workerMainCode(19);
  }).on('cycle', logResult).on('complete', completeBenchmark).run({
    async: true
  });
};

$(function() {
  $('#playout_benchmark').click(playoutBenchmark);
  $('#mcts-benchmark').click(mctsBenchmark);
  $('#worker-benchmark').click(workerBenchmark);
});
