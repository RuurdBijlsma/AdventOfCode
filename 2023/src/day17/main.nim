import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm
import std/sets
import std/terminal
import grid

proc getPath(origins: TableRef[Point, Origin], start, target: Point, limit = int.high): seq[Point] =
  result = @[target]
  var point = target
  while result.len < limit:
    if not origins.hasKey(point) or point == start: 
      break
    point = origins[point].point
    result.add point
  result.reverse()

proc printGridCosts(grid: Grid, origins: TableRef[Point, Origin], highlight: Point) =
  for y in 0 ..< grid.len:
    for x in 0 ..< grid[0].len:
      let pos = (x, y)
      if origins.hasKey(pos):
        let cost = origins[pos].cost
        if pos == highlight:
          setForegroundColor(fgCyan)
          setBackgroundColor(bgRed)
          stdout.write(align($cost, 4))
          setForegroundColor(fgDefault)
          setBackgroundColor(bgDefault)
        else:
          stdout.write(align($cost, 4))
      else:
        stdout.write(" ".repeat(4))
    stdout.write("\n")

proc calcPath(grid: Grid, start: Point, target: Point): seq[Point] =
  var front: seq[Origin] = @[(start, 0)]
  var origins = newTable[Point, Origin]()
  origins[start] = ((-1, -1), 0)

  while true:
    let current = front.pop()

    # let last3 = getPath(origins, start, current.point, 3)
    # echo &"recent path: {last3}"
    # var illegalY = -1;
    # var illegalX = -1
    # if last3.len == 3:
    #   let diff = difference(last3[2], last3[0])
    #   if diff.x == 2:
    #     illegalY = last3[0].y
    #   if diff.y == 2:
    #     illegalX = last3[0].x
    # echo &"Illegals: {(illegalX, illegalY)}"

    if current.point == target:
      echo "       DONE          "
      grid.printGridCosts(origins, (-1, -1))
      echo ""

      return getPath(origins, start, target)

    for next in grid.neighbors(current.point):
      # if next.x == illegalX or next.y == illegalY:
      #   continue

      let cost = current.cost + grid[next]
      let alreadyVisited = next in origins
      if not alreadyVisited or cost < origins[next].cost:
        origins[next] = (current.point, cost)
        echo &"------------visiting {next}-------------"
        grid.printGridCosts(origins, next)
        echo &"----------------- done ------------------"
        front.insert((next, cost), 0)


proc part1*(): int =
  echo "=".repeat(100)
  const input = staticRead("testInput3")
  let grid: Grid = input.splitLines()
    .map(l => l.toSeq.map(p => parseInt($p)))
  let start = (x: 0, y: 0)
  let target = (x: grid[0].len - 1, y: grid.len - 1)

  var visited = initHashSet[Point]()

  let path = calcPath(grid, start, target)
  for point in path:
    echo &"visit {point}"
    visited.incl(point)
    if point != start:
      result += grid[point]

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
