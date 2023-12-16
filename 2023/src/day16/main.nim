import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm
import std/sets

type Dir = enum
  up, right, down, left

func `[]`(b: seq[string], pos: (int, int)): char =
  b[pos[1]][pos[0]]

func `+`(pos: (int, int), dir: Dir): (int, int) =
  if dir == Dir.up:
    return (pos[0], pos[1] - 1)
  if dir == Dir.right:
    return (pos[0] + 1, pos[1])
  if dir == Dir.down:
    return (pos[0], pos[1] + 1)
  if dir == Dir.left:
    return (pos[0] - 1, pos[1])

const rotate = {
  Dir.up: {
    '/': Dir.right,
    '\\': Dir.left,
  }.toTable,
  Dir.right: {
    '/': Dir.up,
    '\\': Dir.down,
  }.toTable,
  Dir.down: {
    '/': Dir.left,
    '\\': Dir.right,
  }.toTable,
  Dir.left: {
    '/': Dir.down,
    '\\': Dir.up,
  }.toTable,
}.toTable

iterator itemDirections(dir: Dir, item: char): Dir =
  if item == '.':
    yield dir
  elif item == '/' or item == '\\':
    yield rotate[dir][item]
  elif item == '-':
    if dir == Dir.up or dir == Dir.down:
      yield Dir.left
      yield Dir.right
    elif dir == Dir.left or dir == Dir.right:
      yield dir
  elif item == '|':
    if dir == Dir.left or dir == Dir.right:
      yield Dir.up
      yield Dir.down
    elif dir == Dir.up or dir == Dir.down:
      yield dir

func countEnergized(grid: static seq[string], entry: ((int, int), Dir)): int =
  template inGrid(pos: (int, int)): bool =
    pos[0] >= 0 and pos[1] >= 0 and pos[0] < grid[0].len and pos[1] < grid.len
  
  var beams = initHashSet[((int, int), Dir)]()
  var energized = initHashSet[(int, int)]()
  var queue = @[entry]
  while true:
    if queue.len == 0:
      break
    let (pos, dir) = queue.pop()
    let newPos = pos + dir
    if not newPos.inGrid():
      continue
    energized.incl(newPos)
    for newDir in dir.itemDirections(grid[newPos]):
      let beam = (newPos, newDir)
      if beam in beams:
        continue
      beams.incl(beam)
      queue.insert((newPos, newDir), 0)

  return energized.len

proc part1*(): int =
  const input = staticRead("input")
  const grid = input.splitLines()
  countEnergized(grid, ((-1, 0), Dir.right))

proc part2*(): int =
  const input = staticRead("input")
  const grid = input.splitLines()

  for y in 0 ..< grid.len:
    result = max(result, countEnergized(grid, ((-1, y), Dir.right)))
    result = max(result, countEnergized(grid, ((grid[y].len, y), Dir.left)))

  for x in 0 ..< grid[0].len:
    result = max(result, countEnergized(grid, ((x, -1), Dir.down)))
    result = max(result, countEnergized(grid, ((x, grid.len), Dir.up)))