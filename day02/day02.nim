import sequtils
import strutils
import sugar


type
  Command = tuple[direction: string, magnitude: int]


proc parse_command(line: string): Command =
  let s = line.split(' ', 1)
  (s[0], s[1].parseInt)

proc read_input(filename: string): seq[Command] =
  filename
    .lines
    .toSeq
    .map(parse_command)


# proc updater1(position: (int, int), command: Command): (int, int) =
#   if command.direction == "forward":
#     result = (position[0] + command.magnitude, position[1])

#   elif command.direction == "down":
#     result = (position[0], position[1] + command.magnitude)

#   elif command.direction == "up":
#     result = (position[0], position[1] - command.magnitude)




proc solve1(vals: seq[Command]): int =
  proc updater(position: (int, int), command: Command): (int, int) =
    let (direction, magnitude) = command
    if direction == "forward":
      result = (position[0] + magnitude, position[1])

    elif direction == "down":
      result = (position[0], position[1] + magnitude)

    elif direction == "up":
      result = (position[0], position[1] - magnitude)

  let final_position = vals.foldl(updater(a, b), (0, 0))

  final_position[0] * final_position[1]


proc solve2(vals: seq[Command]): int =
  proc updater(position: (int, int, int), command: Command): (int, int, int) =
    let (direction, magnitude) = command
    if direction == "forward":
      result = (position[0] + magnitude, position[1] + magnitude * position[2], position[2])

    elif direction == "down":
      result = (position[0], position[1], position[2] + magnitude)

    elif direction == "up":
      result = (position[0], position[1], position[2] - magnitude)

  let final_position = vals.foldl(updater(a, b), (0, 0, 0))

  final_position[0] * final_position[1]




let filename = "./input"
let vals = read_input(filename)

echo solve1(vals)
echo solve2(vals)
