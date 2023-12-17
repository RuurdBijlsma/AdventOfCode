import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm
import std/sets
import astar

type
    Grid = seq[seq[int]]
        ## A matrix of nodes. Each cell is the cost of moving to that node

    Point = (tuple[x, y: int])
        ## A point within that grid

func `[]`(grid: Grid, point: Point): int =
  grid[point.y][point.x]

template yieldIfExists( grid: Grid, point: Point ) =
    ## Checks if a point exists within a grid, then calls yield it if it does
    let exists =
        point.y >= 0 and point.y < grid.len and
        point.x >= 0 and point.x < grid[point.y].len
    if exists:
        yield point

iterator neighbors*( grid: Grid, point: Point ): Point =
    ## An iterator that yields the neighbors of a given point
    yieldIfExists( grid, (x: point.x - 1, y: point.y) )
    yieldIfExists( grid, (x: point.x + 1, y: point.y) )
    yieldIfExists( grid, (x: point.x, y: point.y - 1) )
    yieldIfExists( grid, (x: point.x, y: point.y + 1) )

proc cost*(grid: Grid, a, b: Point): float =
    ## Returns the cost of moving from point `a` to point `b`
    float(1 + grid[b.y][b.x])

proc heuristic*( grid: Grid, node, goal: Point ): int =
    ## Returns the priority of inspecting the given node
    0
    # manhattan[Point, int](node, goal)

proc part1*(): int =
  echo "=".repeat(100)
  const input = staticRead("testInput")
  let grid: Grid = input.splitLines()
    .map(l => l.toSeq.map(p => parseInt($p)))
  let start = (x: 0, y: 0)
  let target = (x: grid[0].len - 1, y: grid.len - 1)

  var visited = initHashSet[Point]()

  for point in path[Grid, Point, float](grid, start, target):
    echo &"done {point} = {grid[point]}"
    visited.incl(point)
    if point == (0, 0): continue
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
