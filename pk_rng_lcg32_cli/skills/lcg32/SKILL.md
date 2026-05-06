---
name: lcg32
description: ポケモン第3世代のLCG（線形合同法）乱数計算を行うCLI。seed値の進め・戻し、インデックス計算、乱数列挙、乱数値計算などを実行できる。ポケモンのseed計算、乱数調整、RNG、Pokemon Gen 3の乱数シミュレーションに関する質問や作業では必ずこのスキルを使用すること。
---

# lcg32 CLI

ポケモン第3世代の疑似乱数アルゴリズム（LCG: Linear Congruential Generator）の計算を行うCLIツール。

## インストール確認

`lcg32` コマンドが使えるか確認する。使えない場合は、ユーザーにインストールを促す。

## seed値の入力形式

16進数（hex）形式で指定する。以下の形式をすべて受け付ける：

- `DEADBEEF`（プレフィックスなし）
- `deadbeef`（小文字）
- `0xDEADBEEF`（0xプレフィックス付き）

## サブコマンド

### next - seed値を進める

```bash
lcg32 next <SEED> <N> [--prefix|-p]
```

- `SEED`: 進める対象のseed値（hex）
- `N`: 進める回数（負の値で戻る）
- `--prefix`, `-p`: 出力に0xプレフィックスを付ける

```bash
lcg32 next 00000000 3
# => 52713895

lcg32 next E97E7B6A -3 --prefix
# => 0x0A3561A1
```

### prev - seed値を戻す

```bash
lcg32 prev <SEED> <N> [--prefix|-p]
```

- `SEED`: 戻す対象のseed値（hex）
- `N`: 戻す回数

```bash
lcg32 prev E97E7B6A 3
# => 0A3561A1
```

### index - seed値のインデックスを計算

seed値が基準seedから何番目かを計算する。

```bash
lcg32 index <SEED> [--from|-f <BASE_SEED>]
```

- `SEED`: 計算対象のseed値（hex）
- `--from`, `-f`: 基準となるseed値（デフォルト: 00000000）

```bash
lcg32 index E97E7B6A
# => 2

lcg32 index DEADBEEF --from 12345678
# => 98765432
```

### list - 連続したseedを列挙

```bash
lcg32 list <SEED> <N> [--prefix|-p] [--separator|-s <SEP>]
```

- `SEED`: 開始seed値（hex）
- `N`: 出力する件数
- `--separator`, `-s`: 区切り文字（デフォルト: 改行）

```bash
lcg32 list 00000000 5
# => 00000000
#    00006073
#    E97E7B6A
#    52713895
#    31B0DDE4

lcg32 list 00000000 5 --separator ","
# => 00000000,00006073,E97E7B6A,52713895,31B0DDE4
```

### rand - 乱数値（上位16ビット）を計算

seed値を1つ進めた値から乱数値を計算する。

```bash
lcg32 rand <SEED> [--mod|-m <M>] [--hex|-x]
```

- `SEED`: 計算対象のseed値（hex）
- `--mod`, `-m`: 剰余を取る値
- `--hex`, `-x`: 出力を16進数にする

```bash
lcg32 rand 00006073
# => 59774

lcg32 rand 00006073 --mod 100
# => 74

lcg32 rand 00006073 --hex
# => E97E
```

### randf - 浮動小数点乱数を計算

seed値を1つ進めた値から0.0〜1.0の浮動小数点乱数を計算する。

```bash
lcg32 randf <SEED>
```

```bash
lcg32 randf 00006073
# => 0.91...
```

## よくあるユースケース

### seed値からN番目の乱数値を取得

```bash
lcg32 next <SEED> <N-1>
# 出力されたseedに対して
lcg32 rand <出力されたSEED>
```

### 初期seedの乱数列を確認

```bash
lcg32 list 00000000 10
```

### 特定のseedが何番目か調べる

```bash
lcg32 index <TARGET_SEED>
```
