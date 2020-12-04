import strutils, sequtils, nimbench

func parseLine(line: string): auto = 
  let tokens = line.split(' ')
  let lengthConstraint = tokens[0].split('-')
  let min = lengthConstraint[0].parseInt;
  let max = lengthConstraint[1].parseInt;
  let letter = tokens[1][0]
  let password = tokens[2]
  return (min, max, letter, password)

proc part1(): void =
  const input = staticRead("../input")

  const numbers = input.split("\c\n").map(parseLine)
  var valid = 0
  for (min, max, letter, password) in numbers:
    let charCount = password.count(letter)
    if charCount <= max and charCount >= min:
      valid += 1
  echo valid

proc part2(): void =
  const input = staticRead("../input")

  const numbers = input.split("\c\n").map(parseLine)
  var valid = 0
  for (i, j, letter, password) in numbers:
    if password[i - 1] == letter xor password[j - 1] == letter:
      valid += 1
  echo valid

bench(part1, m):
  for _ in 0..m:
    part1()

bench(part2, m):
  for _ in 0..m:
    part2()

runBenchmarks()