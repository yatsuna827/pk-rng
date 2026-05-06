///|
fn command_list(
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

    let res_n = (try? ctx.get_int_required("N"))
      .map_err(extract_err_msg)
      .map(n => {
        guard n >= 0 else { Err("n must be a positive integer") }

        Ok(n.reinterpret_as_uint())
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

    let separator = ctx.get_string("separator").unwrap_or("\n")

    output(@lib.cmd_list(seed, n, prefix~, separator~))
  }

  @admiral.command(
    name="list",
    description="List consecutive seeds",
    positionals=[
      @admiral.positional(
        "SEED",
        description="Starting seed (hex)",
        required=true,
      ),
      @admiral.positional(
        "N",
        description="Number of seeds to list",
        required=true,
      ),
    ],
    options=[
      @admiral.bool("prefix", short='p', description="Add 0x prefix to output"),
      @admiral.string(
        "separator",
        short='s',
        description="Separator between seeds",
        default=Some("\n"),
      ),
    ],
    examples=[
      "lcg32 list 00000000 5", "lcg32 list 00000000 5 --separator \",\"", "lcg32 list 00000000 3 -p",
    ],
    run=Some(run),
  )
}
