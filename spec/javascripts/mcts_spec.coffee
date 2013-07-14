describe 'Monte Carlo tree search', ->
  board = null

  create_test_child = (wins, visits, parent)->
    child =
      wins: wins
      visits: visits
      parent: parent

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
      node = create_test_child(5, 7, parent)
      expect(uct_value_for(node)).toBeCloseTo(2.166)

    it 'selects a promising child node', ->
      root =
        visits: 30
      child_1 = create_test_child(0, 15, root)
      child_2 = create_test_child(5, 7, root)
      child_3 = create_test_child(4, 8, root)
      root.children = [child_1, child_2, child_3]
      expect(uct_select_child(root)).toBe child_2

  describe 'select_best_node', ->

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

  describe 'rollout', ->
    it 'does not change the board of the node', ->
      node =
        board: initBoard(3)
      rollout(node)
      expect(node.board.moves.length).toEqual 0

  describe 'backpropagate', ->
    child_1 = null
    child_2 = null
    child_1_1 = null
    child_1_2 = null
    root = null

    beforeEach ->
      root =
        visits: 7
        wins: 3
        parent: null
      child_1 = create_test_child(2, 4, root)
      child_2 = create_test_child(1, 3, root)
      child_1_1 = create_test_child(2, 3, child_1)
      child_1_2 = create_test_child(0, 1, child_1)

    describe 'winning', ->
      beforeEach -> backpropagate(child_1_1, true)

      it 'changes wins for the node', ->
        expect(child_1_1.wins).toEqual 3

      it 'changes the visits for the node', ->
        expect(child_1_1.visits).toEqual 4

      it 'propagates the change to its parent', ->
        expect(child_1.wins).toEqual 3
        expect(child_1.visits).toEqual 5

      it 'propagates the chane to the root', ->
        expect(root.wins).toEqual 4
        expect(root.visits).toEqual 8

      it 'does not touch the sibling of its parent', ->
        expect(child_2.visits).toEqual 3

    describe 'loosing', ->
      beforeEach -> backpropagate(child_1_1, false)

      it 'changes the visits for the node', ->
        expect(child_1_1.visits).toEqual 4

      it 'does not change the wins of the node', ->
        expect(child_1_1.wins).toEqual 2

      it 'does not change the wins of the nodes parent', ->
        expect(child_1.wins).toEqual 2

      it 'changes the visits of its parent', ->
        expect(child_1.visits).toEqual 5








