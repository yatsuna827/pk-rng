///|
priv struct Booster {
  a_t : FixedArray[UInt]
  b_t : FixedArray[UInt]
  ar_t : FixedArray[UInt]
  br_t : FixedArray[UInt]
}

///|
let cache : Ref[Booster?] = Ref::new(None)

///|
fn setup() -> Booster {
  let a_t = FixedArray::make(32, 0U)
  let b_t = FixedArray::make(32, 0U)
  let ar_t = FixedArray::make(32, 0U)
  let br_t = FixedArray::make(32, 0U)
  a_t[0] = mut_const
  b_t[0] = add_const
  ar_t[0] = rev_mul_const
  br_t[0] = rev_add_const
  for i = 1; i < 32; i = i + 1 {
    a_t[i] = a_t[i - 1] * a_t[i - 1]
    b_t[i] = b_t[i - 1] * (1U + a_t[i - 1])
    ar_t[i] = ar_t[i - 1] * ar_t[i - 1]
    br_t[i] = br_t[i - 1] * (1U + ar_t[i - 1])
  }
  let booster = { a_t, b_t, ar_t, br_t }
  cache.val = Some(booster)
  booster
}
