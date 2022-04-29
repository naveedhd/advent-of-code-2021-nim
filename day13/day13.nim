import sets
import strutils
import sugar

type
  XY = tuple[x, y: uint]
  Paper = HashSet[XY]
  PaperBounds = XY
  FoldInstructions = seq[XY]


proc parse_paper_str(paper_str: string): (Paper, PaperBounds) =
  for line in paper_str.splitLines:
    let split = line.split(",")

    let x = split[0].parseUInt
    let y = split[1].parseUInt
    let p = (x, y)

    result[0].incl(p)

    result[1].x = max(result[1].x, x)
    result[1].y = max(result[1].y, y)


proc parse_fold_str(fold_str: string): FoldInstructions =
  collect:
    for line in fold_str.splitLines:
      if line.isEmptyOrWhitespace:
        continue
      let fold_val = line.split("=")[1].parseUInt
      if line.startsWith("fold along y="):
        (x: 0u, y: fold_val)
      else:
        (x: fold_val, y: 0u)


proc read_input(filename: string): (Paper, PaperBounds, FoldInstructions) =
  var paper_fold_split = filename.readFile.split("\n\n")

  let paper_str = paper_fold_split[0]
  let fold_str = paper_fold_split[1]

  let (paper, paper_bounds) = parse_paper_str(paper_str)
  let fold_instructions = parse_fold_str(fold_str)

  (paper, paper_bounds, fold_instructions)


proc fold_once(paper: Paper, paper_bounds: PaperBounds, fold_instruction: XY): (Paper, PaperBounds) =
  let fold_horizontally = fold_instruction.x > 0

  for mark in paper:
    if fold_horizontally:
      if mark.x > fold_instruction.x:
        result[0].incl((paper_bounds.x - mark.x, mark.y))
      else:
        result[0].incl(mark)
    else:
      if mark.y > fold_instruction.y:
        result[0].incl((mark.x, paper_bounds.y - mark.y))
      else:
        result[0].incl(mark)

  result[1] = (if fold_horizontally: (fold_instruction.x - 1, paper_bounds.y) else: (paper_bounds.x, fold_instruction.y - 1))


proc solve1(paper: Paper, paper_bounds: PaperBounds, fold_instructions: FoldInstructions): (Paper, PaperBounds) =
  fold_once(paper, paper_bounds, fold_instructions[0])


proc solve2(paper: Paper, paper_bounds: PaperBounds, fold_instructions: FoldInstructions): (Paper, PaperBounds) =
  result[0] = paper
  result[1] = paper_bounds
  for idx in fold_instructions.low+1 .. fold_instructions.high:
    let fold_instruction = fold_instructions[idx]
    result = fold_once(result[0], result[1], fold_instruction)


proc print_paper(paper: Paper, paper_bounds: PaperBounds) =
  for y in 0 .. paper_bounds.y:
    for x in 0 .. paper_bounds.x:
      write(stdout, (if paper.contains((uint(x), uint(y))): "#" else: " "))
    echo ""



let filename = "./input"
let (paper, paper_bounds, fold_instructions) = read_input(filename)

let (first_fold_paper, first_fold_paper_bounds) = solve1(paper, paper_bounds, fold_instructions)
echo first_fold_paper.len

let (final_paper, final_paper_bounds) = solve2(first_fold_paper, first_fold_paper_bounds, fold_instructions)

print_paper(final_paper, final_paper_bounds)
