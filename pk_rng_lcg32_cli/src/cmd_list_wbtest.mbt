///|
test "cli: list" {
  assert_eq(run_cli(["list", "00000000", "3"]), "00000000\n00006073\nE97E7B6A")
  assert_eq(
    run_cli(["list", "00000000", "3", "-s", ","]),
    "00000000,00006073,E97E7B6A",
  )
  assert_eq(
    run_cli(["list", "00000000", "3", "-p"]),
    "0x00000000\n0x00006073\n0xE97E7B6A",
  )
}

///|
test "cli: list - error cases" {
  // invalid seed format
  assert_eq(
    run_cli(["list", "invalid", "3"]),
    "Invalid seed format: \"invalid\"",
  )
  // seed out of range
  assert_eq(
    run_cli(["list", "123456789", "3"]),
    "Seed value out of range: \"123456789\"",
  )
  // negative n
  assert_eq(run_cli(["list", "00000000", "-1"]), "n must be a positive integer")
}
