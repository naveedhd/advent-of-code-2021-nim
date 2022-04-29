from std/strutils import parseInt
import itertools
import sequtils
import sugar


proc read_input(filename: string): seq[int] =
  filename.lines.toSeq.map(parseInt)

proc solve1(vals: seq[int]): int =
  vals
    .pairwise
    .toSeq
    .filter(val => val[0] < val[1])
    .len

proc solve2(vals: seq[int]): int =
  vals
    .windowed(4)
    .toSeq
    .filter(val => val[0] + val[1] + val[2] < val[1] + val[2] + val[3])
    .len


let filename = "./input"
let vals = read_input(filename)

echo solve1(vals)
echo solve2(vals)
