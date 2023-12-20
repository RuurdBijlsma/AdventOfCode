import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm
import std/sets

type Module = (tuple[name: string, kind: char, memory: TableRef[string, bool], on: bool, outputs: seq[string]])


proc part1*(): int =
  const input = staticRead("input")
  const moduleStrs = input.splitLines().map(line => line.split(" -> "))
  var modules = newTable[string, Module]()
  for module in moduleStrs:
    let name = if module[0] == "broadcaster": module[0] else: module[0].substr(1)
    modules[name] = (name, module[0][0], newTable[string, bool](), false, module[1].split(", "))

  for module in modules.values:
    if module.kind != '&': continue
    for otherModule in modules.values:
      if module == otherModule: continue
      if module.name in otherModule.outputs:
        modules[module.name].memory[otherModule.name] = false

  proc pushButton(initialQueue: seq[(string, bool, string)]): (int, int) =
    var queue = initialQueue
    while queue.len > 0:
      let (name, pulse, sender) = queue.pop()
      if pulse: result[0] += 1
      else: result[1] += 1

      # echo &"{sender} -> {pulse} -> {name}"

      if not modules.hasKey(name): continue

      if modules[name].kind == 'b':
        for output in modules[name].outputs:
          queue.insert((output, pulse, name), 0)
          
      elif modules[name].kind == '%' and not pulse:
        modules[name].on = not modules[name].on
        for output in modules[name].outputs:
          queue.insert((output, modules[name].on, name), 0)
          
      elif modules[name].kind == '&':
        modules[name].memory[sender] = pulse
        var allHigh = true
        for v in modules[name].memory.values:
          if not v:
            allHigh = false
            break
        for output in modules[name].outputs:
          queue.insert((output, not allHigh, name), 0)

  let queue = @[("broadcaster", false, "button")]
  let presses = 1000
  var lows, highs: int
  for _ in 1 .. presses:
    # echo ""
    let (low, high) = pushButton(queue)
    lows += low
    highs += high
    # echo ""

  return lows * highs

proc part2*(): int =
  const input = staticRead("input")
  const moduleStrs = input.splitLines().map(line => line.split(" -> "))
  var modules = newTable[string, Module]()
  for module in moduleStrs:
    let name = if module[0] == "broadcaster": module[0] else: module[0].substr(1)
    modules[name] = (name, module[0][0], newTable[string, bool](), false, module[1].split(", "))

  for module in modules.values:
    if module.kind != '&': continue
    for otherModule in modules.values:
      if module == otherModule: continue
      if module.name in otherModule.outputs:
        modules[module.name].memory[otherModule.name] = false

  proc pushButton(initialQueue: seq[(string, bool, string)], targets: HashSet[string], targetOutput: bool): HashSet[string] =
    var queue = initialQueue
    while queue.len > 0:
      let (name, pulse, sender) = queue.pop()
      for target in targets:
        if sender == target and targetOutput == pulse:
          result.incl(target)

      # echo &"{sender} -> {pulse} -> {name}"

      if not modules.hasKey(name): continue

      if modules[name].kind == 'b':
        for output in modules[name].outputs:
          queue.insert((output, pulse, name), 0)
          
      elif modules[name].kind == '%' and not pulse:
        modules[name].on = not modules[name].on
        for output in modules[name].outputs:
          queue.insert((output, modules[name].on, name), 0)
          
      elif modules[name].kind == '&':
        modules[name].memory[sender] = pulse
        var allHigh = true
        for v in modules[name].memory.values:
          if not v:
            allHigh = false
            break
        for output in modules[name].outputs:
          queue.insert((output, not allHigh, name), 0)


  let queue = @[("broadcaster", false, "button")]
  var presses = 0
  let testHighs = @["ln", "dr", "zx", "vn"].toHashSet
  var testCycles = {"ln": newSeq[int](), "dr": newSeq[int](), "zx": newSeq[int](), "vn": newSeq[int]()}.newTable
  while true:
    let targetsDone = pushButton(queue, testHighs, true)
    for target in targetsDone:
      testCycles[target].add(presses)
      echo testCycles

    presses += 1
    if presses mod 1_000 == 0:
      echo presses
      
    if testCycles.values.toSeq.mapIt(it.len).min() > 5:
      break

  var diffs = newSeq[int]()
  for (key, value) in testCycles.pairs:
    if value[value.len - 1] - value[value.len - 2] != value[value.len - 2] - value[value.len - 3]:
      echo "cycle not lienar"
    diffs.add(value[value.len - 1] - value[value.len - 2])
  echo diffs
  lcm(diffs)
  