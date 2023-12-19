import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm

type Xmas = TableRef[string, int]
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
    # echo name
    # echo procs
    
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
              # echo &"{xmas[key]} < {num}"
              xmas[key] < num
          condition = isSatisfied(g[1].parseInt, g[0])
        elif procedure[0].contains(">"):
          let g = procedure[0].split(">")
          proc isSatisfied(num: int, key: string): XmasCond =
            proc(xmas: Xmas): bool =
              # echo &"{xmas[key]} > {num}"
              xmas[key] > num
          condition = isSatisfied(g[1].parseInt, g[0])
        dest = procedure[1]

      let test: Xmas = {"x":787,"m":2655,"a":1222,"s":2876}.newTable
      # echo &"if {condition(test)} -> {dest}"
      flow.add((condition: condition, destination: dest))
    flows[name] = flow
  
  proc isAccepted(part: Xmas, flowName: string): bool =
    # echo &"{flowName}"
    if flowName == "A": return true
    if flowName == "R": return false
    let flow = flows[flowName]
    for (condition, destination) in flow:
      if condition(part):
        return isAccepted(part, destination)

  for part in parts:
    let accept = isAccepted(part, "in")
    # echo &"part {part} is accepted: {accept}"
    if accept:
      for num in part.values:
        result += num

proc part2*(): int =
  const input = staticRead("input")
  const lines = input.splitLines()
  
  return 0
