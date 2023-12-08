import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm

type
  Branch = ref object
    left, right: Branch
    l, r, label: string

func newBranch(label: string): Branch =
  new(result)
  result.label = label

iterator cycle[T](s: openArray[T]): T =
  while true:
    for v in s:
      yield v

func makeTree(input: static string): TableRef[string, Branch] =
  const lines = input.splitLines()
  var network = newTable[string, Branch]()

  for line in lines[2 ..< lines.len]:
    let p = line.split(" = ")
    let incoming = p[0]
    let outgoing = p[1].substr(1, p[1].len - 2).split(", ")
    let branch = newBranch(incoming)
    branch.l = outgoing[0]
    branch.r = outgoing[1]
    network[incoming] = branch

  for (key, branch) in network.pairs:
    branch.left = network[branch.l]
    branch.right = network[branch.r]

  return network

func part1*(): int =
  const input = staticRead("input")
  const directions = input.splitLines()[0]

  var position = makeTree(input)["AAA"]
  result = 0

  for direction in directions.cycle:
    result += 1
    if direction == 'L':
      position = position.left
    if direction == 'R':
      position = position.right

    if position.label == "ZZZ":
      return result

func part2*(): int =
  const input = staticRead("input")
  const directions = input.splitLines()[0]

  let network = makeTree(input)
  var positions = network.keys.toSeq
    .filter(k => k[2] == 'A')
    .map(k => network[k])
  var loopLengths = newSeq[int](positions.len)
  result = 0

  for i in 0 ..< positions.len:
    for direction in directions.cycle:
      loopLengths[i] += 1

      if direction == 'L':
        positions[i] = positions[i].left
      if direction == 'R':
        positions[i] = positions[i].right

      if positions[i].label[2] == 'Z':
        break
          
  return lcm(loopLengths)

