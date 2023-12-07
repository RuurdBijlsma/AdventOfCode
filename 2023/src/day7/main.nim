import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm

func handStrength(hand: seq[string]): int =
  let jokerlessHand = hand.filter(h => h != "00")
  var jokerCount = hand.count("00")
  let valueSet = jokerlessHand.deduplicate()
  var maxOfAKind = 0
  for value in valueSet:
    maxOfAKind = max(hand.count(value), maxOfAKind)
  maxOfAKind += jokerCount

  if maxOfAKind == 5:
    return 7
  if maxOfAKind == 4:
    return 6
  if valueSet.len == 2:
    # full house
    return 5
  if maxOfAKind == 3:
    return 4
  if valueSet.len == 3:
    # 2 pair
    return 3
  return maxOfAKind

func handSort(x, y: (seq[string], int)): int =
  if $x[0].handStrength() & x[0].join("") >= $y[0].handStrength() & y[0].join(""): 1
  else: -1

func part1*(): int =
  const valueMap: Table[char, string] = {
    'T': "10",
    'J': "11",
    'Q': "12",
    'K': "13",
    'A': "14",
  }.toTable

  const input = staticRead("input")
  var hands = input.splitLines
    .map(line => line.split(" "))
    .map(line => (line[0].toSeq().map(c => (if c.isDigit(): "0" & c else: valueMap[c])), line[1].parseInt))

  hands.sort(handSort)

  result = 0
  for (index, hand) in hands.pairs:
    result += hand[1] * (index + 1)
    

func part2*(): int =
  const valueMap: Table[char, string] = {
    'J': "00",
    'T': "10",
    'Q': "12",
    'K': "13",
    'A': "14",
  }.toTable

  const input = staticRead("input")
  var hands = input.splitLines
    .map(line => line.split(" "))
    .map(line => (line[0].toSeq().map(c => (if c.isDigit(): "0" & c else: valueMap[c])), line[1].parseInt))

  hands.sort(handSort)

  result = 0
  for (index, hand) in hands.pairs:
    result += hand[1] * (index + 1)
