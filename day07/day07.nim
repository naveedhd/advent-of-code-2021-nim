import strutils
import sequtils
import sugar


proc read_input(filename: string): seq[int] =
  collect:
    for elem in filename.lines.toSeq[0].split(','):
      elem.parseInt


proc solve1(positions: openArray[int]): int =
  let min_val = positions.min
  let max_val = positions.max
  let val_range = max_val - min_val + 1
  var fuel_for_position = newSeq[int](val_range)

  for position in positions:
    for i in 0 ..< val_range:
      let idx_position = min_val + i
      let fuel = if idx_position < position: position - idx_position else: idx_position - position
      fuel_for_position[i] += fuel

  fuel_for_position.min


proc solve2(positions: openArray[int]): int =
  let min_val = positions.min
  let max_val = positions.max
  let val_range = max_val - min_val + 1
  var fuel_for_position = newSeq[int](val_range)

  for position in positions:
    for i in 0 ..< val_range:
      let idx_position = min_val + i
      let displacement = if idx_position < position: position - idx_position else: idx_position - position
      let fuel = displacement * (displacement + 1) div 2
      fuel_for_position[i] += fuel

  fuel_for_position.min


let filename = "./input"
let data = read_input(filename)

echo solve1(data)
echo solve2(data)
