import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm

type Point = (tuple[x, y: int])

iterator `..`(a, b: Point): Point =
  let isHorizontal = a.x != b.x
  if isHorizontal:
    for x in min(a.x, b.x)..max(a.x, b.x):
      yield (x, a.y)
  else:
    for y in min(a.y, b.y)..max(a.y, b.y):
      yield (a.x, y)

iterator `..<`(a, b: Point): Point =
  for p in a .. b:
    if p == b:
      continue
    yield p

proc isInShape(p: Point, shape: seq[Point], minX: int): bool =
  var wallCount = 0
  var wallAboveSeen = false
  var wallBelowSeen = false
  for x in minX ..< p.x:
    let tp = (x: x, y: p.y)
    let isWall = shape.contains(tp)
    let wallAbove = shape.contains((tp.x, tp.y - 1))
    let wallBelow = shape.contains((tp.x, tp.y + 1))
    # echo &"{isWall}, {wallAbove}, {wallBelow}"
    if isWall and wallAbove and wallBelow:
      wallCount += 1
      continue
    if isWall and wallAbove:
      if wallBelowSeen:
        wallCount += 1
        wallAboveSeen = false
        wallBelowSeen = false
        continue
      else:
        wallAboveSeen = not wallAboveSeen
    if isWall and wallBelow:
      if wallAboveSeen:
        wallCount += 1
        wallAboveSeen = false
        wallBelowSeen = false
        continue
      else:
        wallBelowSeen = not wallBelowSeen
  
  # echo &"wallCount={wallCount}"
  return wallCount mod 2 == 1

proc part1*(): int =
  echo "\n".repeat(20)

  const input = staticRead("input")
  let lines = input.splitLines()
    .mapIt(it.split(" "))

  var prevPos = (x: 0, y: 0)
  var position = (x: 0, y: 0)
  var loop = newSeq[Point]()
  var topLeft = (x: 0, y: 0)
  var bottomRight = (x: 0, y: 0)
  
  for line in lines:
    prevPos = position
    let dir = line[0][0]
    let length = line[1].parseInt()
    echo &"{dir}, {length}"
    if dir == 'U':
      position.y -= length
    if dir == 'D':
      position.y += length
    if dir == 'L':
      position.x -= length
    if dir == 'R':
      position.x += length

    if position.x < topLeft.x: topLeft.x = position.x
    if position.y < topLeft.y: topLeft.y = position.y
    if position.x > bottomRight.x: bottomRight.x = position.x
    if position.y > bottomRight.y: bottomRight.y = position.y

    for pos in prevPos ..< position:
      loop.add(pos)


  echo &"topleft={topLeft}, bottomRight={bottomRight}"
  echo loop
  echo loop.len

  for y in topLeft.y .. bottomRight.y:
    for x in topLeft.x .. bottomRight.x:
      let pos = (x: x, y: y)
      let inShape = loop.contains(pos) or pos.isInShape(loop, topLeft.x)
      if inShape:
        stdout.write("#")
        result += 1
      else:
        stdout.write(".")
    stdout.write("\n")

proc part2*(): int =
  const input = staticRead("testInput")
  const lines = input.splitLines()
  
  return 0
