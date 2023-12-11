import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm
import std/sets

type Dir = enum
  up, right, down, left, none

const reverseDir = {
  Dir.up: Dir.down,
  Dir.right: Dir.left,
  Dir.down: Dir.up,
  Dir.left: Dir.right,
  Dir.none: Dir.none,
}.toTable

# What pipe can connect when the other pipe outputs this direction?
const dirToPipe = {
  Dir.up: ['S', '|', 'F', '7'].toHashSet,
  Dir.right: ['S', '-', '7', 'J'].toHashSet,
  Dir.down: ['S', '|', 'L', 'J'].toHashSet,
  Dir.left: ['S', '-', 'L', 'F'].toHashSet,
}.toTable

# What dir can this pipe connect to
const pipeToDir = {
  'S': @[Dir.up, Dir.right, Dir.down, Dir.left],
  '|': @[Dir.up, Dir.down],
  '-': @[Dir.right, Dir.left],
  'L': @[Dir.up, Dir.right],
  'J': @[Dir.up, Dir.left],
  '7': @[Dir.down, Dir.left],
  'F': @[Dir.right, Dir.down],
  '.': newSeq[Dir](),
}.toTable

func fits(pipeA, pipeB: char, dir: Dir): bool =
  pipeB in dirToPipe[dir]

func `+`(pos: (int, int), dir: Dir): (int, int) =
  if dir == Dir.up:
    return (pos[0], pos[1] - 1)
  if dir == Dir.right:
    return (pos[0] + 1, pos[1])
  if dir == Dir.down:
    return (pos[0], pos[1] + 1)
  if dir == Dir.left:
    return (pos[0] - 1, pos[1])

func makeLoop(input: static string): (seq[string], int, int, HashSet[(int, int)]) =
  const startIndex = input.find("S")
  var grid = input.splitLines()
  let width = grid[0].len
  let height = grid.len
  let sX = startIndex mod (width + 1)
  let sY = startIndex div (width + 1)
  let position = (sX, sY, Dir.none)
  
  template inGrid(pos: (int, int)): bool =
    pos[0] >= 0 and pos[1] >= 0 and pos[0] < width and pos[1] < height

  # Replace start S with pipe that fits
  var startNeighbours = newSeq[Dir]()
  for dir in pipeToDir['S']:
    let (x, y) = (sX, sY) + dir
    if not (x, y).inGrid() or not 'S'.fits(grid[y][x], dir):
      continue
    startNeighbours.add(dir)
  grid[sY][sX] = pipeToDir.pairs.toSeq.filter(f => f[1] == startNeighbours)[0][0]

  var frontier = @[position]
  var visited = [(position[0], position[1])].toHashSet

  while true:
    if frontier.len == 0:
      break

    let (x, y, origin) = frontier.pop()
    let pipe = grid[y][x]
    for dir in pipeToDir[pipe]:
      # Don't go back
      if dir == origin:
        continue
      let (x2, y2) = (x, y) + dir
      if (x2, y2) in visited:
        continue
      visited.incl((x2, y2))
      frontier.insert((x2, y2, reverseDir[dir]), 0)
  
  return (grid, width, height, visited)

proc part1*(): int =
  const input = staticRead("input")
  const (_, _, _, visited) = makeLoop(input)
  return visited.len div 2

proc part2*(): int =
  const input = staticRead("input")
  const (grid, width, height, visited) = makeLoop(input)

  let illegalCombos = ["L7", "FJ"]
  for y in 0 ..< height:
    for x in 0 ..< width:
      if (x, y) in visited:
        continue
      var intersectCount = 0
      var prevIntersect = '.'
      for x2 in 0 ..< x:
        let pipe = grid[y][x2]
        if pipe == '-' or prevIntersect & pipe in illegalCombos or not ((x2, y) in visited):
          continue
        prevIntersect = pipe
        intersectCount += 1
      if intersectCount mod 2 == 1:
        result += 1
