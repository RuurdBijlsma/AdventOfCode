import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm

func handStrength(hand: seq[string]): string =
  let valueSet = hand.deduplicate()
  var maxOfAKind = 1
  for value in valueSet:
    maxOfAKind = max(hand.count(value), maxOfAKind)
  let handString = hand.join("")
  if maxOfAKind == 5:
    return $7 & handString
  if maxOfAKind == 4:
    return $6 & handString
  if valueSet.len == 2:
    # full house
    return $5 & handString
  if maxOfAKind == 3:
    return $4 & handString
  if maxOfAKind == 2 and valueSet.len == 3:
    # 2 pair
    return $3 & handString
  return $maxOfAKind & handString

func handSort(x, y: (seq[string], int)): int =
  if x[0].handStrength() >= y[0].handStrength(): 1
  else: -1

proc part1*(): int =
  const valueMap: Table[char, string] = {
    'T': "10",
    'J': "11",
    'Q': "12",
    'K': "13",
    'A': "14",
  }.toTable

  const input = staticRead("input")
  const hands = input.splitLines
    .map(line => line.split(" "))
    .map(line => (line[0].toSeq().map(c => (if c.isDigit(): "0" & c else: valueMap[c])), line[1].parseInt))

  hands.sort(handSort)

  result = 0
  for (index, hand) in hands.pairs:
    result += hand[1] * (index + 1)
    

proc part2*(): int =
  const valueMap: Table[char, string] = {
    'J': "00",
    'T': "10",
    'Q': "12",
    'K': "13",
    'A': "14",
  }.toTable

  const input = staticRead("input")
  const hands = input.splitLines
    .map(line => line.split(" "))
    .map(line => (line[0].toSeq().map(c => (if c.isDigit(): "0" & c else: valueMap[c])), line[1].parseInt))

  hands.sort(handSort)

  result = 0
  for (index, hand) in hands.pairs:
    result += hand[1] * (index + 1)
