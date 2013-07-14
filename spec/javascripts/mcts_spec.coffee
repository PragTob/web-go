describe 'Monte Carlo tree search', ->
  board = null

  describe 'create_node', ->
    node = null
    beforeEach -> node = create_node(initBoard(3), null, null)

    it 'starts out with no wins', ->
      expect(node.wins).toEqual 0

    it 'starts out with no visits', ->
      expect(node.visits).toEqual 0

    it 'starts out with no chilren', ->
      expect(node.children.length).toEqual 0

  describe 'create_root', ->
    root_node = null

    describe 'an empty boad', ->
      beforeEach ->
        board = initBoard(3)
        root_node = create_root board

      it 'has as many untried_moves as fields on the board', ->
        expect(root_node.untried_moves.length).toEqual 9

      it 'has a child with one move when expanded', ->
        expect(expand(root_node).board.moves.length).toEqual 1

      it 'does not modify the original node to play a move on the child boad', ->
        child_board = expand(root_node).board
        move = generate_random_move_for(child_board)
        play_stone(move, child_board)
        expect(child_board.moves.length).toEqual 2
        expect(root_node.board.moves.length).toEqual 0

      it 'is the parent of its children', ->
        child = expand(root_node)
        expect(child.parent).toBe root_node

  describe 'UCT', ->

    it 'correctly calculates the UCT value for a node', ->
      parent =
        visits: 40
      node =
        parent: parent
        wins: 5
        visits: 7
      expect(uct_value_for(node)).toBeCloseTo(2.166)

  describe 'select_best_node', ->

    create_test_child = (wins, visits, parent)->
      child =
        wins: wins
        visits: visits
        parent: parent

    it 'selects the best move to be played', ->
      root = {}
      child_1 = create_test_child(2, 6, root)
      child_2 = create_test_child(0, 3, root)
      child_3 = create_test_child(5, 8, root)
      child_4 = create_test_child(3, 7, root)
      root.children = [child_1, child_2, child_3, child_4]
      expect(select_best_node(root)).toBe child_3

  describe 'expand', ->
    root = null
    untried_move = null

    beforeEach ->
      board = initBoard(9)
      root = create_root(board)
      untried_move = create_stone(5, 5, BLACK)
      root.untried_moves = [untried_move]

    it 'returns the child node', ->
      expect(expand(root).parent).toBe root

    it 'sets the move on the child node', ->
      expect(expand(root).move).toEqual untried_move

    it 'removes the move from untried moves (leaving it empty in this case)', ->
      expand(root)
      expect(root.untried_moves.length).toEqual 0

    it 'adds the child to the children of the parent', ->
      child = expand(root)
      expect(root.children).toEqual [child]






