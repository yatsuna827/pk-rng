///|
pub fn cmd_next(seed : UInt, n : Int, prefix? : Bool = false) -> String {
  let lcg = @lcg32.Lcg32(seed)
  let result = if n >= 0 {
    lcg.next(n=n.reinterpret_as_uint())
  } else {
    lcg.prev(n=(-n).reinterpret_as_uint())
  }
  format_seed(result.0, prefix~)
}

///|
test "cmd_next: positive n" {
  assert_eq(cmd_next(0x00000000, 1), "00006073")
  assert_eq(cmd_next(0x00000000, 3), "52713895")
  assert_eq(cmd_next(0xDEADBEEF, 1), "1C017E36")
}

///|
test "cmd_next: negative n" {
  assert_eq(cmd_next(0xE97E7B6A, -3), "0A3561A1")
  assert_eq(cmd_next(0x00006073, -1), "00000000")
}

///|
test "cmd_next: with prefix" {
  assert_eq(cmd_next(0x00000000, 1, prefix=true), "0x00006073")
}

///|
test "cmd_next: zero n" {
  assert_eq(cmd_next(0xDEADBEEF, 0), "DEADBEEF")
}

///|
pub fn cmd_prev(seed : UInt, n : Int, prefix? : Bool = false) -> String {
  let lcg = @lcg32.Lcg32(seed)
  let result = if n >= 0 {
    lcg.prev(n=n.reinterpret_as_uint())
  } else {
    lcg.next(n=(-n).reinterpret_as_uint())
  }
  format_seed(result.0, prefix~)
}

///|
test "cmd_prev: positive n" {
  assert_eq(cmd_prev(0xE97E7B6A, 3), "0A3561A1")
  assert_eq(cmd_prev(0x00006073, 1), "00000000")
}

///|
test "cmd_prev: negative n" {
  assert_eq(cmd_prev(0x00000000, -1), "00006073")
  assert_eq(cmd_prev(0x0A3561A1, -3), "E97E7B6A")
}

///|
test "cmd_prev: zero n" {
  assert_eq(cmd_prev(0xDEADBEEF, 0), "DEADBEEF")
}

///|
test "cmd_prev: with prefix" {
  assert_eq(cmd_prev(0xE97E7B6A, 3, prefix=true), "0x0A3561A1")
}

///|
pub fn cmd_index(seed : UInt, from : UInt) -> String {
  let lcg = @lcg32.Lcg32(seed)
  lcg.get_index(from~).to_string()
}

///|
test "cmd_index: from zero" {
  assert_eq(cmd_index(0xE97E7B6A, 0), "2")
  assert_eq(cmd_index(0x00006073, 0), "1")
  assert_eq(cmd_index(0x00000000, 0), "0")
}

///|
test "cmd_index: from custom base" {
  assert_eq(cmd_index(0x00006073, 0x00006073), "0")
  assert_eq(cmd_index(0xE97E7B6A, 0x00006073), "1")
}

///|
pub fn cmd_list(
  seed : UInt,
  n : UInt,
  prefix? : Bool = false,
  separator? : String = "\n",
) -> String {
  let lcg = @lcg32.Lcg32(seed)
  lcg
  .iter()
  .take(n.reinterpret_as_int())
  .map(s => format_seed(s.0, prefix~))
  .collect()
  .join(separator)
}

///|
test "cmd_list: basic" {
  assert_eq(
    cmd_list(0x00000000, 5),
    "00000000\n00006073\nE97E7B6A\n52713895\n31B0DDE4",
  )
}

///|
test "cmd_list: with separator" {
  assert_eq(
    cmd_list(0x00000000, 5, separator=","),
    "00000000,00006073,E97E7B6A,52713895,31B0DDE4",
  )
}

///|
test "cmd_list: with prefix" {
  assert_eq(
    cmd_list(0x00000000, 3, prefix=true),
    "0x00000000\n0x00006073\n0xE97E7B6A",
  )
}

///|
test "cmd_list: n 1" {
  assert_eq(cmd_list(0xDEADBEEF, 1), "DEADBEEF")
}

///|
pub fn cmd_rand(
  seed : UInt,
  modulo? : UInt? = None,
  hex? : Bool = false,
) -> String {
  let lcg = @lcg32.Lcg32(seed).to_ref()
  let result = match modulo {
    Some(m) => lcg.get_rand(m~)
    None => lcg.get_rand()
  }
  if hex {
    result.to_string(radix=16).to_upper().pad_start(4, '0')
  } else {
    result.to_string()
  }
}

///|
test "cmd_rand: basic" {
  assert_eq(cmd_rand(0x00000000), "0")
  assert_eq(cmd_rand(0x00006073), "59774")
}

///|
test "cmd_rand: with modulo" {
  assert_eq(cmd_rand(0x00006073, modulo=Some(100)), "74")
}

///|
test "cmd_rand: hex output" {
  assert_eq(cmd_rand(0x00000000, hex=true), "0000")
  assert_eq(cmd_rand(0x00006073, hex=true), "E97E")
}

///|
pub fn cmd_randf(seed : UInt) -> String {
  let lcg = @lcg32.Lcg32(seed).to_ref()
  lcg.get_rand_f().to_string()
}

///|
test "cmd_randf: basic" {
  assert_eq(cmd_randf(0x00000000), "0")
  assert_true(cmd_randf(0x00006073).has_prefix("0.91"))
}
