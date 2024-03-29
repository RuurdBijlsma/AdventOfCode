import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm

func part1*(): int =
  const input = staticRead("input")
  const lines = input.splitLines
    .map(l => l.split(" ").filter(t => t.len > 0))
    .map(t => t[1 ..< t.len].map(parseInt))
  
  result = 1
  for (time, recordDistance) in zip(lines[0], lines[1]):
    var waysToWin = 0
    for speed in 1 ..< time:
      let distance = speed * (time - speed)
      if distance > recordDistance:
        waysToWin += 1
    result *= waysToWin
    

func part2*(): int =
  const input = staticRead("input")
  const lines = input.splitLines
    .map(l => l.split(" ").filter(t => t.len > 0))
    .map(t => t[1 ..< t.len].foldl(a & b, ""))
    .map(parseInt)
  
  const time = lines[0]
  const recordDistance = lines[1]
  result = 0
  for speed in 1 ..< time:
    let distance = speed * (time - speed)
    if distance > recordDistance:
      result += 1
