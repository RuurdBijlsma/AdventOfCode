import strutils, sequtils, algorithm, sugar

proc first*[T](s: openArray[T], pred: proc(x: T): bool {.closure.}): T
                                                                  {.inline.} =
  for i in 0 ..< s.len:
    if pred(s[i]):
        return s[i]

const input = staticRead("../input")

# Part 1
let numbers = input.split("\c\n").map(parseInt)
const target = 2020

echo product(@[numbers, numbers]).first((nums) => nums.foldl(a + b) == target).foldl(a * b)

# Part 2
echo product(@[numbers, numbers, numbers]).first((nums) => nums.foldl(a + b) == target).foldl(a * b)

