import strutils, nimbench, sequtils, sugar, tables, colors

func parsePerson(lines: string): Table[string, string] =
  for kv in lines.split({'\c', '\n', ' '}).filter((l)=>':' in l).map((d) => d.split(':')):
    result[kv[0]] = kv[1]

proc part1(): void = 
  const input = staticRead("../input")
  const persons = input.split("\c\n\c\n").map(parsePerson)
  const requiredFields = @["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"];
  
  var invalid = 0
  for person in persons:
    for field in requiredFields:
      if not (field in person):
        invalid += 1
        break
  echo persons.len - invalid

func isValid(person: Table[string, string]): auto =
  try:
    if not (person["byr"].parseInt in 1920..2002):    
      return 0  
    if not (person["iyr"].parseInt in 2010..2020):    
      return 0  
    if not (person["eyr"].parseInt in 2020..2030):    
      return 0  
    let height = person["hgt"]
    let heightRange = (if height.substr(height.len - 2) == "cm": 150..193 else: 59..76)
    if not (height.substr(0, height.len - 3).parseInt in heightRange):    
      return 0  
    if not isColor(person["hcl"]) or person["hcl"].len != 7 or person["hcl"][0] != '#':    
      return 0  
    const eyeColors = @["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
    if not(person["ecl"] in eyeColors):    
      return 0  
    if person["pid"].len != 9:    
      return 0
    discard person["pid"].parseInt
    return 1
  except:
    return 0

proc part2(): void = 
  const input = staticRead("../input")
  const persons = input.split("\c\n\c\n").map(parsePerson)
  echo persons.map(isValid).foldl(a + b)

bench(part1, m):
  for _ in 0..m:
    part1()

bench(part2, m):
  for _ in 0..m:
    part2()

runBenchmarks()
# part1()
# part2()