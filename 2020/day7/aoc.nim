import nimbench, strutils, sequtils, sugar, tables, sets

func parseRule(line: auto): (string, (seq[string], seq[int])) {.compileTime.} =
  let a = line.split(" bags contain ")
  if a[1] == "no other bags.": return (a[0], (@[], @[]))
  let contains = a[1].substr(0, a[1].len - 2).split(", ")
  let containsCounts = contains.map(rule => rule[0].int - '0'.int)
  let containsBags = contains.map(rule => rule.split(' ')[1..rule.split(' ').len - 2].join(" "))
  return (a[0], (containsBags, containsCounts))

proc part1(): void = 
  const input = staticRead("input")
  const rules = input.splitLines.map(parseRule).toTable

  var wantedColors = @["shiny gold"]
  var parentBags = initHashSet[string]()

  var i = 0
  while i < wantedColors.len:
    let wantedColor = wantedColors[i]
    i += 1
    for color, contains in rules:
      if wantedColor in contains[0]:
        parentBags.incl(color)
        if not(color in wantedColors):
          wantedColors.add(color)
  echo parentBags.len

func countBags(rules: auto, color: auto): int =
  let rule = rules[color]
  for (bagColor, count) in zip(rule[0], rule[1]):
    result += count * (countBags(rules, bagColor) + 1)

proc part2(): void = 
  const input = staticRead("input")
  const rules = input.splitLines.map(parseRule).toTable
  
  const wantedBag = "shiny gold"
  echo countBags(rules, wantedBag)


bench(part1, m):
  for _ in 0..m:
    part1()

bench(part2, m):
  for _ in 0..m:
    part2()

runBenchmarks()
# part1()
# part2()