import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm
import std/sets
import grid
import binaryheap
    
proc calcHeat(grid: Grid, start, target: Point, step: HSlice[int, int]): int =
  var front =
        newHeap[FrontEl] do (a, b: FrontEl) -> int:
            return cmp(a.cost, b.cost)
  front.push((point: start, dir: Dir.none, cost: 0))
  var visited = initHashSet[(Point, Dir)]()

  while front.size > 0:
    let current = front.pop()

    if current.point == target:
      return current.cost
    if visited.contains((current.point, current.dir)):
      continue

    visited.incl((current.point, current.dir))

    for (next, dir) in grid.neighbors(current.point, current.dir, step):
      let cost = current.cost + grid.cost(current.point, next)
      front.push((point: next, dir: dir, cost: cost))

proc part1*(): int =
  const input = staticRead("input")
  let grid: Grid = input.splitLines()
    .map(l => l.toSeq.map(p => parseInt($p)))
  let start = (x: 0, y: 0)
  let target = (x: grid[0].len - 1, y: grid.len - 1)
  calcHeat(grid, start, target, 1 .. 3)

proc part2*(): int =
  const input = staticRead("input")
  let grid: Grid = input.splitLines()
    .map(l => l.toSeq.map(p => parseInt($p)))
  let start = (x: 0, y: 0)
  let target = (x: grid[0].len - 1, y: grid.len - 1)
  calcHeat(grid, start, target, 4 .. 10)