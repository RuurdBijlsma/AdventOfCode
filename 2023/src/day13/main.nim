import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm
import std/sets
import std/options

func getReflectionPoint(lines: seq[string], smudges = 0): int =
  for i in 1 ..< lines[0].len:
    var leftLine = ""
    var rightLine = ""
    for line in lines:
      let lineLen = min(i, line.len - i)
      let left = line.substr(i - lineLen, i - 1)
      var right = line.substr(i, i + lineLen - 1)
      right.reverse()
      leftLine &= left
      rightLine &= right
    var smudgeCount = 0
    for j in 0 ..< leftLine.len:
      if leftLine[j] == rightLine[j]:
        continue
      smudgeCount += 1
      if smudgeCount > smudges:
        break
    if smudgeCount == smudges:
      return i

func transpose(grid: seq[string]): seq[string] =
  result = newSeq[string]()
  for x in 0 ..< grid[0].len:
    var line = ""
    for y in 0 ..< grid.len:
      line &= grid[y][x]
    result.add(line)

func part1*(): int =
  const input = staticRead("input")
  input.split("\n\n").map(p => p.splitLines())
    .mapIt((getReflectionPoint(it), getReflectionPoint(it.transpose)))
    .foldl(a + b[0] + b[1] * 100, 0)

func part2*(): int =
  const input = staticRead("input")
  input.split("\n\n").map(p => p.splitLines())
    .mapIt((getReflectionPoint(it, 1), getReflectionPoint(it.transpose, 1)))
    .foldl(a + b[0] + b[1] * 100, 0)

