import std/strutils
import std/strformat
import std/tables
import std/sequtils
import math
import sugar

func parseNumbers(nums: string): seq[int] =
  return nums.split(' ')
    .map(n => n.strip)
    .filter(n => n.len > 0)
    .map(n => n.parseInt)
  
proc part1*(): int =
  const input = staticRead("testInput")
  const lines = input.splitLines
  for line in lines:
    let numbers = line.split(":")[1].split("|")
    let myNumbers = numbers[1].parseNumbers
    let winningNumbers = numbers[0].parseNumbers
    let myWinningNumbers = myNumbers.filter(n => n in winningNumbers)
    if myWinningNumbers.len == 0:
      continue
    result += 2 ^ (myWinningNumbers.len - 1)

func part2*(): int =
  const input = staticRead("input")
  const lines = input.splitLines
  var allCards = newSeq[(int)]()
  for line in lines:
    let numbers = line.split(":")[1].split("|")
    let myNumbers = numbers[1].parseNumbers
    let winningNumbers = numbers[0].parseNumbers
    let myWinningNumbers = myNumbers.filter(n => n in winningNumbers)
    allCards.add(myWinningNumbers.len)

  proc processCards(cards: seq[int], take=cards.len): int =
    var score = 0
    for index in 0..<take:
      let card = cards[index]
      score += 1
      if card == 0:
        continue
      score += processCards(cards[index + 1..<cards.len], card)
    return score

  return processCards(allCards)
