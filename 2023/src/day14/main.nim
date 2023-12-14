import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm

func part1*(): int =
  const input = staticRead("input")
  const grid = input.splitLines()
  for x in 0 ..< grid[0].len:
    var rockPos = 0
    for y in 0 ..< grid.len:
      if grid[y][x] == '#':
        rockPos = y + 1
      elif grid[y][x] == 'O':
        result += grid.len - rockPos
        rockPos += 1

type Dir = enum
  north, west, south, east

proc tiltGrid(grid: var seq[string], dir: Dir): void =
  if dir == Dir.north:
    for x in 0 ..< grid[0].len:
      var rockPos = 0
      for y in 0 ..< grid.len:
        if grid[y][x] == '#':
          rockPos = y + 1
        elif grid[y][x] == 'O':
          grid[y][x] = '.'
          grid[rockPos][x] = 'O'
          rockPos += 1
  elif dir == Dir.south:
    for x in 0 ..< grid[0].len:
      var rockPos = grid.len - 1
      for y in countdown(grid.len - 1, 0):
        if grid[y][x] == '#':
          rockPos = y - 1
        elif grid[y][x] == 'O':
          grid[y][x] = '.'
          grid[rockPos][x] = 'O'
          rockPos -= 1
  elif dir == Dir.west:
    for y in 0 ..< grid.len:
      var rockPos = 0
      for x in 0 ..< grid[y].len:
        if grid[y][x] == '#':
          rockPos = x + 1
        elif grid[y][x] == 'O':
          grid[y][x] = '.'
          grid[y][rockPos] = 'O'
          rockPos += 1
  elif dir == Dir.east:
    for y in 0 ..< grid.len:
      var rockPos = grid[y].len - 1
      for x in countdown(grid[y].len - 1, 0):
        if grid[y][x] == '#':
          rockPos = x - 1
        elif grid[y][x] == 'O':
          grid[y][x] = '.'
          grid[y][rockPos] = 'O'
          rockPos -= 1

proc part2*(): int =
  const input = staticRead("input")
  var grid = input.splitLines()

  const cycle = [Dir.north, Dir.west, Dir.south, Dir.east]
  const cycles = 1000000000
  var grids = newSeq[seq[string]]()
  var repeatCycle = (0, 0)

  for i in 0 ..< cycles:
    for dir in cycle:
      tiltGrid(grid, dir)
    if grid in grids:
      repeatCycle = (grids.find(grid), i)
      break
    grids.add(grid)

  let requiredCycles = (cycles - repeatCycle[0]) mod (repeatCycle[1] - repeatCycle[0])
  grid = grids[repeatCycle[0] + requiredCycles - 1]

  for x in 0 ..< grid[0].len:
    for y in 0 ..< grid.len:
      if grid[y][x] == 'O':
        result += grid.len - y