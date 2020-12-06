import nimbench, strutils, sequtils, sugar, sets, tables

proc part1(): void = 
  const input = staticRead("input")
  const groups = input.split("\c\n\c\n").map((line) => toSeq(line.items).filter((c) => not(c in "\n\c")).toHashSet)
  echo groups.map((g) => g.len).foldl(a + b)

func getGroupSum(group: seq[string]): int =
  var table = toSeq(Letters).map((l) => (l, 0)).toTable
  for person in group:
    for letter in person.items:
      table[letter] += 1
  for key, value in table:
    if value == group.len:
      result += 1

proc part2(): void = 
  const input = staticRead("input")
  echo input.split("\c\n\c\n").map((group) => group.splitLines().getGroupSum()).foldl(a + b)

bench(part1, m):
  for _ in 0..m:
    part1()

bench(part2, m):
  for _ in 0..m:
    part2()

runBenchmarks()
# part1()
# part2()