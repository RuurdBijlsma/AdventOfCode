import nimbench
import std/strformat

from day9/main import part1, part2

when isMainModule:
  const benchmark = true
  if benchmark:
    bench(part1, m):
      for _ in 0..m:
        discard part1()

    bench(part2, m):
      for _ in 0..m:
        discard part2()

    runBenchmarks()
  else:
    echo fmt"Part 1 = {part1()}"
    echo fmt"Part 2 = {part2()}"
