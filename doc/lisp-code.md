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

Input: `x1`, `x2`, `x1 × x2`. Règle Widrow-Hoff.
Convergence: ~30 epochs.

```lisp
iPhone:~/dev/neuromuse mobile$ uname -a
Darwin iPhone 18.7.0 Darwin Kernel Version 18.7.0: Fri Aug 19 23:28:24 PDT 2022; root:xnu-4903.272.5~1/RELEASE_ARM64_S5L8960X iPhone6,2 arm64 N53AP Darwin
iPhone:~/dev/neuromuse mobile$ lisp
LISP Interpreter Run

load perceptron.l             

load        perceptron.l

[ perceptron.l -- perceptron simple, regle du perceptron ]
[ neuromuse-ios -- Lisp de Chaitin + extension flottants ]
[ XOR devient lineairement separable avec une 3e entree x1*x2. ]
[ Chaque exemple : ((x1 x2 x1*x2 biais) cible), tout en flottants. ]

[ produit scalaire ]
define (dot w x)
   if atom w 0.0
   + * car w car x (dot cdr w cdr x)

define      dot
value       (lambda (w x) (if (atom w) 0.0 (+ (* (car w) (car 
            x)) (dot (cdr w) (cdr x)))))


[ fonction seuil ]
define (thr s) if > s 0.0 1.0 0.0

define      thr
value       (lambda (s) (if (> s 0.0) 1.0 0.0))


define (predict w x) (thr (dot w x))

define      predict
value       (lambda (w x) (thr (dot w x)))


[ w <- w + g x ]
define (upd w x g)
   if atom w nil
   cons + car w * g car x
        (upd cdr w cdr x g)

define      upd
value       (lambda (w x g) (if (atom w) nil (cons (+ (car w) 
            (* g (car x))) (upd (cdr w) (cdr x) g))))


[ regle du perceptron : w <- w + lr (cible - sortie) x ]
define (learn w x t lr)
   (upd w x * lr - t (predict w x))

define      learn
value       (lambda (w x t lr) (upd w x (* lr (- t (predict w 
            x)))))


[ une epoque sur tous les exemples ]
define (epoch w data lr)
   if atom data w
   (epoch (learn w car car data cadr car data lr) cdr data lr)

define      epoch
value       (lambda (w data lr) (if (atom data) w (epoch (lear
            n w (car (car data)) (car (cdr (car data))) lr) (c
            dr data) lr)))


[ nombre d erreurs sur les exemples ]
define (errors w data)
   if atom data 0
   + (if = (predict w car car data) cadr car data 0 1)
     (errors w cdr data)

define      errors
value       (lambda (w data) (if (atom data) 0 (+ ((if (= (pre
            dict w (car (car data))) (car (cdr (car data)))) 0
             1)) (errors w (cdr data)))))


[ apprend jusqu a zero erreur ou n epoques ; renvoie (poids epoques) ]
define (train w data lr n k)
   if = (errors w data) 0 cons w cons k nil
   if = n 0 cons w cons k nil
   (train (epoch w data lr) data lr - n 1 + k 1)

define      train
value       (lambda (w data lr n k) (if (= (errors w data) 0) 
            (cons w (cons k nil)) (if (= n 0) (cons w (cons k 
            nil)) (train (epoch w data lr) data lr (- n 1) (+ 
            k 1)))))


[ sorties du perceptron pour chaque exemple ]
define (outputs w data)
   if atom data nil
   cons (predict w car car data) (outputs w cdr data)

define      outputs
value       (lambda (w data) (if (atom data) nil (cons (predic
            t w (car (car data))) (outputs w (cdr data)))))


[ ---- XOR ---- ]
[ define ne s evalue pas : les donnees s ecrivent sans quote ]

define xor (
   ((0.0 0.0 0.0 1.0) 0.0)
   ((0.0 1.0 0.0 1.0) 1.0)
   ((1.0 0.0 0.0 1.0) 1.0)
   ((1.0 1.0 1.0 1.0) 0.0))

define      xor
value       (((0.0 0.0 0.0 1.0) 0.0) ((0.0 1.0 0.0 1.0) 1.0) (
            (1.0 0.0 0.0 1.0) 1.0) ((1.0 1.0 1.0 1.0) 0.0))


[ poids initiaux NULS, taux 1.0, 100 epoques au plus ]
[ affiche ((poids epoques) sorties) ]
let r (train '(0.0 0.0 0.0 0.0) xor 1.0 100 0)
   cons r cons (outputs car r xor) nil

expression  ((' (lambda (r) (cons r (cons (outputs (car r) xor
            ) nil)))) (train (' (0.0 0.0 0.0 0.0)) xor 1.0 100
             0))
value       (((1.0 1.0 -3.0 0.0) 7) (0.0 1.0 1.0 0.0))


end of load success
```

Où chaque input a 4 composantes : X1 X2 X1.X2 et 1.0 (biais constant)

Et output value : 	(w1 w2 w3 bias epoque) (dernier output)

On peut rejoer avec d'autres poids au départ, même réponse :

```
[ poids initiaux aléatoires, taux 1.0, 100 epoques au plus ]
[ affiche ((poids epoques) sorties) ]
let r (train '(0.1 -0.1112 0.00987 -0.00001) xor 1.0 100 0)
   cons r cons (outputs car r xor) nil

expression  ((' (lambda (r) (cons r (cons (outputs (car r) xor
            ) nil)))) (train (' (0.1 -0.1112 0.00987 -1e-05)) 
            xor 1.0 100 0))
value       (((0.1 0.8888 -1.99013 -1e-05) 6) (0.0 1.0 1.0 0.0
            ))
```

Reste à voir sensibilité au bruit dans inputs

(en cours)

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
