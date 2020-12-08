import nimbench, strutils, sequtils, sugar

func runInstructions(instructions: auto, swapIndex = -1): auto =
  var i = 0
  var visited = newSeq[bool](instructions.len)
  var accumulator = 0
  while i < instructions.len:
    if visited[i]:
      return (true, accumulator)
    var (instruction, value) = instructions[i]
    visited[i] = true

    if i == swapIndex:
      if instruction == "jmp":
        instruction = "nop"
      elif instruction == "nop":
        instruction = "jmp"

    case instruction: 
      of "acc":
        accumulator += value
      of "jmp":
        i += value - 1
      else:
        discard
    i += 1
  return (false, accumulator)

proc part1(): void = 
  const input = staticRead("input")
  const instructions = input.splitLines.map(line => line.split(' ')).map(line => (line[0], line[1].parseInt))
  const accumulator = runInstructions(instructions)[1]
  echo accumulator

func fixProgram(instructions: auto): auto =
  for i, instruction in instructions:
    if instruction[0] in ["jmp", "nop"]:
      let (loop, value) = runInstructions(instructions, i)
      if not loop:
        return value

proc part2(): void = 
  const input = staticRead("input")
  const instructions = input.splitLines.map(line => line.split(' ')).map(line => (line[0], line[1].parseInt))
  const accumulator = fixProgram(instructions)
  echo accumulator

bench(part1, m):
  for _ in 0..m:
    part1()

bench(part2, m):
  for _ in 0..m:
    part2()

runBenchmarks()
# part1()
# part2()