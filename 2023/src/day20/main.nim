import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm
import std/sets

type Module2 = (tuple[name: string, kind: char, memory: TableRef[string, bool], on: bool, outputs: seq[string]])
const Low = false
const High = true

proc part1*(): int =
  const input = staticRead("testInput2")
  const moduleStrs = input.splitLines().map(line => line.split(" -> "))
  var modules = newTable[string, Module2]()
  for module in moduleStrs:
    let name = if module[0] == "broadcaster": module[0] else: module[0].substr(1)
    modules[name] = (name, module[0][0], newTable[string, bool](), false, module[1].split(", "))

  for module in modules.values:
    if module.kind != '&': continue
    for otherModule in modules.values:
      if module == otherModule: continue
      if module.name in otherModule.outputs:
        modules[module.name].memory[otherModule.name] = Low

  proc pushButton(initialQueue: seq[(string, bool, string)]): (int, int) =
    var queue = initialQueue
    while queue.len > 0:
      let (name, pulse, sender) = queue.pop()
      if pulse: result[0] += 1
      else: result[1] += 1

      # let pulseName = if pulse: "+" else: "-"
      # echo &"{sender} {pulseName} {name}"

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

  let queue = @[("broadcaster", Low, "button")]
  let presses = 1000
  var lows, highs: int
  for _ in 1 .. presses:
    # echo ""
    let (lowPresses, highPresses) = pushButton(queue)
    # echo ""
    lows += lowPresses
    highs += highPresses

  return lows * highs

type Module = (tuple[name: string, kind: char, outputs: HashSet[string], inputs: HashSet[string]])

proc part2*(): int =
  echo "\n".repeat(200)
  const input = staticRead("input")
  const moduleStrs = input.splitLines().map(line => line.split(" -> "))
  var modules = newTable[string, Module]()
  var moduleInputs = newTable[string, seq[Module]]()

  for module in moduleStrs:
    let name = if module[0] == "broadcaster": module[0] else: module[0].substr(1)
    modules[name] = (name, module[0][0], module[1].split(", ").toHashSet, initHashSet[string]())


  for module in modules.values:
    for otherModule in modules.values:
      if module == otherModule: continue
      if module.name in otherModule.outputs:
        modules[module.name].inputs.incl(otherModule.name)

  for module in modules.values:
    for outputName in module.outputs:
      if not moduleInputs.hasKey(outputName):
        moduleInputs[outputName] = newSeq[Module]()
      moduleInputs[outputName].add(module)

  # echo "Modules="
  # for module in modules.values:
  #   echo module
  # echo ""
  # echo "ModuleInputs="
  # for (key, value) in moduleInputs.pairs:
  #   echo &"{key}={value}"
  # echo ""

  # How many presses until "con" gets a low pulse
  # answer: 2

  # hoe zorg je ervoor dat % een signal stuurt:
    # 1. the state of that module needs to be on
    # 2. and it needs to receive a low pulse
    # Hij start op off state
    # dus voor low pulses:
      # 1. send high
      # 2. send low
      # repeat
    # `n` is low pulses received
    # if n mod 2 == 0: low pulse
    # if n mod 2 == 1: high pulse

  # hoe zorg je ervoor dat & een signal stuurt:
    # low pulse:
      # De memory voor elke input moet high pulse zijn
    # high pulse
      # all other cases

  # how to find fewest button presses to low or high pulse a module
  # find all inputs for that module
  # for each input:
    # find out fewest button presses required for that input to send a desired pulse to the module
    # ^ with recursione

  proc calcFewestPresses(target: string, pulse: bool): int =
    # echo &"{target}, {pulse}"
    var fewestPresses = int.high

    for inputModule in moduleInputs[target]:
      var presses = int.high
      if inputModule.kind == 'b':
        # broadcaster as input
        if not pulse:
          # high pulse kan je niet krijgen van een broadcaster
          # echo "ERROR NOT POSSIBLE"
          continue
        else: 
          # voor low pulse is 1 press nodig
          presses = 1
      elif inputModule.kind == '%':
        if pulse:
          # input needs to receive 1 low pulse to send a high one to target
          presses = calcFewestPresses(inputModule.name, Low)
        else:
          # input needs to receive 2 low pulses to send a high one to target
          let p = calcFewestPresses(inputModule.name, Low)
          if p != int.high:
            presses = 2 * p
      elif inputModule.kind == '&':
        if pulse:
          presses = min(calcFewestPresses(inputModule.name, Low), calcFewestPresses(inputModule.name, High))
        if not pulse:
          # om low pulse van & te krijgen moeten alle in puts van deze boy een high pulse gestuurd hebben
          var pressesRequired = newSeq[int]()
          var fail = false
          for conInput in moduleInputs[inputModule.name]:
            let p = calcFewestPresses(conInput.name, High)
            if p == int.high:
              fail = true
              break
            pressesRequired.add(p)
          if not fail:
            presses = lcm(pressesRequired)
        
      if presses < fewestPresses:
        fewestPresses = presses

    # echo &"Fewest presses = {fewestPresses}"
    return fewestPresses
  
  calcFewestPresses("rx", Low)
  
