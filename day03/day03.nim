import sequtils
import strutils
import sugar


proc read_input(filename: string): seq[string] =
  filename.lines.toSeq


proc most_common_bits(bits_vector: seq[string]): string =
  let bits_length = bits_vector[0].len
  var zero_counts = newSeq[int](bits_length)

  for bits in bits_vector:
    for i, c in bits:
      if c == '0': inc zero_counts[i]

  let num_bits = bits_vector.len
  # zero_counts.map(zero_count => (if num_bits - zero_count  < zero_count: '0' else: '1')).toSeq

  zero_counts.foldl(a & (if num_bits - b  < b: '0' else: '1'), "")

proc solve1(bits_vector: seq[string]): int =
  let mcbs = most_common_bits(bits_vector)
  let lcbs = mcbs.foldl(a & (if b == '0': '1' else: '0'), "")

  let num = mcbs.parseBinInt
  let inverted_num = lcbs.parseBinInt

  num * inverted_num


proc most_common_bit(bits_vector: seq[string], place: int): char =
  let zero_count = bits_vector.filter(bits => bits[place] == '0').len

  let bits_count = bits_vector.len
  let ones_count = bits_count - zero_count;

  if zero_count > ones_count: '0' else: '1'


proc least_common_bit(bits_vector: seq[string], place: int): char =
  let zero_count = bits_vector.filter(bits => bits[place] == '0').len

  let bits_count = bits_vector.len
  let ones_count = bits_count - zero_count;

  if ones_count < zero_count: '1' else: '0'


proc solve2(bits_vector: seq[string]): int =

  let bits_len = bits_vector[0].len

  var oxygen_level = 0
  var filtered = bits_vector
  for bit_place in 0 ..< bits_len:
    let mcb = most_common_bit(filtered, bit_place)

    filtered = filtered.filter(bits => bits[bit_place] == mcb).toSeq

    if filtered.len == 1:
      oxygen_level = filtered[0].parseBinInt
      break

  var carbon_level = 0
  var filtered2 = bits_vector
  for bit_place in 0 ..< bits_len:
    let lcb = least_common_bit(filtered2, bit_place)

    filtered2 = filtered2.filter(bits => bits[bit_place] == lcb).toSeq

    if filtered2.len == 1:
      carbon_level = filtered2[0].parseBinInt
      break

  oxygen_level * carbon_level


let filename = "./input"
let vals = read_input(filename)

echo solve1(vals)
echo solve2(vals)
