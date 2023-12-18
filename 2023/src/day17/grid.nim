import std/[tables, strformat]

type Dir* = enum
  vertical, horizontal, none

type
  Grid* = seq[seq[int]]
    ## A matrix of nodes. Each cell is the cost of moving to that node

  Point* = (tuple[x, y: int])
    ## A point within that grid

  FrontEl* =
    (tuple[point: Point, dir: Dir, cost: int])

func `[]`*(grid: Grid, point: Point): int =
  grid[point.y][point.x]

func reverse*(dir: Dir): Dir =
  if dir == Dir.vertical:
    return Dir.horizontal
  if dir == Dir.horizontal: 
    return Dir.vertical
  return Dir.none

func exists*(grid: Grid, point: Point): bool =
  point.y >= 0 and point.y < grid.len and
    point.x >= 0 and point.x < grid[point.y].len

template validYield( grid: Grid, point: Point, dir: Dir ) =
  if grid.exists(point):
    yield (point, dir)

iterator neighbors*( grid: Grid, point: Point, dir: Dir, step: HSlice[int, int]): (Point, Dir) =
  for i in -step.b .. step.b:
    if abs(i) < step.a: continue
    if dir == Dir.vertical or dir == Dir.none:
      grid.validYield (x: point.x + i, y: point.y), Dir.horizontal
    if dir == Dir.horizontal or dir == Dir.none:
      grid.validYield (x: point.x, y: point.y + i), Dir.vertical

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

proc cost*(grid: Grid, a, b: Point): int =
  for p in a >.. b:
    result += grid[p]