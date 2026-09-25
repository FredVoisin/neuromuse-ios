# neuromuse-ios — Chaitin's Lisp on a jailbroken iPhone 5s

Experimental port of [neuromuse](https://github.com/FredVoisin/neuromuse)
ideas (perceptron, SOM) to a minimal Lisp running natively on an iPhone 5s
(checkra1n, arm64).

The interpreter is **`lisp.c` by Gregory J. Chaitin**. The original code is
not included here; this repository only contains the neuromuse modifications
and examples:

- `chaitin-lisp/neuromuse.patch` — adds `load` and floating-point numbers
  (`/ exp log sqrt floor float random seed`) to Chaitin's `lisp.c`
- `chaitin-lisp/Makefile` — applies the patch and builds with the Theos SDK
- `examples/*.l` — programs in Chaitin's Lisp (`.l`, not Common Lisp)

## Build

```sh
cd chaitin-lisp
cp /path/to/chaitin/lisp.c lisp.orig.c
make
```

## Run

```sh
cd examples
../chaitin-lisp/lisp
load float-test.l
```

## Documentation

- [doc/chaitin-lisp.md](doc/chaitin-lisp.md) — build, problems solved, extensions, pitfalls
- [doc/lisp-code.md](doc/lisp-code.md) — Lisp code and results

## Status

- [x] `load` and floating-point extension (tested on iPhone 5s)
- [ ] perceptron (`examples/perceptron.l`, port in progress)
- [ ] SOM (`examples/som.l`, draft, tested on Linux only)
- [ ] perceptron → WAV playback

## License

[PolyForm Noncommercial License 1.0.0](LICENSE). This does not cover
Chaitin's `lisp.c`, which is not included.
