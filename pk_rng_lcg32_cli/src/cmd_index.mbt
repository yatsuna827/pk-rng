///|
fn command_index(
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

    let res_from = ctx
      .get_string("from")
      .map(from_str => @lib.parse_seed(from_str))
      .unwrap_or(Ok(0))
    let from = match res_from {
      Ok(from) => from
      Err(e) => {
        error(e)
        return
      }
    }

    output(@lib.cmd_index(seed, from))
  }

  @admiral.command(
    name="index",
    description="Calculate the index of seed from a base seed",
    positionals=[
      @admiral.positional("SEED", description="Seed value (hex)", required=true),
    ],
    options=[
      @admiral.string(
        "from",
        short='f',
        description="Base seed (hex)",
        default=Some("00000000"),
      ),
    ],
    examples=["lcg32 index E97E7B6A", "lcg32 index DEADBEEF --from 12345678"],
    run=Some(run),
  )
}
