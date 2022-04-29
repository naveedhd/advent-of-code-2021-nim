import strutils
import sequtils
import sugar
import std/algorithm


proc read_input(filename: string): seq[int] =
  collect:
    for elem in filename.lines.toSeq[0].split(','):
      elem.parseInt

func grow_fishes(data: openArray[int], steps: int): int =
  type FishCountArray = array[9, int]
  var fish_life_count: FishCountArray

  for d in data:
    inc fish_life_count[d]

  for _ in 1 .. steps:
    fish_life_count.rotateLeft(1)
    fish_life_count[6] += fish_life_count[8]

  fish_life_count.foldl(a + b)

func solve1(data: openArray[int]): int =
  grow_fishes(data, 80)

func solve2(data: openArray[int]): int =
  grow_fishes(data, 256)



let filename = "./input"
let data = read_input(filename)

echo solve1(data)
echo solve2(data)
