import std/strutils
import std/strformat
import std/tables
import std/sequtils
import std/math
import std/sugar
import std/algorithm
import std/options
import csp/[csp, constraint, solver]

proc getArrangementCount(springInfo: string, contiguous: seq[int]): int =
  # echo springInfo
  # echo contiguous.join(" ")

  var varSeq = springInfo.toSeq
    .mapIt(if it == '#': @["#"] elif it == '.': @["."] else: @["#", "."])

  var constraints = @[
    Constraint[string](
      variables: @["C"],
      isSatisfied: proc(v: varargs[string]): bool =
        var contigCount = 0
        var contigSeq = newSeq[int]()
        for c in v[0]:
          if c == '#':
            contigCount += 1
          elif contigCount > 0:
            contigSeq.add(contigCount)
            contigCount = 0
        if contigCount > 0:
            contigSeq.add(contigCount)
        result = contigSeq == contiguous
        # if result:
        #   echo &"Found correct sequence {v}"
    )
  ]
  for (i, variable) in varSeq.pairs:
    proc isSatisfied(index: int): (varargs[string]) -> bool =
      proc(v: varargs[string]): bool =
        # echo &"Checking satisfaction for v0={v[0]} v1={v[1]} localIndex={index}"
        return v[0][index] == v[1][0]
    constraints.add(Constraint[string](
      variables: @["C", $i],
      isSatisfied: isSatisfied(i)
    ))

  var variables = newTable[string, seq[string]]()
  for (i, v) in varSeq.pairs:
    variables[$i] = v
  variables["C"] = product(varSeq).mapIt(it.join(""))

  # todo binarization met cartesian product:
  # https://cs.stackexchange.com/questions/79228/binarization-of-constraints

  # echo &"VARIABLES"
  # for (k, v) in variables.pairs:
  #   let str = v.join(", ")
  #   echo &"{k}: [{str}]"
  # echo "CONSTRAINTS"
  # echo constraints.join(", ")
  
  var csp = solve(variables, constraints)
  if csp.isSome:
    # echo csp.get()
    return csp.get().solutions.len
  else:
    # echo "result is none"
    return 0

proc part1*(): int =
  const input = staticRead("input")
  const lines = input.splitLines()
  var i = 0
  for line in lines:
    i += 1
    echo &"{i} / {lines.len}"
    let parts = line.split(" ")
    let count = getArrangementCount(parts[0], parts[1].split(",").map(parseInt))
    result += count

  # let parts = lines[0].split(" ")
  # getArrangementCount(parts[0], parts[1].split(",").map(parseInt))


proc part2*(): int =
  const input = staticRead("input")
  const lines = input.splitLines()
  
  return 0
