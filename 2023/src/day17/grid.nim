type
  Grid* = seq[seq[int]]
    ## A matrix of nodes. Each cell is the cost of moving to that node

  Point* = (tuple[x, y: int])
    ## A point within that grid

  Origin* = (tuple[point: Point, cost: int])

func `[]`*(grid: Grid, point: Point): int =
  grid[point.y][point.x]

func difference*(a, b: Point): Point =
  (abs(a.x - b.x), abs(a.y - b.y))

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