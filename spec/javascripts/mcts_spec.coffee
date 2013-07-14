describe 'Monte Carlo tree search', ->

  describe 'create_node', ->
    node = null
    beforeEach -> node = create_node(null, null, null)

    it 'starts out with no wins', ->
      expect(node.wins).toEqual 0

    it 'starts out with no visits', ->
      expect(node.visits).toEqual 0

    it 'starts out with no chilren', ->
      expect(node.children.length).toEqual 0

  describe 'create_root', ->
    board = null
    root_node = null

    describe 'an empty boad', ->
      beforeEach ->
        board = initBoard(3)
        root_node = create_root board

      it 'has as many children as fields on the board', ->
        expect(root_node.children.length).toEqual 9

      it 'has children which have boards with a move played', ->
        expect(root_node.children[0].board.moves.length).toEqual 1

      it 'does not modify the original node to play a move on the child boad', ->
        child_board = root_node.children[0].board
        move = generate_random_move_for(child_board)
        play_stone(move, child_board)
        expect(child_board.moves.length).toEqual 2
        expect(root_node.board.moves.length).toEqual 0

      it 'is the parent of its children', ->
        child = root_node.children[0]
        expect(child.parent).toBe root_node





