describe 'groups', ->

  describe 'simple examples', ->
    it "correctly gets the liberties of a single stone", ->
      string =  """
                ---
                -X-
                ---
                """
      board = board_from_string string
      stone = get_stone(1, 1, board)
      group = stone.group
      expect(group.libertyCount).toEqual 4
      expect(group.stones[0]).toBe stone
      console.log group.liberties
      expect(group.liberties['1-0']).toEqual EMPTY
      expect(group.liberties['2-1']).toEqual EMPTY
      expect(group.liberties['0-1']).toEqual EMPTY
      expect(group.liberties['1-2']).toEqual EMPTY

    it "correctly gets the liberties of 2 stones", ->
      string =  """
                ----
                -XX-
                ----
                ----
                """
      board = board_from_string string
      stone = get_stone(1, 1, board)
      group = stone.group
      expect(group.libertyCount).toEqual 6
      expect(group.stones.length).toEqual 2

    it "correctly gets the liberties on the edge", ->
      string =  """
                ---
                X--
                ---
                """
      board = board_from_string string
      stone = get_stone(0, 1, board)
      group = stone.group
      expect(group.libertyCount).toEqual 3
      expect(group.stones[0]).toBe stone

    it "correctly gets the liberties on the edge", ->
      string =  """
                X--
                ---
                ---
                """
      board = board_from_string string
      stone = get_stone(0, 0, board)
      group = stone.group
      expect(group.libertyCount).toEqual 2
      expect(group.stones[0]).toBe stone

  describe "stones of two colors", ->
    board = null

    describe "two stones", ->
      beforeEach ->
        string = """
                 -O-
                 -X-
                 ---
                 """
        board = board_from_string(string)

      it "correctly counts liberties for the black stone", ->
        stone = get_stone(1, 1, board)
        group = stone.group

        expect(group.libertyCount).toEqual 3
        expect(group.stones[0]).toBe stone

      it "correctly counts liberties for the white stone", ->
        stone = get_stone(1, 0, board)
        group = stone.group

        expect(group.libertyCount).toEqual 2
        expect(group.stones[0]).toBe stone

      it "gets the liberties right for both stones", ->
        blackStone = get_stone(1, 1, board)
        whiteStone = get_stone(1, 0, board)

        expect(blackStone.group.liberties['0-1']).toEqual EMPTY
        expect(blackStone.group.liberties['1-2']).toEqual EMPTY
        expect(blackStone.group.liberties['2-1']).toEqual EMPTY
        expect(blackStone.group.liberties['1-0']).toBe whiteStone.group

        expect(whiteStone.group.liberties['0-0']).toEqual EMPTY
        expect(whiteStone.group.liberties['2-0']).toEqual EMPTY
        expect(whiteStone.group.liberties['1-1']).toBe blackStone.group

    describe "before capture liberties", ->
      board = null

      beforeCaptureBoard = ->
        string = """
                 ----
                 -OO-
                 OXX-
                 -OO-
                 """
        board_from_string string

      beforeEach ->
        board = beforeCaptureBoard()

      it "gets the liberties of the black group in the middle", ->
        stone = get_stone(2, 2, board)
        group = stone.group
        expect(group.libertyCount).toEqual 1
        expect(group.stones.length).toEqual 2

      it "gets the liberties of the top white grup", ->
        stone = get_stone(1, 1, board)
        group = stone.group
        expect(group.libertyCount).toEqual 4
        expect(group.stones.length).toEqual 2

      it "gets the liberties of the one white stone", ->
        stone = get_stone(0, 2, board)
        group = stone.group
        expect(group.libertyCount).toEqual 2
        expect(group.stones.length).toEqual 1

      it "gets the liberties of the bottom white stones", ->
        stone = get_stone(1, 3, board)
        group = stone.group
        expect(group.libertyCount).toEqual 2
        expect(group.stones.length).toEqual 2

      describe "now we capture", ->
        beforeEach ->
          board = beforeCaptureBoard()
          makeValidMove(create_stone(3, 2, WHITE), board)

        it "gets the liberties of the top white grup", ->
          console.log board_to_string(board)
          stone = get_stone(1, 1, board)
          group = stone.group
          expect(group.libertyCount).toEqual 6

        it "gets the liberties of the one white stone", ->
          stone = get_stone(0, 2, board)
          group = stone.group
          expect(group.libertyCount).toEqual 3

        it "gets the liberties of the bottom white stones", ->
          stone = get_stone(1, 3, board)
          group = stone.group
          expect(group.libertyCount).toEqual 4

  describe "first integration test board", ->
    board = null

    createFirstTestBoard = ->
      testBoard = """
                  OOOO-
                  OXXX-
                  OOOO-
                  -X---
                  O--XX
                  """
      board_from_string(testBoard)

    beforeEach -> board = createFirstTestBoard()

    it "correctly handles the big white group on the top", ->
      whiteStone = get_stone(0, 0, board)
      group = whiteStone.group
      expect(group.libertyCount).toEqual 5
      expect(group.stones.length).toEqual 9
      sameGroup = get_stone(3, 2, board).group
      expect(sameGroup).toEqual group

    it "correctly handles the larger black group on the top", ->
      blackStone = get_stone(1, 1, board)
      group = blackStone.group
      expect(group.libertyCount).toEqual 1
      expect(group.stones.length).toEqual 3
      sameGroup = get_stone(3, 1, board).group
      expect(sameGroup).toEqual group

    it "correctly handles the one black stone", ->
      blackStone = get_stone(1, 3, board)
      group = blackStone.group
      expect(group.libertyCount).toEqual 3
      expect(group.stones.length).toEqual 1

    it "correctly handles the bottom corner black stones", ->
      blackStone = get_stone(4, 4, board)
      group = blackStone.group
      expect(group.libertyCount).toEqual 3
      expect(group.stones.length).toEqual 2

    it "correctly handles the one white corner stone", ->
      whiteStone = get_stone(0, 4, board)
      group = whiteStone.group
      expect(group.libertyCount).toEqual 2
      expect(group.stones.length).toEqual 1
