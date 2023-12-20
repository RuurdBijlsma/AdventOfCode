import std/strutils
import std/tables
import std/sequtils
import std/sugar

type Xmas = TableRef[string, int]
type XmasRanges = Table[string, HSlice[int, int]]
type XmasCond = (xmas: Xmas) -> bool

proc part1*(): int =
  const input = staticRead("input")
  const sections = input.split("\n\n")
  const workflows = sections[0].splitLines()
    .map(line => line.split("{"))
    .map(p => (name: p[0], procs: p[1].substr(0, p[1].len - 2).split(",").map(i => i.split(":"))))
  let parts: seq[Xmas] = sections[1].splitLines()
    .map(line => line.split(","))
    .map(part => part
        .map(d => d.toSeq.filter(isDigit).join(""))
        .map(parseInt))
    .map(part => {"x": part[0], "m": part[1], "a": part[2], "s": part[3]}.newTable)

  var flows = newTable[string, seq[(tuple[condition: XmasCond, destination: string])]]()
  for (name, procs) in workflows:
    var flow = newSeq[(tuple[condition: XmasCond, destination: string])]()
    
    for procedure in procs:
      var dest: string
      var condition: XmasCond
      if procedure.len == 1:
        condition = proc(xmas: Xmas): bool = true
        dest = procedure[0]
      else: 
        if procedure[0].contains("<"):
          let g = procedure[0].split("<")
          proc isSatisfied(num: int, key: string): XmasCond =
            proc(xmas: Xmas): bool =
              xmas[key] < num
          condition = isSatisfied(g[1].parseInt, g[0])
        elif procedure[0].contains(">"):
          let g = procedure[0].split(">")
          proc isSatisfied(num: int, key: string): XmasCond =
            proc(xmas: Xmas): bool =
              xmas[key] > num
          condition = isSatisfied(g[1].parseInt, g[0])
        dest = procedure[1]

      flow.add((condition: condition, destination: dest))
    flows[name] = flow
  
  proc isAccepted(part: Xmas, flowName: string): bool =
    if flowName == "A": return true
    if flowName == "R": return false
    let flow = flows[flowName]
    for (condition, destination) in flow:
      if condition(part):
        return isAccepted(part, destination)

  for part in parts:
    let accept = isAccepted(part, "in")
    if accept:
      for num in part.values:
        result += num

proc part2*(): int =
  const input = staticRead("input")
  const workflows = input.split("\n\n")[0].splitLines()
    .map(line => line.split("{"))
    .map(p => (name: p[0], procs: p[1].substr(0, p[1].len - 2).split(",").map(i => i.split(":"))))

  var flows = newTable[string, seq[(tuple[lt: int, gt: int, key: string, destination: string])]]()
  for (name, procs) in workflows:
    var flow = newSeq[(tuple[lt: int, gt: int, key: string, destination: string])]()
    
    for procedure in procs:
      var component = (lt: -1, gt: -1, key: "", destination: procedure[procedure.len - 1])
      if procedure.len == 2:
        if procedure[0].contains("<"):
          let g = procedure[0].split("<")
          component.key = g[0]
          component.lt = g[1].parseInt
        if procedure[0].contains(">"):
          let g = procedure[0].split(">")
          component.key = g[0]
          component.gt = g[1].parseInt
      flow.add(component)
    flows[name] = flow

  let xmas: XmasRanges = {"x": 1 .. 4000, "m": 1 .. 4000, "a": 1 .. 4000, "s": 1 .. 4000}.toTable
  var queue = @[(xmas, "in")]
  while queue.len > 0:
    var (xmas, workflow) = queue.pop()
    if workflow == "R": continue
    if workflow == "A":
      var combinations = 1
      for slice in xmas.values:
        combinations *= slice.b - (slice.a - 1)
      result += combinations
      continue
    for (lt, gt, key, destination) in flows[workflow]:
      var clamped = xmas
      if key != "":
        if lt != -1:
          clamped[key].b = min(clamped[key].b, lt - 1)
          xmas[key].a = max(xmas[key].a, lt)
        if gt != -1:
          clamped[key].a = max(clamped[key].a, gt + 1)
          xmas[key].b = min(xmas[key].b, gt)
      queue.insert((clamped, destination), 0)
