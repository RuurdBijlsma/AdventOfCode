import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm

type Ranges = (HSlice[int, int], HSlice[int, int])

func rangesSourceSort(x, y: Ranges): int =
  if x[0].a >= y[0].a: 1
  else: -1

func rangesDestSort(x, y: Ranges): int =
  if x[1].a >= y[1].a: 1
  else: -1

func find(rt: seq[Ranges], target: int, defaultValue: int = target): int =
  for (source, destination) in rt:
    if target in source:
      return target - source.a + destination.a
  return defaultValue

func part1*(): int =
  return 0

proc overlaps(a: HSlice[int, int], b: HSlice[int, int]): bool =
  a.a >= b.a and a.a <= b.b or a.b >= b.a and a.b <= b.b or 
  b.a >= a.a and b.a <= a.b

proc intersect(a: HSlice[int, int], b: HSlice[int, int]): HSlice[int, int] =
  max(a.a, b.a)..min(a.b, b.b)

proc `-`(a: HSlice[int, int], b: HSlice[int, int]): seq[HSlice[int, int]] =
  if a.a < b.a and a.b > b.b:
    # Full overlap of a over b
    # [aaaaaaaaaa] 
    #   [bbbbb]
    # [cc]   [ccc]
    return @[a.a ..< b.a, b.b + 1 .. a.b]
  if a.a >= b.a and a.b <= b.b:
    #    [aaaaa]
    # [bbbbbbbbbbb]
    # [] *lege return sequence
    return @[]
  if a.a < b.a and a.b < b.b:
    # [aaaaa]
    #    [bbbbb]
    # [ccc]
    return @[a.a ..< b.a]
  if a.a > b.a and a.b > b.b:
    #    [aaaaa]
    # [bbbbb]
    #      [ccc]
    return @[b.b + 1 .. a.b]



proc getAlmanacMaps(parts: seq[string]): seq[seq[Ranges]] =
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

    # todo sort map by dest
    # Filler tot infinity
    let filler = (lastDestEnd .. int.high div 2, lastDestEnd .. int.high div 2)
    map.add(filler)

    result.insert(map, 0)

proc dive(seeds: seq[HSlice[int, int]], maps: seq[seq[Ranges]], index: int, targetDestination: HSlice[int, int]): (bool, HSlice[int, int]) =
  # echo &"TARGET={targetDestination}, INDEX={index}"

  if index == 7:
    # echo "END OF THE LINE"
    for seedRange in seeds:
      if targetDestination.overlaps(seedRange):
        let intersect = seedRange.intersect(targetDestination)
        # echo &"[Found] Seeds {intersect} intersects with T={targetDestination}"
        return (true, intersect)
    # echo "No seed here, returning false"
    # echo ""
    return (false, 0..0)

  let map = maps[index]
  for (source, destination) in map:
    # echo &"S={source}, D={destination}, T={targetDestination}, I={index}"
    if destination.overlaps(targetDestination):
      let intersected = destination.intersect(targetDestination)
      let sourceRange = intersected.a + source.a - destination.a .. intersected.b + source.b - destination.b
      # echo &"OVERLAPS, intersect={intersected}, sourceRange={sourceRange}"
      let (found, seed) = dive(seeds, maps, index + 1, sourceRange)
      if found:
        # echo "Found it [cool] returning true"
        # echo ""
        return (true, seed)
      # echo "[NOT FOUND] ^ back it up!!!!"
  
  # echo "looked at all ranges in map, found nothing, returning false"
  # echo ""
  return (false, 0..0)

proc part2*(): int =
  const input = staticRead("input")
  const parts = input.split("\n\n")
  let maps = getAlmanacMaps(parts)

  # for key, map in maps.pairs:
  #   var sourceMap = map
  #   sourceMap.sort(rangesSourceSort)

  #   var first = true
  #   var prevSource = 0..0
  #   var prevDest = 0..0
  #   echo &"KEY={key}"
  #   for (source, destination) in sourceMap:
  #     if not first and prevSource.overlaps(source):
  #       echo &"                    - - ALARM OVERLAP DETECTED - -"
  #       echo &"N_S={source}, N_D={destination}"
  #       echo &"P_S={prevSource}, P_D={prevDest}"
  #     first = false
  #     prevSource = source
  #     prevDest = destination

  const seedValues = parts[0]
    .split(":")[1]
    .split(" ")
    .filter(s => s.len > 0)
    .map(parseInt)
  const seeds = seedValues
    .distribute(seedValues.len div 2)
    .map(s => (s[0]..<(s[0] + s[1])))

  let (_, seedRange) = dive(seeds, maps, 0, 0..(9999999999.int))

  var reverseMaps = maps;
  reverseMaps.reverse()
  var value = seedRange.a
  for (index, map) in reverseMaps.pairs:
    value = map.find(value)

  return value

# if you found 1 overlap, you can break the loop after checking one more after, because they'll all have no overlap for sure
# Todo check for source overlap in real input