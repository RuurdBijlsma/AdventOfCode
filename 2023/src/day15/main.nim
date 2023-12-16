import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm

func hash(str: string): int =
  for c in str:
    result += int(c)
    result *= 17
    result = result mod 256

func part1*(): int =
  const input = staticRead("input")
  const parts = input.split(",")
  parts.foldl(a + b.hash(), 0)

func part2*(): int =
  const input = staticRead("input")
  const parts = input.split(",")
  var boxes = newSeqWith(256, newTable[string, int]())
  for part in parts:
    if '-' in part:
      let p = part.split('-')
      boxes[p[0].hash()].del(p[0])
    if '=' in part:
      let p = part.split('=')
      boxes[p[0].hash()][p[0]] = p[1].parseInt
      
  for (i, box) in boxes.pairs:
    var j = 1
    for (key, val) in box.pairs:
      result += (i + 1) * (j * val)
      j += 1