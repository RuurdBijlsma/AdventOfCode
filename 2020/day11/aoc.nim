import nimbench, strutils, sequtils, sugar

type
  Ferry = object
    storage*: seq[char]
    width*: int

proc printGrid(grid: auto): void=
  for line in grid:
    echo line.join()

func getNeighbours(width: int, height: int, x: int, y: int): auto=
  [
    (-1, 0),
    (-1, -1),
    (0, -1),
    (1, -1),
    (1, 0),
    (1, 1),
    (0, 1),
    (-1, 1),
  ]
  .map(pos => (x + pos[0], y + pos[1]))
  .filter(pos => pos[0] >= 0 and pos[0] < width and pos[1] >= 0 and pos[1] < height)

func simulate(grid: ref seq[seq[char]], grid2: ref seq[seq[char]]): bool=
  result = false
  let width = grid[].len
  let height = grid[][0].len
  for y in 0..<width:
    for x in 0..<height:
      let neighbours = getNeighbours(width, height, x, y)
      let occupiedNeighbours = neighbours.map(pos => (if grid[][pos[1]][pos[0]] == '#': 1 else: 0)).foldl(a + b)
      let seat = grid[][y][x]
      case seat:
        of '#':
          grid2[][y][x] = if occupiedNeighbours >= 4: 'L' else: '#'
        of 'L':
          grid2[][y][x] = if occupiedNeighbours == 0: '#' else: 'L'
        else:
          grid2[][y][x] = seat

      if not result and grid2[][y][x] != seat:
        result = true

func stabilize(initialGrid: auto): auto=
  var grid = new seq[seq[char]]
  grid[] = initialGrid
  var grid2 = new seq[seq[char]]
  grid2[] = initialGrid
  while true:
    let change = simulate(grid, grid2)
    if not change:
      return grid[]

proc part1(): void = 
  const input = staticRead("testInput")

  const grid = input.splitLines.map(line => toSeq(line.items))
  let stableGrid = stabilize grid
  echo stableGrid.map(line => line.map(seat => (if seat == '#': 1 else: 0)).foldl(a + b)).foldl(a + b)
      

proc part2(): void = 
  const input = staticRead("input")

bench(part1, m):
  for _ in 0..m:
    part1()

bench(part2, m):
  for _ in 0..m:
    part2()

# runBenchmarks()
part1()
# part2()