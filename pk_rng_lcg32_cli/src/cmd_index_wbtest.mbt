///|
test "cli: index" {
  assert_eq(run_cli(["index", "E97E7B6A"]), "2")
  assert_eq(run_cli(["index", "00006073"]), "1")
  assert_eq(run_cli(["index", "E97E7B6A", "--from", "00006073"]), "1")
}

///|
test "cli: index - error cases" {
  // invalid seed format
  assert_eq(run_cli(["index", "invalid"]), "Invalid seed format: \"invalid\"")
  // seed out of range
  assert_eq(
    run_cli(["index", "123456789"]),
    "Seed value out of range: \"123456789\"",
  )
  // invalid from
  assert_eq(
    run_cli(["index", "00006073", "--from", "invalid"]),
    "Invalid seed format: \"invalid\"",
  )
}
