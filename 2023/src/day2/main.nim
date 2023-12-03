import std/strutils
import std/strformat
import std/tables
import std/sequtils

func part1*(): int =
  const input = staticRead("input.txt")

  const possible = {
    "red": 12,
    "blue": 13,
    "green": 14,
  }.toTable
  const games = input.splitLines()
  var validGames = newSeq[int]()
  for (i, game) in games.pairs:
    validGames.add(i + 1)
    let reveals = game.split(": ")[1].split("; ")
    
    block outer:
      for reveal in reveals:
        let cubeInfos = reveal.split(", ")
        for cubeInfo in cubeInfos:
          let info = cubeInfo.split(" ")
          let amount = info[0].parseInt()
          let color = info[1]
          if amount > possible[color]:
            validGames.delete(validGames.find(i + 1))
            break outer
  
  return validGames.foldl(a + b, 0)

func part2(): int =
  const input = staticRead("input.txt")

  result = 0
  const games = input.splitLines()
  var validGames = newSeq[int]()
  for (i, game) in games.pairs:
    validGames.add(i + 1)
    var minimums = initTable[string, int]()
    let reveals = game.split(": ")[1].split("; ")
    
    block outer:
      for reveal in reveals:
        let cubeInfos = reveal.split(", ")
        for cubeInfo in cubeInfos:
          let info = cubeInfo.split(" ")
          let amount = info[0].parseInt()
          let color = info[1]
          if not minimums.hasKey(color):
            minimums[color] = 0
          if amount > minimums[color]:
            minimums[color] = amount
    
    result += minimums.values.toSeq.foldl(a * b, 1)