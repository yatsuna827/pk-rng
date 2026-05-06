///|
fn command_rand(
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

    let res_modulo = match ctx.get_int("mod") {
      None => Ok(None)
      Some(m) =>
        if m >= 0 {
          Ok(Some(m.reinterpret_as_uint()))
        } else {
          Err("mod must be a positive integer")
        }
    }
    let modulo = match res_modulo {
      Ok(m) => m
      Err(e) => {
        error(e)
        return
      }
    }

    let hex = ctx.get_bool("hex")

    output(@lib.cmd_rand(seed, modulo~, hex~))
  }

  @admiral.command(
    name="rand",
    description="Calculate random value (upper 16 bits of next seed)",
    positionals=[
      @admiral.positional("SEED", description="Seed value (hex)", required=true),
    ],
    options=[
      @admiral.int("mod", short='m', description="Modulo value"),
      @admiral.bool("hex", short='x', description="Output in hexadecimal"),
    ],
    examples=[
      "lcg32 rand 00000000", "lcg32 rand 00000000 --mod 100", "lcg32 rand 00000000 --hex",
      "lcg32 rand 00000000 -m 256 -x",
    ],
    run=Some(run),
  )
}
