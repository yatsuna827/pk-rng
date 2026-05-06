///|
test "cli: prev" {
  assert_eq(run_cli(["prev", "00006073", "1"]), "00000000")
  assert_eq(run_cli(["prev", "00006073", "1", "-p"]), "0x00000000")
  assert_eq(run_cli(["prev", "00006073", "-1"]), "E97E7B6A")
}

///|
test "cli: prev - error cases" {
  // invalid seed format
  assert_eq(
    run_cli(["prev", "invalid", "1"]),
    "Invalid seed format: \"invalid\"",
  )
  // seed out of range
  assert_eq(
    run_cli(["prev", "123456789", "1"]),
    "Seed value out of range: \"123456789\"",
  )
  // invalid n
  assert_eq(run_cli(["prev", "00000000", "abc"]), "Invalid n: \"abc\"")
}
