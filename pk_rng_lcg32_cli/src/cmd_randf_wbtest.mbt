///|
test "cli: randf" {
  assert_true(run_cli(["randf", "00006073"]).has_prefix("0.91"))
}

///|
test "cli: randf - error cases" {
  // invalid seed format
  assert_eq(run_cli(["randf", "invalid"]), "Invalid seed format: \"invalid\"")
  // seed out of range
  assert_eq(
    run_cli(["randf", "123456789"]),
    "Seed value out of range: \"123456789\"",
  )
}
