///|
fn command_prev(
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

    let res_n = (try? ctx.get_string_required("N"))
      .map_err(extract_err_msg)
      .map(n_str => {
        (try? @string.parse_int(n_str)).map_err(_ => "Invalid n: \"\{n_str}\"")
      })
      .flatten()
    let n = match res_n {
      Ok(n) => n
      Err(e) => {
        error(e)
        return
      }
    }

    let prefix = ctx.get_bool("prefix")
    output(@lib.cmd_prev(seed, n, prefix~))
  }

  @admiral.command(
    name="prev",
    description="Go back seed by specified n",
    positionals=[
      @admiral.positional("SEED", description="Seed value (hex)", required=true),
      @admiral.positional(
        "N",
        description="Number of steps (negative to go forward)",
        required=true,
      ),
    ],
    options=[
      @admiral.bool("prefix", short='p', description="Add 0x prefix to output"),
    ],
    examples=[
      "lcg32 prev E97E7B6A 3", "lcg32 prev DEADBEEF -10", "lcg32 prev 0xDEADBEEF 100 --prefix",
    ],
    run=Some(run),
  )
}
