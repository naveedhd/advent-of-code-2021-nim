import strutils
import sequtils
import sugar


type
  Inputs = seq[int]
  BoardValue = (int, bool)
  Board = seq[BoardValue]
  Boards = seq[Board]


proc read_input(filename: string): (Inputs, Boards) =
  let inputs_board_split = filename.readFile.split('\n', 1)

  let inputs_str = inputs_board_split[0]
  let boards_str = inputs_board_split[1]

  let inputs = inputs_str.split(',').map(parseInt)

  let boards = boards_str
                .split("\n\n")
                .map(board_str => (board_str.splitWhitespace.map(s => (parseInt(s), false))))

  (inputs, boards)


proc check_board(board: Board, pos: int): bool =
  let col = pos div 5
  let row_start = col * 5
  let row_end = row_start + 4

  let row_vals = board[row_start..row_end]

  let row = pos mod 5
  let col_vals = collect:
    for i in countup(row, len(board)-1, 5):
      board[i]

  row_vals.all(x => x[1]) or col_vals.all(x => x[1])


proc mark_board(board: var Board, input: int): bool =
  let find_idx = board.find((input, false))

  if find_idx != -1:
    board[find_idx][1] = true
    check_board(board, find_idx)
  else:
    false

proc board_score(board: Board): int =
  board
    .filter(board_val => not board_val[1])
    .map(board_val => board_val[0])
    .foldl(a + b, 0)


proc solve1(inputs: Inputs, boards: Boards): int =
  var solution_boards = boards

  for input in inputs:
    for board in solution_boards.mitems:
      if mark_board(board, input):
        return input * board_score(board)

proc solve2(inputs: Inputs, boards: Boards): int =
  var last_score = 0

  var solution_boards = boards
  var boards_done = newSeq[bool](boards.len)

  for input in inputs:
    for i, board in solution_boards.mpairs:
      if boards_done[i]: continue

      if mark_board(board, input):
        last_score = input * board_score(board)
        boards_done[i] = true

  last_score


let filename = "./input"
let (inputs, boards) = read_input(filename)

echo solve1(inputs, boards)
echo solve2(inputs, boards)
