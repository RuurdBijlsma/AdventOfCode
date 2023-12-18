import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm

type Point = (tuple[x, y: int])

proc area(polygon: seq[Point]): int =
  var area = 0
  var prevPoint = polygon[polygon.len - 1]
  for point in polygon:
    area += (prevPoint.x + point.x) * (prevPoint.y - point.y)
    prevPoint = point
  return abs(area / 2).int

proc part1*(): int =
  echo "\n".repeat(20)
  const input = staticRead("input")
  let lines = input.splitLines()
    .mapIt(it.split(" "))
  var position = (x: 0, y: 0)
  var loop = newSeq[Point]()
  var perimeter = 0
  
  for line in lines:
    loop.add(position)
    let dir = line[0][0]
    let length = line[1].parseInt()
    perimeter += length
    if dir == 'U': position.y -= length
    if dir == 'D': position.y += length
    if dir == 'L': position.x -= length
    if dir == 'R': position.x += length
  
  return loop.area() + int(perimeter / 2) + 1

proc part2*(): int =
  const input = staticRead("input")
  let lines = input.splitLines()
    .mapIt(it.split(" "))

  var position = (x: 0, y: 0)
  var loop = newSeq[Point]()
  var perimeter = 0
  
  for line in lines:
    loop.add(position)
    let hex = line[2].substr(2, line[2].len - 2)
    let length = hex.substr(0, hex.len - 2).parseHexInt
    let dir = hex[hex.len - 1]
    perimeter += length
    if dir == '3': position.y -= length
    if dir == '1': position.y += length
    if dir == '2': position.x -= length
    if dir == '0': position.x += length
  
  return loop.area() + int(perimeter / 2) + 1
