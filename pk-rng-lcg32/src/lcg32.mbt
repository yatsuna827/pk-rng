///|
pub(all) struct Lcg32(UInt) derive(Eq, Show)

///|
pub fn Lcg32::next(self : Lcg32) -> Lcg32 {
  self.0 * mut_const + add_const
}

///|
pub fn Lcg32::prev(self : Lcg32) -> Lcg32 {
  self.0 * rev_mul_const + rev_add_const
}

///|
pub fn Lcg32::jump(self : Lcg32, n : UInt) -> Lcg32 {
  let mut seed = self.0
  let { a_t, b_t, .. } = cache.val.unwrap_or_else(setup)
  let mut i = 0
  let mut n = n
  while n > 0 {
    if (n & 1) == 1 {
      seed = seed * a_t[i] + b_t[i]
    }
    i = i + 1
    n = n >> 1
  }
  seed
}

///|
pub fn Lcg32::jump_back(self : Lcg32, n : UInt) -> Lcg32 {
  let mut seed = self.0
  let { ar_t, br_t, .. } = cache.val.unwrap_or_else(setup)
  let mut i = 0
  let mut n = n
  while n > 0 {
    if (n & 1) == 1 {
      seed = seed * ar_t[i] + br_t[i]
    }
    i = i + 1
    n = n >> 1
  }
  seed
}

///|
pub fn Lcg32::iter(self : Lcg32) -> Iter[Lcg32] {
  let lcg = self.to_ref()
  Iterator::new(() => {
    let result = lcg.val
    lcg.advance()
    Some(result)
  }).iter()
}

///|
pub impl Show for Lcg32 with to_string(self : Lcg32) -> String {
  self.0.to_string(radix=16).to_upper().pad_start(8, '0')
}

///|
test "lcg32 string" {
  inspect(Lcg32(0).to_string(), content="00000000")
  inspect(Lcg32(0xFFFFFFFF).to_string(), content="FFFFFFFF")
  inspect(Lcg32(0xCAFFEE).to_string(), content="00CAFFEE")
}

///|
fn get_index_from_zero(seed : UInt) -> UInt {
  let mut a = mut_const
  let mut b = add_const
  let mut result : UInt = 0
  let mut seed = seed * a + b
  let mut mask : UInt = 1
  for i = 0; i < 32; i = i + 1 {
    if (seed & mask) == 0 {
      result = result | mask
    } else {
      seed = seed * a + b
    }
    b = (a + 1) * b
    a = a * a
    mask = mask << 1
  }
  result
}

///|
fn get_index_from_base(seed : UInt, from : UInt) -> UInt {
  let mut a = mut_const
  let mut b = add_const
  let mut result : UInt = 0
  let mut seed = seed * a + b
  let mut mask : UInt = 1
  for i = 0; i < 32; i = i + 1 {
    if ((seed ^ from) & mask) == 0 {
      result = result | mask
    } else {
      seed = seed * a + b
    }
    b = (a + 1) * b
    a = a * a
    mask = mask << 1
  }
  result
}

///|
pub fn Lcg32::get_index(self : Lcg32, from? : UInt = 0) -> UInt {
  if from == 0 {
    get_index_from_zero(self.0)
  } else {
    get_index_from_base(self.0, from)
  }
}

///|
test "jump" {
  let lcg = Lcg32(0x08270827)
  assert_eq(lcg.next().next().next().0, lcg.jump(3).0)
  assert_eq(lcg.prev().prev().prev().0, lcg.jump_back(3).0)
}

///|
test "prev" {
  let lcg = Lcg32(0xBEEFFACE)
  assert_eq(lcg.next().prev().0, lcg.0)
  assert_eq(lcg.prev().next().0, lcg.0)
}
