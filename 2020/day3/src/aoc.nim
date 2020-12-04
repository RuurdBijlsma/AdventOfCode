import strutils, nimbench

func countTrees(grid: seq[string], slope: (int, int)): int =
  let gridWidth = grid[0].len
  for y in countup(0, grid.len - 1, slope[1]):
    result += int(grid[y][(y div slope[1] * slope[0]) mod gridWidth] == '#')

proc part1(): void = 
  const input = staticRead("../input")
  const grid = input.split("\c\n")
  const slope = (3, 1)
  echo countTrees(grid, slope)

proc part2(): void =
  const input = staticRead("../input")
  const grid = input.split("\c\n")
  const slopes = @[(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]

  var result = 1
  for slope in slopes:
    result *= countTrees(grid, slope)
  echo result

bench(part1, m):
  for _ in 0..m:
    part1()

bench(part2, m):
  for _ in 0..m:
    part2()

runBenchmarks()
# part1()
# part2()