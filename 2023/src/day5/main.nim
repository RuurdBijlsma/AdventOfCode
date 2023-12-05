import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import algorithm
import std/threadpool
{.experimental: "parallel".}

type RangeMap = (HSlice[int, int], HSlice[int, int])

func find(rt: seq[RangeMap], target: int, defaultValue: int = target): int =
  var left = 0
  var right = rt.len - 1
  while left <= right:
    let middle = (left + right) div 2
    let source = rt[middle][0]
    if source.b < target:
      # we kijken links van target
      left = middle + 1
    elif source.a > target:
      # we kijken rechts van target
      right = middle - 1
    else:
      return target - source.a + rt[middle][1].a
  return defaultValue

func rangeTableSort(x, y: RangeMap): int =
  if x[0].a >= y[0].a: 1
  else: -1

func getAlmanacMaps(parts: seq[string]): OrderedTable[string, seq[RangeMap]] =
  result = initOrderedTable[string, seq[RangeMap]]()
  for part in parts[1..<parts.len]:
    let lines = part.splitLines
    let key = lines[0].split(" ")[0]
    var map = newSeq[RangeMap]()
    for line in lines[1 ..< lines.len]:
      let values = line.split(" ").map(parseInt)
      let destStart = values[0]
      let sourceStart = values[1]
      let rangeLen = values[2]
      map.add((sourceStart ..< sourceStart + rangeLen, destStart ..< destStart + rangeLen))

    sort(map, rangeTableSort)
    result[key] = map

func getClosestSeed(seeds: HSlice[int, int], maps: OrderedTable[string, seq[RangeMap]]): int =
  result = -1;
  for seed in seeds:
    var value = seed 
    for transform in maps.keys:
      value = maps[transform].find(value)
    if result == -1 or value < result:
      result = value

func part1*(): int =
  const input = staticRead("input")
  const parts = input.split("\n\n")
  const maps = getAlmanacMaps(parts)
  return parts[0]
    .split(":")[1]
    .split(" ")
    .filter(s => s.len > 0)
    .map(parseInt)
    .map(s => getClosestSeed(s..s, maps))
    .min()


func part2*(): int =
  const input = staticRead("input")
  const parts = input.split("\n\n")
  const maps = getAlmanacMaps(parts)

  const seedValues = parts[0]
    .split(":")[1]
    .split(" ")
    .filter(s => s.len > 0)
    .map(parseInt)
  let seedPairs = seedValues
    .distribute(seedValues.len div 2)
    .map(s => (s[0]..<s[0] + s[1]))

  var locations = newSeq[int](seedPairs.len)
  parallel:
    for (i, seeds) in seedPairs.pairs:
      locations[i] = spawn getClosestSeed(seeds, maps)

  return locations.min()
