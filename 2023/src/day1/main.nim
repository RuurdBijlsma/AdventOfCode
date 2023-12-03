import strutils
import strformat
import tables

func part1*(): int =
  const input = staticRead("input.txt")
  const lines = input.splitLines()
  result = 0;
  for line in lines:
    var firstDigit = ""
    var lastDigit = ""
    for c in line:
      if c.isDigit():
        if firstDigit == "":
          firstDigit = $c;
        lastDigit = $c;

    result += (firstDigit & lastDigit).parseInt()

func part2*(): int =
  const input = staticRead("input.txt")
  const lines = input.splitLines()
  const digits = {
    "one": "1",
    "1": "1",
    "two": "2",
    "2": "2",
    "three": "3",
    "3": "3",
    "four": "4",
    "4": "4",
    "five": "5",
    "5": "5",
    "six": "6",
    "6": "6",
    "seven": "7",
    "7": "7",
    "eight": "8",
    "8": "8",
    "nine": "9",
    "9": "9",
  }.toTable 
  result = 0;
  
  for line in lines:
    var firstIndex = -1
    var firstDigit = ""
    var lastIndex = -1
    var lastDigit = ""

    for (name, digit) in digits.pairs:
      let findex = line.find(name)
      let lindex = line.rfind(name)
      if findex == -1: continue
      if firstIndex == -1 or findex < firstIndex:
        firstIndex = findex
        firstDigit = digit
      if lastIndex == -1 or lindex > lastIndex:
        lastIndex = lindex
        lastDigit = digit
    
    result += (firstDigit & lastDigit).parseInt()