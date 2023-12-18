import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm
import std/sets
import grid

proc printGridCosts(grid: Grid, origins: TableRef[Point, TableRef[Dir, Origin]], dir: Dir) =
  echo dir
  for y in 0 ..< grid.len:
    for x in 0 ..< grid[0].len:
      let pos = (x, y)
      if origins.hasKey(pos) and origins[pos].hasKey(dir):
        let cost = origins[pos][dir].cost
        stdout.write(align($cost, 4))
      else:
        stdout.write(" ".repeat(4))
    stdout.write("\n")

iterator `..`(a, b: Point): Point =
  let isHorizontal = a.x != b.x
  if isHorizontal:
    for x in min(a.x, b.x)..max(a.x, b.x):
      yield (x, a.y)
  else:
    for y in min(a.y, b.y)..max(a.y, b.y):
      yield (a.x, y)

iterator `>..`(a, b: Point): Point =
  for p in a .. b:
    if p == a:
      continue
    yield p

proc cost(grid: Grid, a, b: Point): int =
  for p in a >.. b:
    result += grid[p]

proc getPath(origins: TableRef[Point, TableRef[Dir, Origin]], start, target: Point): seq[Point] =
  let origin = origins[target]

  let horCost = origin[Dir.horizontal].cost
  let verCost = origin[Dir.vertical].cost
  var dir = Dir.vertical
  if horCost < verCost:
    dir = Dir.horizontal

  var point = target
  result = @[target]
  while true:
    if not origins.hasKey(point) or not origins[point].hasKey(dir) or point == start: 
      break
    echo point
    point = origins[point][dir].point
    dir = origins[point][dir].dir.reverse()
    result.add point
  result.reverse()
    
proc calcPath(grid: Grid, start: Point, target: Point): seq[Point] =
  var front: seq[Origin] = @[(start, Dir.none, 0)]
  var origins = {
    start: {
      Dir.none: (point: (-1, -1), dir: Dir.none, cost: 0)
    }.newTable
  }.newTable

  while true:
    let current = front.pop()

    if current.point == target:
      echo "Found target"
      printGridCosts(grid, origins, current.dir)
      return getPath(origins, start, target)

    for (next, dir) in grid.neighbors(current.point, current.dir):
      let cost = current.cost + grid.cost(current.point, next)
      let alreadyVisited = origins.hasKey(next) and origins[next].hasKey(dir)
      if not origins.hasKey(next):
        origins[next] = newTable[Dir, Origin]()

      if not alreadyVisited or cost < origins[next][dir].cost:
        origins[next][dir] = (current.point, dir, cost)
        
        # printGridCosts(grid, origins)
        # echo "=".repeat(100)
        front.insert((next, dir, cost), 0)

proc part1*(): int =
  echo "=".repeat(100)
  const input = staticRead("testInput")
  let grid: Grid = input.splitLines()
    .map(l => l.toSeq.map(p => parseInt($p)))
  let start = (x: 0, y: 0)
  let target = (x: grid[0].len - 1, y: grid.len - 1)

  var visited = initHashSet[Point]()

  let path = calcPath(grid, start, target)
  var prevPoint = start
  for point in path:
    echo &"visit {point}"
    if point == start: continue
    for p in prevPoint .. point:
      if p in visited: continue
      result += grid[p]
      visited.incl(p)
    prevPoint = point

  echo "Grid="
  echo grid.mapIt(it.join(" ")).join("\n")

  echo "Path="
  for y in 0 ..< grid.len:
    for x in 0 ..< grid[0].len:
      if (x, y) in visited:
        stdout.write("# ")
      else:
        stdout.write(". ")
    stdout.write("\n")

proc part2*(): int =
  const input = staticRead("testInput")
  const lines = input.splitLines()
  
  return 0
