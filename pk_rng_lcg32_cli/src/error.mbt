///|
fn extract_err_msg(e : Error) -> String {
  match e {
    Failure::Failure(msg) =>
      msg.after("FAILED: ").map(StringView::to_owned).unwrap_or(msg)
    _ => return e.to_string()
  }
}
