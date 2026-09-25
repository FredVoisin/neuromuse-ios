[ som-demo.l -- demonstration de som.l ]
[ Quatre familles de sons decrites par deux descripteurs normalises : ]
[ brillance (grave/aigu) et intensite (doux/fort). ]
[ Une carte 1D de 6 unites doit les ranger dans un ordre continu. ]
[ NB : define d'une variable ne l'evalue pas. On ecrit donc les donnees ]
[ sans quote, et on calcule la carte dans un let. ]

load som.l

seed 7

define data (
   (0.10 0.15) (0.15 0.10) (0.12 0.20)
   (0.10 0.85) (0.15 0.90) (0.20 0.80)
   (0.85 0.90) (0.90 0.85) (0.80 0.95)
   (0.90 0.10) (0.85 0.20) (0.95 0.15))

[ carte aleatoire de 6 unites, 20 epoques, taux initial 0.5, voisinage 2.0 ]
[ affiche la carte apprise puis l'unite gagnante de chaque son ]
let map (train (rand-map 6 2) data 20 20 0.5 2.0)
   cons map cons (labels map data) nil
