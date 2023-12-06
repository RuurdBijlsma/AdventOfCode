import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm

type Ranges = (HSlice[int, int], HSlice[int, int])

func rangesDestSort(x, y: Ranges): int =
  if x[1].a >= y[1].a: 1
  else: -1

func find(rt: seq[Ranges], target: int, defaultValue: int = target): int =
  for (source, destination) in rt:
    if target in source:
      return target - source.a + destination.a
  return defaultValue

func overlaps(a: HSlice[int, int], b: HSlice[int, int]): bool =
  a.a >= b.a and a.a <= b.b or a.b >= b.a and a.b <= b.b or 
  b.a >= a.a and b.a <= a.b

func intersect(a: HSlice[int, int], b: HSlice[int, int]): HSlice[int, int] =
  max(a.a, b.a)..min(a.b, b.b)

func getAlmanacMaps(parts: seq[string]): seq[seq[Ranges]] =
  result = newSeq[seq[Ranges]]()

  for part in parts[1..<parts.len]:
    let lines = part.splitLines()
    var map = newSeq[Ranges]()

    for line in lines[1..<lines.len]:
      let values = line.split(" ").map(parseInt)
      let destStart = values[0]
      let sourceStart = values[1]
      let rangeLen = values[2]
      map.add((sourceStart ..< (sourceStart + rangeLen), destStart ..< (destStart + rangeLen)))

    map.sort(rangesDestSort)
    var addFillers = newSeq[Ranges]()
    var lastDestEnd = 0
    for (source, dest) in map:

      if dest.a > lastDestEnd:
        let filler = (lastDestEnd ..< dest.a, lastDestEnd ..< dest.a)
        addFillers.add(filler)

      lastDestEnd = dest.b + 1

    map &= addFillers
    map.sort(rangesDestSort)

    let filler = (lastDestEnd .. int.high div 2, lastDestEnd .. int.high div 2)
    map.add(filler)

    result.insert(map, 0)

func dive(seeds: seq[HSlice[int, int]], maps: seq[seq[Ranges]], index: int, targetDestination: HSlice[int, int]): (bool, HSlice[int, int]) =

  if index == 7:
    for seedRange in seeds:
      if targetDestination.overlaps(seedRange):
        let intersect = seedRange.intersect(targetDestination)
        return (true, intersect)
    return (false, 0..0)

  let map = maps[index]
  for (source, destination) in map:
    if destination.overlaps(targetDestination):
      let intersected = destination.intersect(targetDestination)
      let sourceRange = intersected.a + source.a - destination.a .. intersected.b + source.b - destination.b
      let (found, seed) = dive(seeds, maps, index + 1, sourceRange)
      if found:
        return (true, seed)

  return (false, 0..0)

func part1*(): int =
  const input = staticRead("input")
  const parts = input.split("\n\n")
  const maps = getAlmanacMaps(parts)
  const seeds = parts[0]
    .split(":")[1]
    .split(" ")
    .filter(s => s.len > 0)
    .map(parseInt)
    .map(s => s..s)

  let (_, seedRange) = dive(seeds, maps, 0, 0..(9999999999.int))

  var reverseMaps = maps;
  reverseMaps.reverse()
  var value = seedRange.a
  for (index, map) in reverseMaps.pairs:
    value = map.find(value)

  return value

func part2*(): int =
  const input = staticRead("input")
  const parts = input.split("\n\n")
  let maps = getAlmanacMaps(parts)

  let seedValues = parts[0]
    .split(":")[1]
    .split(" ")
    .filter(s => s.len > 0)
    .map(parseInt)
  let seeds = seedValues
    .distribute(seedValues.len div 2)
    .map(s => (s[0]..<(s[0] + s[1])))

  let (_, seedRange) = dive(seeds, maps, 0, 0..(9999999999.int))

  var reverseMaps = maps;
  reverseMaps.reverse()
  var value = seedRange.a
  for (index, map) in reverseMaps.pairs:
    value = map.find(value)

  return value