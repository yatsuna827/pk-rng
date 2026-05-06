///|
fn command_randf(
  output~ : (String) -> Unit,
  error~ : (String) -> Unit,
) -> @admiral.CommandDef {
  fn run(ctx : @admiral.Context) -> Unit {
    let res_seed = (try? ctx.get_string_required("SEED"))
      .map_err(extract_err_msg)
      .map(seed_str => @lib.parse_seed(seed_str))
      .flatten()
    let seed = match res_seed {
      Ok(seed) => seed
      Err(e) => {
        error(e)
        return
      }
    }

    output(@lib.cmd_randf(seed))
  }

  @admiral.command(
    name="randf",
    description="Calculate random float value (0.0 to 1.0)",
    positionals=[
      @admiral.positional("SEED", description="Seed value (hex)", required=true),
    ],
    examples=["lcg32 randf 00000000"],
    run=Some(run),
  )
}
