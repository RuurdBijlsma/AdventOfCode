import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm

func part1*(expansionFactor = 2): int =
  const input = staticRead("input")
  const grid = input.splitLines()

  var doubledRows = newSeq[int]()
  var doubledColumns = newSeq[int]()
  for (row, line) in grid.pairs:
    if line == ".".repeat(line.len):
      doubledRows.add(row)

  var positions = newSeq[(int, int)]()
  for x in 0 ..< grid[0].len:
    var column = ""
    for y in 0 ..< grid.len:
      if grid[y][x] == '#':
        positions.add((x, y))
      column &= grid[y][x]
    if column == ".".repeat(column.len):
      doubledColumns.add(x)

  for i in 0 ..< positions.len - 1:
    for j in i + 1 ..< positions.len:
      let p1 = positions[i]
      let p2 = positions[j]
      let x = p2[0] - p1[0] + doubledColumns.countIt(it in p1[0]..p2[0]) * (expansionFactor - 1)
      let y = abs(p1[1] - p2[1]) + doubledRows.countIt(it in min(p1[1], p2[1])..max(p1[1], p2[1])) * (expansionFactor - 1)
      result += x + y

proc part2*(): int =
  part1(1000000)
