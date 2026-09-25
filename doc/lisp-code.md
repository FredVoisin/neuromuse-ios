# Lisp code on iPhone 5s

Companion to [chaitin-lisp.md](chaitin-lisp.md). Examples are in
[`examples/`](../examples/).
Dialect: the Lisp of Gregory J. Chaitin (original interpreter `lisp.c` by
Gregory J. Chaitin), with the neuromuse extensions (`load`, floats).

---

## Usage

Dialect: Chaitin's Lisp with the neuromuse extensions (`load`, floats).

```sh
./lisp < program.l      # run a file and exit
./lisp                  # interactive REPL
```

From the REPL:

```
load program.l
```

Comments are written `[ ... ]` (not `;`), and brackets cannot appear inside
a comment unless balanced.

---

## Floating-point tests

See [`examples/float-test.l`](../examples/float-test.l). Examples of results on the iPhone 5s:

```
(/ 1 3)            =>  0.3333333333
(- 3.0 5)          =>  -2.0
(- 3 5)            =>  0          [ integers: floors at zero ]
(sigmoid 2.5)      =>  0.92414182
```

---

## Fibonacci (recursive)

```lisp
[TODO: paste fib code]
```

Output:

```
[TODO: paste run output]
```

---

## Perceptron — XOR

Inputs: `x1`, `x2`, `x1 × x2`. Learning rule: perceptron rule.
Convergence: ~30 epochs.

```lisp
[TODO: paste perceptron code]
```

Output:

```
[TODO: paste training trace / final weights]
```

---

## Demo: perceptron → WAV playback

_To come._

```lisp
[TODO]
```

```sh
# TODO: playback script
```
