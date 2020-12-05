import nimbench, sequtils, strutils

func getId(seat: string): int {.compileTime.} =
  var seatYmin = 0
  var seatYmax = 127
  var seatXmin = 0
  var seatXmax = 7
  for letter in seat:
    let middleY = seatYmin + (seatYmax - seatYmin) div 2
    let middleX = seatXmin + (seatXmax - seatXmin) div 2
    case letter:
      of 'F':
        seatYmax = middleY
      of 'B':
        seatYmin = middleY
      of 'L':
        seatXmax = middleX
      of 'R':
        seatXmin = middleX
      else:
        discard
  seatYmax * 8 + seatXmax


proc part1(): void = 
  const seats = staticRead("input").splitLines
  const maxId = seats.map(getId).max
  echo maxId


func missingId(ids: seq[int]): auto {.compileTime.} =
  for id in ids.min + 1..<ids.max:
    if not(id in ids):
      return id
  return -1


proc part2(): void = 
  const seats = staticRead("input").splitLines
  const ids = seats.map(getId)
  echo ids.missingId


bench(part1, m):
  for _ in 0..m:
    part1()

bench(part2, m):
  for _ in 0..m:
    part2()

runBenchmarks()
# part1()
# part2()