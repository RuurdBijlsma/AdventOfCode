import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm
import std/options

proc isGood(springInfo: string, contiguous: seq[int]): bool =
  var contigCount = 0
  var contigSeq = newSeq[int]()
  for c in springInfo:
    if c == '#':
      contigCount += 1
    elif contigCount > 0:
      contigSeq.add(contigCount)
      contigCount = 0
  if contigCount > 0:
      contigSeq.add(contigCount)
  contigSeq == contiguous

proc getArrangementCount(springInfo: string, contiguous: seq[int]): int =
  var varSeq = springInfo.toSeq
    .mapIt(if it == '#': @["#"] elif it == '.': @["."] else: @["#", "."])

  product(varSeq).countIt(isGood(it.join(""), contiguous))

proc part1*(): int =
  const input = staticRead("input")
  const lines = input.splitLines()
  var i = 0
  for line in lines:
    i += 1
    echo &"{i} / {lines.len}"
    let parts = line.split(" ")
    result += getArrangementCount(parts[0], parts[1].split(",").map(parseInt))


proc part2*(): int =
  const input = staticRead("input")
  const lines = input.splitLines()
  
  return 0
