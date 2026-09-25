# Lisp interpreter on iPhone 5s

**Original interpreter**: Gregory J. Chaitin
**Status**: experimental proof of concept
**Related to**: [neuromuse](https://github.com/FredVoisin/neuromuse)
**License**: [PolyForm Noncommercial 1.0.0](../LICENSE)

---

## Overview

This section documents the native compilation and use of `lisp.c`, the small
Lisp interpreter written in K&R-style C by **Gregory J. Chaitin**, on a
jailbroken iPhone 5s.

Within neuromuse (neural learning + music, iOS music tools, musical research,
audio later), `lisp.c` is used as an **experimental control layer**. The
target proof of concept: a simple perceptron, written in Lisp, whose decisions
trigger the playback of WAV files, possibly through an external script.

### About lisp.c — original code by Gregory J. Chaitin

The original code of `lisp.c` is the work of **Gregory J. Chaitin**. All
credit for the interpreter goes to him; neuromuse only adds the modifications
listed in `neuromuse.patch` (see below).

`lisp.c` is the C version of the Lisp interpreter written by Gregory J. Chaitin
for his work on algorithmic information theory, closely tied to the lambda
calculus tradition of Lisp. It is described in *The Limits of Mathematics —
Tutorial Version* (arXiv:chao-dyn/9509010):
<https://arxiv.org/abs/chao-dyn/9509010>

Characteristics of this dialect worth knowing before reading the code:

- programs are written as M-expressions (implicit parentheses for primitives),
  with `"` introducing an explicit S-expression;
- primitives have a fixed number of arguments: `'` (quote), `=` (eq), `atom`,
  `car`, `cdr`, `cons`, `lambda`, `define`, `let`, `if`, `display`, `eval`…;
- comments are written `[like this]`;
- numbers are **unsigned integers** of arbitrary size — no floats, no negative
  numbers in the original (see the neuromuse extension below);
- `define x ...` stores its value **unevaluated**: data is written without
  quote, and computed values are passed through `let` or function calls.

The version used here is a **modified `lisp.c`** — see
[neuromuse extensions](#neuromuse-extensions-to-lispc).

---

## Environment

| Item       | Value                                  |
|------------|----------------------------------------|
| Device     | Apple iPhone 5s (`iPhone6,2`, N53AP, arm64) |
| iOS        | 12.5.x (Darwin 18.7.0, xnu-4903.272.5) |
| Toolchain  | Theos, iPhoneOS16.5 SDK, clang, ldid   |

---

## neuromuse extensions to lisp.c

[`chaitin-lisp/neuromuse.patch`](../chaitin-lisp/neuromuse.patch) applies to the original `lisp.c`
(the [Makefile](../chaitin-lisp/Makefile) does it for you):

```sh
cd chaitin-lisp
cp /path/to/chaitin/lisp.c lisp.orig.c
make
```

It adds:

- **`load file`** — reads input from a file, from the REPL (also accepted as
  `(load file)`); loads can be nested. File names cannot contain spaces or
  parentheses.
- **Floating-point numbers** (C `double`): literals such as `0.5`, `-2`,
  `1e-3`; `+ - * ^ < > <= >= =` switch to floating point as soon as one
  argument is a float.
- **New primitives**: `/`, `exp`, `log`, `sqrt`, `floor`, `float`,
  `random` (uniform in [0,1)), `seed n` (reproducible random series).
- Fixes for compiler warnings in the original code (braces around a dangling
  `else`, final `return` in `compare`). Behaviour unchanged.

Chaitin's arbitrary-precision integers are unchanged. Tested with
[`examples/float-test.l`](../examples/float-test.l) on the iPhone 5s.

### Pitfalls

- **Integer subtraction still floors at zero**: `- 1 4` gives `0`, not `-3`.
  Any signed computation needs at least one float operand: write data and
  weights as floats (`1.0`, `0.0`) or convert with `float`.
- **No garbage collector**: every `cons` (including each new float) uses a
  node permanently, out of `SIZE` (1,000,000 by default). Long computations
  may end with `Storage overflow!`; increase `SIZE` if needed (about 50 bytes
  per node on arm64).

## Results

- Recursive Fibonacci: works.
- Perceptron solving XOR, using `x1 × x2` as a third input, trained with the
  perceptron learning rule
  (<https://en.wikipedia.org/wiki/Perceptron>): converges in about 30 epochs.

Code: see [lisp-code.md](lisp-code.md).

---

## License

The original `lisp.c` is the work of **Gregory J. Chaitin**; all rights on it
remain his, and the neuromuse license does not apply to it.

The contents of this repository (documentation, `neuromuse.patch`,
Lisp examples) are licensed under the
[PolyForm Noncommercial License 1.0.0](https://polyformproject.org/licenses/noncommercial/1.0.0)
— see [`LICENSE`](../LICENSE).

`lisp.c` itself is not included in this repository: it is available from
Chaitin's own publications.
