import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm

func getNextDigit(digits: seq[int]): int =
  if digits.all(d => d == 0):
    return 0

  var differences = newSeq[int]()
  for i in 1 ..< digits.len:
    differences.add(digits[i] - digits[i - 1])

  return differences[differences.len - 1] + getNextDigit(differences)

func part1*(): int =
  const input = staticRead("input")
  const lines = input.splitLines()
    .map(l => l.split(" ").map(parseInt))
  for line in lines:
    result += line[line.len - 1] + getNextDigit(line)

func getPrevDigit(digits: seq[int]): int =
  if digits.all(d => d == 0):
    return 0

  var differences = newSeq[int]()
  for i in 1 ..< digits.len:
    differences.add(digits[i] - digits[i - 1])

  return differences[0] - getPrevDigit(differences)

func part2*(): int =
  const input = staticRead("input")
  const lines = input.splitLines()
    .map(l => l.split(" ").map(parseInt))
  for line in lines:
    result += line[0] - getPrevDigit(line)
