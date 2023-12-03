import std/strutils
import std/strformat
import std/tables
import std/sequtils
import math

  
func part1*(): int =
  const input = staticRead("input")
  const width = input.find("\n")
  const height = floor(input.len / width).toInt
  var grid: array[width, array[height, char]]
  const lines = input.splitLines
  for (y, line) in lines.pairs:
    for (x, c) in line.pairs:
      grid[x][y] = c
      
  # Find symbols
  var symbols = newSeq[(int, int)]()
  for y in 0..<height:
    for x in 0..<width:
      let value = grid[x][y]
      if value.isDigit or value == '.':
        continue
      symbols.add((x, y))

  # Find numbers
  for y in 0..<height:
    var contX = 0;
    for x in 0..<width:
      if x < contX:
        continue
      
      let numStart = x
      var numEnd = x
      if grid[x][y].isDigit:
        var number = $grid[x][y]
        for x2 in x + 1..<width:
          contX = x2
          if grid[x2][y].isDigit:
            number &= grid[x2][y]
            numEnd = x2
          else:
            break
        # Look through symbols
        for (sx, sy) in symbols:
          if sy <= y + 1 and sy >= y - 1 and sx >= numStart - 1 and sx <= numEnd + 1:
            result += number.parseInt
            break

func part2*(): int =
  const input = staticRead("input")
  const width = input.find("\n")
  const height = floor(input.len / width).toInt
  var grid: array[width, array[height, char]]
  const lines = input.splitLines
  for (y, line) in lines.pairs:
    for (x, c) in line.pairs:
      grid[x][y] = c
      
  # Find gears
  var gears = newSeq[(int, int)]()
  for y in 0..<height:
    for x in 0..<width:
      let value = grid[x][y]
      if value == '*':
        gears.add((x, y))

  # Find numbers
  var numbers = newSeq[(int, int, int, int)]()
  for y in 0..<height:
    var contX = 0;
    for x in 0..<width:
      if x < contX:
        continue
      
      let numStart = x
      var numEnd = x
      if grid[x][y].isDigit:
        var number = $grid[x][y]
        for x2 in x + 1..<width:
          contX = x2
          if grid[x2][y].isDigit:
            number &= grid[x2][y]
            numEnd = x2
          else:
            break
        numbers.add((number.parseInt, numStart, numEnd, y))

  # Find gear ratios
  for (gx, gy) in gears:
    var touchers = newSeq[int]()
    for (number, startX, endX, y) in numbers:
      if gx >= startX - 1 and gx <= endX + 1 and gy >= y - 1 and gy <= y + 1:
        touchers.add(number)
    if touchers.len == 2:
      let ratio = touchers.foldl(a * b, 1)
      result += ratio