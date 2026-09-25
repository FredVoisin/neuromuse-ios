[ perceptron.l -- perceptron simple, regle du perceptron ]
[ neuromuse-ios -- Lisp de Chaitin + extension flottants ]
[ XOR devient lineairement separable avec une 3e entree x1*x2. ]
[ Chaque exemple : ((x1 x2 x1*x2 biais) cible), tout en flottants. ]

[ produit scalaire ]
define (dot w x)
   if atom w 0.0
   + * car w car x (dot cdr w cdr x)

[ fonction seuil ]
define (thr s) if > s 0.0 1.0 0.0

define (predict w x) (thr (dot w x))

[ w <- w + g x ]
define (upd w x g)
   if atom w nil
   cons + car w * g car x
        (upd cdr w cdr x g)

[ regle du perceptron : w <- w + lr (cible - sortie) x ]
define (learn w x t lr)
   (upd w x * lr - t (predict w x))

[ une epoque sur tous les exemples ]
define (epoch w data lr)
   if atom data w
   (epoch (learn w car car data cadr car data lr) cdr data lr)

[ nombre d erreurs sur les exemples ]
define (errors w data)
   if atom data 0
   + (if = (predict w car car data) cadr car data 0 1)
     (errors w cdr data)

[ apprend jusqu a zero erreur ou n epoques ; renvoie (poids epoques) ]
define (train w data lr n k)
   if = (errors w data) 0 cons w cons k nil
   if = n 0 cons w cons k nil
   (train (epoch w data lr) data lr - n 1 + k 1)

[ sorties du perceptron pour chaque exemple ]
define (outputs w data)
   if atom data nil
   cons (predict w car car data) (outputs w cdr data)

[ ---- XOR ---- ]
[ define ne s evalue pas : les donnees s ecrivent sans quote ]

define xor (
   ((0.0 0.0 0.0 1.0) 0.0)
   ((0.0 1.0 0.0 1.0) 1.0)
   ((1.0 0.0 0.0 1.0) 1.0)
   ((1.0 1.0 1.0 1.0) 0.0))

[ poids initiaux nuls, taux 1.0, 100 epoques au plus ]
[ affiche ((poids epoques) sorties) ]
let r (train '(0.0 0.0 0.0 0.0) xor 1.0 100 0)
   cons r cons (outputs car r xor) nil
