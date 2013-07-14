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





