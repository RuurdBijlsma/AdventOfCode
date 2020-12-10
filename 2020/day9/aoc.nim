import nimbench, strutils, sequtils, options

func first_invalid_num(nums: auto, n: auto): auto=
  for i in n..<nums.len:
    let num = nums[i]
    var valid = false
    for j in i - n..<i:
      for k in j..<i:
        if nums[j] + nums[k] == num:
          valid = true
          break
      if valid: break
    if not valid:
      return some(num)
  return none(int)

proc part1(): void = 
  const input = staticRead("input")
  const nums = input.splitLines.map(parseInt)
  echo first_invalid_num(nums, 25)

func find_weakness(nums: auto, invalid: auto): auto=
  for i in 0..<nums.len - 1:
    for j in i + 2..<nums.len:
      var sum = 0
      for k in i..j:
        sum += nums[k]
        if sum > invalid:
          break;
      if sum == invalid:
        return some(nums[i..j])
  return none(seq[int])

proc part2(): void = 
  const input = staticRead("input")
  const nums = input.splitLines.map(parseInt)

  const invalid = first_invalid_num(nums, 25)
  if not invalid.isSome:
    return

  const weaknessOption = find_weakness(nums, invalid.get())
  if not weaknessOption.isSome:
    return

  const weakness = weaknessOption.get()
  var min = weakness[0]
  var max = weakness[0]
  for num in weakness:
    if num < min: 
      min = num
    if num > max:
      max = num
  echo min + max


bench(part1, m):
  for _ in 0..m:
    part1()

bench(part2, m):
  for _ in 0..m:
    part2()

runBenchmarks()
part1()
part2()