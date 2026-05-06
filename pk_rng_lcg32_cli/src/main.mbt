///|
async fn main {
  let error_buf : Array[String] = []
  let app = create_app(output=s => println(s), error=s => error_buf.push(s))
  app.run() catch {
    err => error_buf.push(err.to_string())
  }
  for msg in error_buf {
    @stdio.stderr.write(msg)
    @stdio.stderr.write("\n")
  }
}

///|
fn create_app(
  output~ : (String) -> Unit,
  error~ : (String) -> Unit,
) -> @admiral.CliApp {
  @admiral.cli(
    name="lcg32",
    version="0.1.0",
    description="LCG32 seed calculator for Pokemon Gen 3 RNG",
    commands=[
      command_next(output~, error~),
      command_prev(output~, error~),
      command_index(output~, error~),
      command_list(output~, error~),
      command_rand(output~, error~),
      command_randf(output~, error~),
    ],
  )
}
