import sequtils
import strutils
import std/tables
import std/algorithm


type
  Point = (int, int)
  PointPair = (Point, Point)


proc parse_point(point_str: string): Point =
  let split = point_str.split(',', 1)
  (split[0].parseInt, split[1].parseInt)

proc parse_line(line: string): PointPair =
  let split = line.split(" -> ", 1)
  (parse_point(split[0]), parse_point(split[1]))

proc read_input(filename: string): seq[PointPair] =
  filename
    .lines
    .toSeq
    .map(parse_line)


proc rook_iterator(point_pair: PointPair): seq[Point] =
  let a = point_pair[0]
  let b = point_pair[1]

  if a[0] == b[0]:
    let x = a[0]

    let min_y = min(a[1], b[1])
    let max_y = max(a[1], b[1])

    let len = max_y - min_y + 1
    let ys = (min_y..max_y).toSeq
    let xs = repeat(x, len)

    zip(xs, ys)

  elif a[1] == b[1]:
    let y = a[1]

    let min_x = min(a[0], b[0])
    let max_x = max(a[0], b[0])

    let len = max_x - min_x + 1
    let xs = (min_x..max_x).toSeq
    let ys = repeat(y, len)

    zip(xs, ys)

  else:
    @[]

proc diff(x: int, y: int): int =
  let min_val = min(x, y);
  let max_val = max(x, y);

  max_val - min_val + 1

proc queen_iterator(point_pair: PointPair): seq[Point] =

  let a = point_pair[0]
  let b = point_pair[1]

  if diff(a[0], b[0]) == diff(a[1], b[1]):
    let xs = (if a[0] < b[0]: (a[0]..b[0]).toSeq else: (b[0]..a[0]).toSeq.reversed)
    let ys = (if a[1] < b[1]: (a[1]..b[1]).toSeq else: (b[1]..a[1]).toSeq.reversed)

    zip(xs, ys)
  else:
    rook_iterator(point_pair)

proc solve1(point_pairs: seq[PointPair]): int =
  var board_map = initCountTable[Point]()

  for point_pair in point_pairs:
    for point in rook_iterator(point_pair):
      board_map.inc(point)

  board_map.values().toSeq.foldl(a + (if b > 1: 1 else: 0), 0)

proc solve2(point_pairs: seq[PointPair]): int =
  var board_map = initCountTable[Point]()

  for point_pair in point_pairs:
    for point in queen_iterator(point_pair):
      board_map.inc(point)

  board_map.values().toSeq.foldl(a + (if b > 1: 1 else: 0), 0)


let filename = "./input"
let data = read_input(filename)

echo solve1(data)
echo solve2(data)
