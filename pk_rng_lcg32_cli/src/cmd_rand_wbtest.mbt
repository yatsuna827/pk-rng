///|
test "cli: rand" {
  assert_eq(run_cli(["rand", "00006073"]), "59774")
  assert_eq(run_cli(["rand", "00006073", "-m", "100"]), "74")
  assert_eq(run_cli(["rand", "00006073", "-x"]), "E97E")
}

///|
test "cli: rand - error cases" {
  // invalid seed format
  assert_eq(run_cli(["rand", "invalid"]), "Invalid seed format: \"invalid\"")
  // seed out of range
  assert_eq(
    run_cli(["rand", "123456789"]),
    "Seed value out of range: \"123456789\"",
  )
  // negative mod
  assert_eq(
    run_cli(["rand", "00000000", "-m=-1"]),
    "mod must be a positive integer",
  )
}
