import std/[tables]

const maxSteps = 3

type Dir* = enum
  vertical, horizontal, none

type
  Grid* = seq[seq[int]]
    ## A matrix of nodes. Each cell is the cost of moving to that node

  Point* = (tuple[x, y: int])
    ## A point within that grid

  Origin* = (tuple[point: Point, dir: Dir, cost: int])

func `[]`*(grid: Grid, point: Point): int =
  grid[point.y][point.x]

func reverse*(dir: Dir): Dir =
  if dir == Dir.vertical:
    return Dir.horizontal
  if dir == Dir.horizontal: 
    return Dir.vertical
  return Dir.none

template validYield( grid: Grid, point: Point, dir: Dir ) =
  ## Checks if a point exists within a grid, then calls yield it if it does
  let exists = point.y >= 0 and point.y < grid.len and
    point.x >= 0 and point.x < grid[point.y].len
  if exists:
    yield (point, dir)

iterator neighbors*( grid: Grid, point: Point, dir: Dir ): (Point, Dir) =
  for i in -maxSteps + 1 ..< maxSteps:
    if i == 0: continue
    if dir == Dir.vertical or dir == Dir.none:
      grid.validYield (x: point.x + i, y: point.y), Dir.horizontal
    if dir == Dir.horizontal or dir == Dir.none:
      grid.validYield (x: point.x, y: point.y + i), Dir.vertical