///|
pub fn parse_seed(input : String) -> Result[UInt, String] {
  let s = if input.has_prefix("0x") || input.has_prefix("0X") {
    input[2:]
  } else {
    input[:]
  }

  guard !s.is_empty() else { return Err("Invalid seed format: \"\{input}\"") }
  guard s.length() <= 8 else {
    return Err("Seed value out of range: \"\{input}\"")
  }

  Ok(@string.parse_uint(s, base=16)) catch {
    _ => Err("Invalid seed format: \"\{input}\"")
  }
}

///|
test "parse_seed: hex without prefix" {
  assert_eq(parse_seed("DEADBEEF"), Ok(0xDEADBEEF))
  assert_eq(parse_seed("deadbeef"), Ok(0xDEADBEEF))
  assert_eq(parse_seed("00000000"), Ok(0x00000000))
  assert_eq(parse_seed("FFFFFFFF"), Ok(0xFFFFFFFF))
  assert_eq(parse_seed("1"), Ok(0x1))
  assert_eq(parse_seed("CAFFEE"), Ok(0xCAFFEE))
}

///|
test "parse_seed: hex with 0x prefix" {
  assert_eq(parse_seed("0xDEADBEEF"), Ok(0xDEADBEEF))
  assert_eq(parse_seed("0xdeadbeef"), Ok(0xDEADBEEF))
  assert_eq(parse_seed("0X00000000"), Ok(0x00000000))
  assert_eq(parse_seed("0xFFFFFFFF"), Ok(0xFFFFFFFF))
}

///|
test "parse_seed: invalid format" {
  assert_true(parse_seed("xyz") is Err(_))
  assert_true(parse_seed("0xGGGG") is Err(_))
  assert_true(parse_seed("") is Err(_))
  assert_true(parse_seed("0x") is Err(_))
}

///|
test "parse_seed: out of range" {
  assert_true(parse_seed("123456789") is Err(_))
  assert_true(parse_seed("0x123456789") is Err(_))
}

///|
pub fn format_seed(seed : UInt, prefix? : Bool = false) -> String {
  let hex = seed.to_string(radix=16).to_upper().pad_start(8, '0')
  if prefix {
    "0x" + hex
  } else {
    hex
  }
}

///|
test "format_seed: without prefix" {
  assert_eq(format_seed(0xDEADBEEF), "DEADBEEF")
  assert_eq(format_seed(0x00000000), "00000000")
  assert_eq(format_seed(0xFFFFFFFF), "FFFFFFFF")
  assert_eq(format_seed(0x00CAFFEE), "00CAFFEE")
}

///|
test "format_seed: with prefix" {
  assert_eq(format_seed(0xDEADBEEF, prefix=true), "0xDEADBEEF")
  assert_eq(format_seed(0x00000000, prefix=true), "0x00000000")
  assert_eq(format_seed(0xFFFFFFFF, prefix=true), "0xFFFFFFFF")
}
