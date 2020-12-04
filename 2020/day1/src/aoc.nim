import strutils, sequtils, nimbench

proc part1(): void =
  const input = staticRead("../input")

  const numbers = input.split("\c\n").map(parseInt)
  const target = 2020

  for i in 0..<numbers.len:
    for j in i + 1..<numbers.len:
      if numbers[i] + numbers[j] == target:
        echo numbers[i] * numbers[j]
        return

proc part2(): void =
  const input = staticRead("../input")

  const numbers = input.split("\c\n").map(parseInt)
  const target = 2020

  for i in 0..<numbers.len:
    for j in i + 1..<numbers.len:
      for k in j + 1..<numbers.len:
        if numbers[i] + numbers[j] + numbers[k] == target:
          echo numbers[i] * numbers[j] * numbers[k]
          return

bench(part1, m):
  for _ in 0..m:
    part1()

bench(part2, m):
  for _ in 0..m:
    part2()

runBenchmarks()