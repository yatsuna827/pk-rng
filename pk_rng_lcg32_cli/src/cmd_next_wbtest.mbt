///|
test "cli: next" {
  assert_eq(run_cli(["next", "00000000", "1"]), "00006073")
  assert_eq(run_cli(["next", "00000000", "3"]), "52713895")
  assert_eq(run_cli(["next", "00000000", "1", "-p"]), "0x00006073")
  assert_eq(run_cli(["next", "00006073", "-1"]), "00000000")
}

///|
test "cli: next - error cases" {
  // invalid seed format
  assert_eq(
    run_cli(["next", "invalid", "1"]),
    "Invalid seed format: \"invalid\"",
  )
  // seed out of range
  assert_eq(
    run_cli(["next", "123456789", "1"]),
    "Seed value out of range: \"123456789\"",
  )
  // invalid n
  assert_eq(run_cli(["next", "00000000", "abc"]), "Invalid n: \"abc\"")
}
