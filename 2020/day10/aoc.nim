import nimbench, strutils, sequtils, sugar, algorithm, typetraits

func getDifferences(outputs: auto): auto=
  var differences = @[outputs[0]]
  for (prev, current) in zip(outputs[0..<outputs.len - 1], outputs[1..<outputs.len]):
    differences.add current - prev
  return differences

proc part1(): void = 
  const input = staticRead("input")
  const outputs = input.splitLines.map(parseInt).sorted
  const differences = getDifferences outputs
  echo (differences.filter(d => d == 3).len + 1) * differences.filter(d => d == 1).len

func countArrangments(outputs: auto, startJoltage: int, endJoltage: int): int=
  if startJoltage == endJoltage - 3: return 1

  for valid in outputs.filter(output => startJoltage < output and startJoltage >= output - 3):
    result += countArrangments(outputs, valid, endJoltage)

func getSubSlices(outputs: auto): seq[seq[int]]=
  var slice = @[outputs[0]]
  for (prev, current) in zip(outputs[0..<outputs.len - 1], outputs[1..<outputs.len]):
    if current - prev == 3:
      result.add slice;
      slice = newSeq[int]()
    slice.add current
  result.add slice

func distinctArrangements(outputs: auto): auto=
  let subSlices = getSubSlices(outputs)
  var joltage = 0
  result = 1
  for slice in subSlices:
    result *= countArrangments(slice, joltage, slice.max + 3)
    joltage = slice[slice.len - 1]

proc part2(): void = 
  const input = staticRead("input")
  const outputs = input.splitLines.map(parseInt).sorted
  const result = distinctArrangements outputs
  echo result


bench(part1, m):
  for _ in 0..m:
    part1()

bench(part2, m):
  for _ in 0..m:
    part2()

runBenchmarks()
# part1()
# part2()