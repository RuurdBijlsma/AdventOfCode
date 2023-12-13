import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm
import std/options
import std/sets

proc getContiguous(springInfo: string): seq[int] =
  var contigCount = 0
  result = newSeq[int]()
  for c in springInfo:
    if c == '#':
      contigCount += 1
    elif contigCount > 0:
      result.add(contigCount)
      contigCount = 0
  if contigCount > 0:
      result.add(contigCount)

proc getArrangementCount(springInfo: string, contiguous: seq[int]): int =
  var varSeq = springInfo.toSeq
    .mapIt(if it == '#': @["#"] elif it == '.': @["."] else: @["#", "."])

  product(varSeq).countIt(getContiguous(it.join("")) == contiguous)

proc part1*(): int =
  const input = staticRead("testInput")
  const lines = input.splitLines()
  for line in lines:
    let parts = line.split(" ")
    result += getArrangementCount(parts[0], parts[1].split(",").map(parseInt))

var memo = newTable[(string, seq[string]), int]()

proc countFits(springInfo: string, slidingWindows: seq[string], winI = 0): int =
  if winI >= slidingWindows.len:
    # Als de remaining springInfo string nog een '#' heeft, zijn de windows verkeerd ingedeeld
    # dus return je 0 ipv 1 want dit pad telt niet
    return if springInfo.contains("#"): 0 else: 1
  let window = slidingWindows[winI]
  let windowsToTheRight = slidingWindows[winI + 1 ..< slidingWindows.len]
  let minSpaceRequiredForWindowsToTheRight = windowsToTheRight.foldl(a + b.len - 1, -1)
  let endI = springInfo.len - window.len - minSpaceRequiredForWindowsToTheRight
  for i in -1 .. endI:
    var fits = true
    # Check if every char of the window matches with the springInfo at this position in the slide:
    for j in i ..< i + window.len:
      if j != springInfo.len and j >= 0 and springInfo[j] != '?' and springInfo[j] != window[j - i]:
        fits = false
        break
    if fits:
      let subSpringInfo = springInfo.substr(i + window.len)
      let key = (subSpringInfo, slidingWindows[winI ..< slidingWindows.len])
      var count: int
      if memo.hasKey(key):
        count = memo[key]
      else:
        count = countFits(subSpringInfo, slidingWindows, winI + 1)
        memo[key] = count
      result += count
    else:
      # If you have to skip over a broken spring, this recursive path is wrong
      if i >= 0 and springInfo[i] == '#':
        return result

proc part2*(): int =
  let repeatCount = 5
  const input = staticRead("input")
  const lines = input.splitLines()
  var i = 0
  for line in lines:
    let parts = line.split(" ")
    let springInfo = sequtils.repeat(parts[0], repeatCount).join("?")
    let contiguous = parts[1].split(",")
      .map(parseInt)
      .repeat(repeatCount)
      .foldl(a & b)
    
    let slidingWindows = contiguous.mapIt("." & "#".repeat(it) & ".")
    let fitCount = countFits(springInfo, slidingWindows)

    echo &"LINE {i}"
    i += 1

    result += fitCount
