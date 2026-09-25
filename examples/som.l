[ som.l -- carte auto-organisatrice de Kohonen (SOM) 1D ]
[ neuromuse -- Lisp de Chaitin + extension flottants (neuromuse.patch) ]
[ Toutes les donnees et tous les poids doivent etre des flottants : ]
[ entre deux entiers, - 1 4 donne 0 et non -3. ]

[ ---- vecteurs ---- ]

define (sq x) * x x

[ distance euclidienne au carre entre deux vecteurs ]
define (dist2 a b)
   if atom a 0.0
   + (sq - car a car b) (dist2 cdr a cdr b)

[ vecteur aleatoire de n composantes entre 0 et 1 ]
define (rand-vec n)
   if = n 0 nil
   cons random (rand-vec - n 1)

[ carte de k unites de dimension n ]
define (rand-map k n)
   if = k 0 nil
   cons (rand-vec n) (rand-map - k 1 n)

[ ---- unite gagnante (BMU) ---- ]

[ parcourt la carte m ; i = indice courant ; bi, bd = meilleur indice et distance ]
define (bmu-rec m x i bi bd)
   if atom m bi
   let d (dist2 car m x)
   if < d bd
      (bmu-rec cdr m x + i 1 i d)
      (bmu-rec cdr m x + i 1 bi bd)

define (bmu m x) (bmu-rec m x 0 0 1e30)

[ ---- apprentissage ---- ]

[ voisinage gaussien entre les unites i et c, largeur s ]
define (neigh i c s)
   exp - 0.0 / (sq - float i c) * 2.0 (sq s)

[ w <- w + g (x - w) ]
define (upd w x g)
   if atom w nil
   cons + car w * g - car x car w
        (upd cdr w cdr x g)

[ met a jour toute la carte autour du gagnant c ; a = taux, s = voisinage ]
define (upd-map m x c i a s)
   if atom m nil
   cons (upd car m x * a (neigh i c s))
        (upd-map cdr m x c + i 1 a s)

[ presentation d'un exemple ]
define (step m x a s) (upd-map m x (bmu m x) 0 a s)

[ une epoque : tous les exemples de data ]
define (epoch m data a s)
   if atom data m
   (epoch (step m car data a s) cdr data a s)

[ n epoques restantes sur total ; taux et voisinage decroissent lineairement ]
[ a0 = taux initial, s0 = largeur initiale du voisinage ]
define (train m data n total a0 s0)
   if = n 0 m
   (train (epoch m data * a0 / n total + 0.5 * s0 / n total)
          data - n 1 total a0 s0)

[ ---- lecture du resultat ---- ]

[ indice de l'unite gagnante pour chaque exemple ]
define (labels m data)
   if atom data nil
   cons (bmu m car data) (labels m cdr data)
