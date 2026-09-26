LISP Interpreter Run

[ perceptronxor-noise.l -- perceptron tests xor et bruit -- ]
[ neuromuse-ios -- Lisp de Chaitin + extension flottants ]
[ test de robustess du perceptron XOR au bruit ]
[ Chaque exemple : ((x1 x2 x1*x2 biais) cible), en flottants. ]

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

define xor-clean (
   ((0.0 0.0 0.0 1.0) 0.0)
   ((0.0 1.0 0.0 1.0) 1.0)
   ((1.0 0.0 0.0 1.0) 1.0)
   ((1.0 1.0 1.0 1.0) 0.0))

define      xor-clean
value       (((0.0 0.0 0.0 1.0) 0.0) ((0.0 1.0 0.0 1.0) 1.0) (
            (1.0 0.0 0.0 1.0) 1.0) ((1.0 1.0 1.0 1.0) 0.0))


[ +/-0.02-0.05 ]
define xor-noisy (
   ((0.03 -0.02 -0.0006 1.0) 0.0)
   ((-0.01 1.04 -0.0104 1.0) 1.0)
   ((1.02 0.03 0.0306 1.0) 1.0)
   ((0.97 0.99 0.9603 1.0) 0.0))

define      xor-noisy
value       (((0.03 -0.02 -0.0006 1.0) 0.0) ((-0.01 1.04 -0.01
            04 1.0) 1.0) ((1.02 0.03 0.0306 1.0) 1.0) ((0.97 0
            .99 0.9603 1.0) 0.0))


[ Light noise (±0.02-0.05) augmented to 16 examples ]
[ 4 repetitions × 4 base points ]
define xor-noisy-aug (
   [ (0,0)→0 with 4 different noise realizations ]
   ((0.03 -0.02 -0.0006 1.0) 0.0)
   ((0.02 0.04 0.0008 1.0) 0.0)
   ((-0.04 0.01 -0.0004 1.0) 0.0)
   ((0.01 -0.03 -0.0003 1.0) 0.0)
   
   [ (0,1)→1 with 4 different noise realizations ]
   ((-0.01 1.04 -0.0104 1.0) 1.0)
   ((0.02 0.98 0.0196 1.0) 1.0)
   ((-0.03 1.05 -0.0315 1.0) 1.0)
   ((0.04 0.96 0.0384 1.0) 1.0)
   
   [ (1,0)→1 with 4 different noise realizations ]
   ((1.02 0.03 0.0306 1.0) 1.0)
   ((0.98 -0.02 -0.0196 1.0) 1.0)
   ((1.05 0.01 0.0105 1.0) 1.0)
   ((0.96 0.04 0.0384 1.0) 1.0)
   
   [ (1,1)→0 with 4 different noise realizations ]
   ((0.97 0.99 0.9603 1.0) 0.0)
   ((1.03 1.02 1.0506 1.0) 0.0)
   ((0.98 0.98 0.9604 1.0) 0.0)
   ((1.01 1.03 1.0403 1.0) 0.0))

define      xor-noisy-aug
value       (((0.03 -0.02 -0.0006 1.0) 0.0) ((0.02 0.04 0.0008
             1.0) 0.0) ((-0.04 0.01 -0.0004 1.0) 0.0) ((0.01 -
            0.03 -0.0003 1.0) 0.0) ((-0.01 1.04 -0.0104 1.0) 1
            .0) ((0.02 0.98 0.0196 1.0) 1.0) ((-0.03 1.05 -0.0
            315 1.0) 1.0) ((0.04 0.96 0.0384 1.0) 1.0) ((1.02 
            0.03 0.0306 1.0) 1.0) ((0.98 -0.02 -0.0196 1.0) 1.
            0) ((1.05 0.01 0.0105 1.0) 1.0) ((0.96 0.04 0.0384
             1.0) 1.0) ((0.97 0.99 0.9603 1.0) 0.0) ((1.03 1.0
            2 1.0506 1.0) 0.0) ((0.98 0.98 0.9604 1.0) 0.0) ((
            1.01 1.03 1.0403 1.0) 0.0))


[ Medium noise (±0.05-0.10) augmented to 20 examples ]
[ 5 repetitions × 4 base points ]
define xor-noisy+-aug (
   [ (0,0)→0 ]
   ((0.08 -0.12 -0.0096 1.0) 0.0)
   ((0.06 0.05 0.003 1.0) 0.0)
   ((-0.07 0.02 -0.0014 1.0) 0.0)
   ((0.04 -0.09 -0.0036 1.0) 0.0)
   ((0.09 -0.06 -0.0054 1.0) 0.0)
   
   [ (0,1)→1 ]
   ((0.05 0.95 0.0475 1.0) 1.0)
   ((-0.06 1.08 -0.0648 1.0) 1.0)
   ((0.07 0.92 0.0644 1.0) 1.0)
   ((0.03 1.06 0.0318 1.0) 1.0)
   ((-0.04 0.97 -0.0388 1.0) 1.0)
   
   [ (1,0)→1 ]
   ((0.88 0.09 0.0792 1.0) 1.0)
   ((1.07 -0.05 -0.0535 1.0) 1.0)
   ((0.95 0.08 0.076 1.0) 1.0)
   ((1.02 0.06 0.0612 1.0) 1.0)
   ((0.98 -0.08 -0.0784 1.0) 1.0)
   
   [ (1,1)→0 ]
   ((1.15 0.95 1.0925 1.0) 0.0)
   ((0.92 1.07 0.9844 1.0) 0.0)
   ((1.05 0.98 1.029 1.0) 0.0)
   ((0.97 1.04 1.0088 1.0) 0.0)
   ((1.08 0.93 1.0044 1.0) 0.0))

define      xor-noisy+-aug
value       (((0.08 -0.12 -0.0096 1.0) 0.0) ((0.06 0.05 0.003 
            1.0) 0.0) ((-0.07 0.02 -0.0014 1.0) 0.0) ((0.04 -0
            .09 -0.0036 1.0) 0.0) ((0.09 -0.06 -0.0054 1.0) 0.
            0) ((0.05 0.95 0.0475 1.0) 1.0) ((-0.06 1.08 -0.06
            48 1.0) 1.0) ((0.07 0.92 0.0644 1.0) 1.0) ((0.03 1
            .06 0.0318 1.0) 1.0) ((-0.04 0.97 -0.0388 1.0) 1.0
            ) ((0.88 0.09 0.0792 1.0) 1.0) ((1.07 -0.05 -0.053
            5 1.0) 1.0) ((0.95 0.08 0.076 1.0) 1.0) ((1.02 0.0
            6 0.0612 1.0) 1.0) ((0.98 -0.08 -0.0784 1.0) 1.0) 
            ((1.15 0.95 1.0925 1.0) 0.0) ((0.92 1.07 0.9844 1.
            0) 0.0) ((1.05 0.98 1.029 1.0) 0.0) ((0.97 1.04 1.
            0088 1.0) 0.0) ((1.08 0.93 1.0044 1.0) 0.0))


[ poids nul input clean : converge ]
let r (train '(0.0 -0.0 0.0 0.0) xor-clean 1.0 100 0)
   cons r cons (outputs car r xor-clean) nil

expression  ((' (lambda (r) (cons r (cons (outputs (car r) xor
            -clean) nil)))) (train (' (0.0 -0.0 0.0 0.0)) xor-
            clean 1.0 100 0))
value       (((1.0 1.0 -3.0 0.0) 7) (0.0 1.0 1.0 0.0))


[ poids random input clean : converge ]
let r (train '(0.1 -0.1112 0.00987 -0.00001) xor-clean 1.0 100 0)
   cons r cons (outputs car r xor-clean) nil

expression  ((' (lambda (r) (cons r (cons (outputs (car r) xor
            -clean) nil)))) (train (' (0.1 -0.1112 0.00987 -1e
            -05)) xor-clean 1.0 100 0))
value       (((0.1 0.8888 -1.99013 -1e-05) 6) (0.0 1.0 1.0 0.0
            ))


[ poids nuls input noisy : ne converge pas ]
let r (train '(0.0 0.0 0.0 0.0) xor-noisy 1.0 1000 0)
   cons r cons (outputs car r xor-noisy) nil

expression  ((' (lambda (r) (cons r (cons (outputs (car r) xor
            -noisy) nil)))) (train (' (0.0 0.0 0.0 0.0)) xor-n
            oisy 1.0 1000 0))
value       (((1.95 1.58 -3.7048 -1.0) 12) (0.0 1.0 1.0 0.0))


[ poids nuls input noisy-aug : devrait converger mais ne converge pas]
let r (train '(0.0 0.0 0.0 0.0) xor-noisy-aug 1.0 400 0)
   cons r cons (outputs car r xor-noisy-aug) nil 

expression  ((' (lambda (r) (cons r (cons (outputs (car r) xor
            -noisy-aug) nil)))) (train (' (0.0 0.0 0.0 0.0)) x
            or-noisy-aug 1.0 400 0))
value       (((1.17 1.28 -2.7985 -1.0) 6) (0.0 0.0 0.0 0.0 1.0
             1.0 1.0 1.0 1.0 1.0 1.0 1.0 0.0 0.0 0.0 0.0))


[ poids nuls apprentissage clean input noisy-aug ]
let r (train '(0.0 0.0 0.0 0.0) xor-clean 1.0 100 0)
   cons r cons (outputs car r xor-noisy-aug) nil 

expression  ((' (lambda (r) (cons r (cons (outputs (car r) xor
            -noisy-aug) nil)))) (train (' (0.0 0.0 0.0 0.0)) x
            or-clean 1.0 100 0))
value       (((1.0 1.0 -3.0 0.0) 7) (1.0 1.0 0.0 0.0 1.0 1.0 1
            .0 1.0 1.0 1.0 1.0 1.0 0.0 0.0 0.0 0.0))

End of LISP Run

Elapsed time is 0 seconds.
