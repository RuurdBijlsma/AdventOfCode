import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm
import std/sets

type Point = (tuple[x,y,z: int])
type Grid = seq[seq[int]]
type Brick = (tuple[start, finish: Point])

func `[]`(s: seq[Grid], p: Point): int =
  s[p.z][p.y][p.x]
func `[]=`(s: var seq[Grid], p: Point, v: int) =
  s[p.z][p.y][p.x] = v
func isVertical(brick: Brick): bool =
  brick.start.z != brick.finish.z

iterator `..`(a, b: Point): Point =
  if a.x > b.x:
    for i in 0 .. a.x - b.x:
      yield (a.x - i, a.y, a.z)
  elif a.x < b.x:
    for i in 0 .. b.x - a.x:
      yield (a.x + i, a.y, a.z)
  elif a.y > b.y:
    for i in 0 .. a.y - b.y:
      yield (a.x, a.y - i, a.z)
  elif a.y < b.y:
    for i in 0 .. b.y - a.y:
      yield (a.x, a.y + i, a.z)
  elif a.z > b.z:
    for i in 0 .. a.z - b.z:
      yield (a.x, a.y, a.z - i)
  elif a.z < b.z:
    for i in 0 .. b.z - a.z:
      yield (a.x, a.y, a.z + i)
  else:
    yield a

func getBrickGraphs(input: static string): (Table[int, HashSet[int]], Table[int, HashSet[int]]) =
  const bricks: seq[Brick] = input.splitLines()
    .map(b => b.split("~").map(c => c.split(",").map(parseInt)).map(c => (x: c[0], y: c[1], z: c[2])))
    .map(b => (start: b[0], finish: b[1]))
    .sorted((a, b) => cmp(a.start.z, b.start.z))
  const minZ = min(bricks[0].start.z, bricks[0].finish.z)
  const maxZ = max(bricks[bricks.len - 1].start.z, bricks[bricks.len - 1].finish.z)
  var stack: seq[Grid] = newSeqWith(1 + maxZ - minZ, newSeqWith(10, newSeqWith(10, -1)))

  var brickHolds = initTable[int, HashSet[int]]()
  var brickSupport = initTable[int, HashSet[int]]()
  
  for (index, brick) in bricks.pairs:
    brickHolds[index] = initHashSet[int]()
    brickSupport[index] = initHashSet[int]()
    var fallDistance = int.high
    let brickBottom = min(brick.start.z, brick.finish.z)
    if brickBottom == 1:
      fallDistance = 0
    elif brick.isVertical:
      fallDistance = 0
      for z in countdown(brickBottom - 1, 1):
        if stack[z][brick.start.y][brick.start.x] != -1: break
        fallDistance += 1
    else:
      for p in brick.start .. brick.finish:
        var partFallDistance = 0
        for z in countdown(brickBottom - 1, 1):
          if stack[z][p.y][p.x] != -1 or partFallDistance >= fallDistance: break
          partFallDistance += 1
        fallDistance = min(fallDistance, partFallDistance)
        if fallDistance == 0: break
    for p in brick.start .. brick.finish:
      let brickZ = p.z - fallDistance
      stack[brickZ][p.y][p.x] = index
      let brickBelow = stack[brickZ - 1][p.y][p.x]
      if brickBelow != -1 and brickBelow != index:
        brickHolds[brickBelow].incl(index)
        brickSupport[index].incl(brickBelow)
  return (brickHolds, brickSupport)

func willCauseFall(index: int, brickHolds, brickSupport: Table[int, HashSet[int]]): bool =
  if brickHolds[index].len == 0:
    return false
  for j in brickHolds[index]:
    if brickSupport[j].len == 1:
      return true
  return false

proc part1*(): int =
  const (brickHolds, brickSupport) = getBrickGraphs(staticRead("input"))
        
  for i in 0 ..< brickHolds.len:
    if not willCauseFall(i, brickHolds, brickSupport):
      result += 1


proc part2*(): int =
  const (brickHolds, brickSupport) = getBrickGraphs(staticRead("input"))

  for i in countDown(brickHolds.len - 1, 0):
    var queue = brickHolds[i].toSeq
    var fallenBricks = [i].toHashSet
    while queue.len > 0:
      let brick = queue.pop()
      if fallenBricks.contains(brick): continue
      let brickSupports = brickSupport[brick] - fallenBricks
      if brickSupports.len == 0:
        fallenBricks.incl(brick)
        result += 1
        for j in brickHolds[brick]:
          queue.insert(j, 0)



    
