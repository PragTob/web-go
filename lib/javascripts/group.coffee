toLibertyString = (x, y) ->
  "#{x}-#{y}"

stoneToLibertyString = (stone) ->
  toLibertyString(stone.x, stone.y)

groupLibertyAt = (group, x, y)->
  group.liberties[toLibertyString(x, y)]

assignGroup = (stone, board) ->

  joinGroup = (group, stone)->

    addStoneToGroup = (group, stone)->
      stone.group = group
      group.stones.push stone

    removeLibertyOfNewMember = (group, stone)->
      delete groupLibertyAt(group, stone.x, stone.y)
      group.libertyCount -= 1

    addStoneToGroup(group, stone)
    removeLibertyOfNewMember(group, stone)


  sameGroup = (stone, otherStone)->
    stone.group == otherStone.group # does this check object identity or equalness?

  createNewGroup = (stone)->
    group =
      stones: [stone]
      liberties: {}
      libertyCount: 0
    stone.group = group

  addToGroupLiberties = (group, liberty)->
    identifier = stoneToLibertyString(liberty)
    unless group.liberties[identifier]?
      group.liberties[identifier] = EMPTY
      group.libertyCount += 1

  neighbours = neighbouring_stones(stone.x, stone.y, board)
  neighboursByColor = _.groupBy neighbours, (neighbour)->
    neighbour.color

  _.each neighboursByColor[stone.color], (friendlyStone)->
    joinGroup(friendlyStone.group, stone) unless sameGroup(stone, friendlyStone)

  createNewGroup(stone) unless stone.group

  _.each neighboursByColor[EMPTY], (liberty)->
    addToGroupLiberties(stone.group, liberty)

  _.each neighboursByColor[other_color(stone.color)], (enemyStone)->
    enemyGroup = enemyStone.group
    identifier = stoneToLibertyString(stone)
    myGroup = stone.group
    enemyGroup.libertyCount -= 1 if enemyGroup.liberties[identifier] == EMPTY
    enemyGroup.liberties[identifier] = myGroup
    myGroup.liberties[stoneToLibertyString(enemyStone)] = enemyGroup




  # when a group is taken from the board we have to iterate over all members
  # and see if any of them has a neighboring enemy stone, whose
  # group would then get a liberty added
