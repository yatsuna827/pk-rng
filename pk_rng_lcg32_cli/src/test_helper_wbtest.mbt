///|
fn run_cli(argv : Array[String]) -> String {
  let result = Ref::new("")
  let app = create_app(output=s => result.val = s, error=s => result.val = s)
  app.run(argv=Some(argv)) catch {
    err => result.val = err.to_string()
  }
  result.val
}
