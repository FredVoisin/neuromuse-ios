# Perceptron XOR sur iPhone 5s

**Tutorial complet d'apprentissage du perceptron Widrow-Hoff avec données bruitées**

neuromuse-ios | Chaitin's lisp.c + extensions flottants | iPhone 5s, iOS 12.5.x

---

## Table des matières

0. [Vue d'ensemble](#vue-densemble)
1. [Contexte historique](#contexte)
2. [Code et observation du perceptron](#code-du-perceptron)
3. [Datasets](#datasets)
4. [Résultats et analyse](#résultats-et-analyse)
5. [Pièges et solutions](#pièges-et-solutions)
6. [Conclusions](#conclusions)

---

## Vue d'ensemble

Ce tutorial documente l'apprentissage d'un **perceptron** sur le problème **XOR** — un cas classique d'apprentissage machine,
tel que décrit et interprété dans [../examples/perceptronxor-noise.l](../examples/perceptronxor-noise.l), avec :

- **Entrées** : x₁, x₂ ∈ {0, 1}
- **Sortie** : y = x₁ XOR x₂ ∈ {0, 1}
- **Solution** : augmenter les features avec le produit x₁·x₂ pour rendre XOR linéairement séparable
- **Algorithme** : Widrow-Hoff (perceptron learning rule)
- **Plateforme** : pur lambda-calcul en Lisp de Chaitin sur iPhone 5s

---
## Contexte historique

- 1958 : Frank Rosenblatt invente le perceptron et démontre son théorème de convergence
- 1969 : Minsky & Papert prouvent mathématiquement que le perceptron ne peut pas résoudre des problèmes non linéairement séparable — dont XOR est l'exemple canonique ; début de l'hiver de l'IA
- 1974 : Paul Werbos décrit la backpropagation dans sa thèse (ignorée) "Beyond Regression: New Tools for Prediction and Analysis in the Behavioral Sciences"
- 1980 : Kunihiko Fukushima, neocognitron (apprentissage par couches)
- 1982 : John Hopfield	Réseaux récurrents
- 1986 : Rumelhart, Hinton, Williams - rédécouverte de la backpropagation + impact (fin de l'hiver)
- 1989 : Yann LeCun et al., LeNet (CNN sur MNIST)

Ainsi un perceptron monocouche ne peut pas calculer XOR car cette fonction n'est pas linéairement séparable dans l'espace d'entrée brut (Minsky & Papert :"Perceptrons: An Introduction to Computational Geometry").

La solution d'augmenter les dimensions, bien qu'envisagée (les "features engineering", ici en ajoutant une entrée x1 * x2, ou d'empiler des perceptrons ce qui fait des MLP) a été ignorée jusque 1986 (Rumelhart, Hinton & Williams, "Learning representations by back-propagating errors").

## Code et observation du perceptron

Toutes les fonctions sont **immutables** — aucune mutation, tout récursif et fonctionnel.

### Dot product (produit scalaire)

```lisp
define (dot w x)
   if atom w 0.0
   + * car w car x (dot cdr w cdr x)
```

Accumule Σ wᵢ·xᵢ récursivement.

### Threshold activation (seuil)

```lisp
define (thr s) if > s 0.0 1.0 0.0
```

Retourne 1.0 si s > 0, sinon 0.0.

### Predict (forward pass)

```lisp
define (predict w x) (thr (dot w x))
```

Prédiction = seuil(w·x).

### Update weights (mise à jour des poids)

```lisp
define (upd w x g)
   if atom w nil
   cons + car w * g car x
        (upd cdr w cdr x g)
```

Retourne nouveaux poids : wᵢ' = wᵢ + g·xᵢ.

### Widrow-Hoff learning (règle d'apprentissage)

```lisp
define (learn w x t lr)
   (upd w x * lr - t (predict w x))
```

Met à jour les poids : **w' = w + lr·(target - predict)·x**

Gain = learning_rate × erreur × input.

### One epoch

```lisp
define (epoch w data lr)
   if atom data w
   (epoch (learn w car car data cadr car data lr) cdr data lr)
```

Itère sur tous les exemples, met à jour poids à chaque fois.

### Error count (nombre d'erreurs)

```lisp
define (errors w data)
   if atom data 0
   + (if = (predict w car car data) cadr car data 0 1)
     (errors w cdr data)
```

Compte combien de prédictions sont fausses.

### Train loop (boucle d'entraînement)

```lisp
define (train w data lr n k)
   if = (errors w data) 0 cons w cons k nil
   if = n 0 cons w cons k nil
   (train (epoch w data lr) data lr - n 1 + k 1)
```

Entraîne jusqu'à convergence (zéro erreurs) ou n epochs.
Retourne `(poids epochs)`.

### Batch predictions (prédictions batch)

```lisp
define (outputs w data)
   if atom data nil
   cons (predict w car car data) (outputs w cdr data)
```

Applique le perceptron à tous les exemples.

---

## Datasets

Chaque exemple a la structure : `((x₁ x₂ x₁·x₂ biais) cible)` en flottants.

### xor-clean : 4 exemples, aucun bruit

```lisp
define xor-clean (
   ((0.0 0.0 0.0 1.0) 0.0)
   ((0.0 1.0 0.0 1.0) 1.0)
   ((1.0 0.0 0.0 1.0) 1.0)
   ((1.0 1.0 1.0 1.0) 0.0))
```

Baseline — **converge facilement**.

### xor-noisy : 4 exemples, bruit ±0.02-0.05

```lisp
define xor-noisy (
   ((0.03 -0.02 -0.0006 1.0) 0.0)
   ((-0.01 1.04 -0.0104 1.0) 1.0)
   ((1.02 0.03 0.0306 1.0) 1.0)
   ((0.97 0.99 0.9603 1.0) 0.0))
```

Petit dataset avec perturbations légères — **ne converge pas bien**.

### xor-noisy-aug : 16 exemples, bruit ±0.02-0.05, augmenté

```lisp
define xor-noisy-aug (
   [ (0,0)→0 : 4 réalisations bruitées ]
   ((0.03 -0.02 -0.0006 1.0) 0.0)
   ((0.02 0.04 0.0008 1.0) 0.0)
   ((-0.04 0.01 -0.0004 1.0) 0.0)
   ((0.01 -0.03 -0.0003 1.0) 0.0)
   
   [ (0,1)→1 : 4 réalisations bruitées ]
   ((-0.01 1.04 -0.0104 1.0) 1.0)
   ((0.02 0.98 0.0196 1.0) 1.0)
   ((-0.03 1.05 -0.0315 1.0) 1.0)
   ((0.04 0.96 0.0384 1.0) 1.0)
   
   [ ... (1,0)→1 et (1,1)→0 : 4 reps chaque ... ]
)
```

**4 points de base × 4 perturbations = 16 exemples** — **converge bien !**

### xor-noisy+-aug : 20 exemples, bruit ±0.05-0.10, augmenté

Même structure, bruit plus fort, 5 répétitions par point.

---

## Résultats et analyse

### Test 1 : Clean baseline

```
Commande:
let r (train '(0.0 0.0 0.0 0.0) xor-clean 1.0 100 0)
   cons r cons (outputs car r xor-clean) nil

Résultat:
Poids: (1.0 1.0 -3.0 0.0)
Epochs: 7
Outputs: (0.0 1.0 1.0 0.0) ✅ 100% correct
```

**Verdict** : Converge rapidement, 100% accuracy. ✅

---

### Test 2 : Noisy petit dataset

```
Commande:
let r (train '(0.0 0.0 0.0 0.0) xor-noisy 1.0 1000 0)
   cons r cons (outputs car r xor-noisy) nil

Résultat:
Poids: (1.95 1.58 -3.7048 -1.0)
Epochs: 12
Outputs: (0.0 1.0 1.0 0.0) ✅ 100% sur noisy
```

**Problème** : Avec seulement 4 exemples bruités, le perceptron oscille.
**Raison** : 
- Bruit asymétrique pousse certains points du mauvais côté de la frontière
- Petit dataset = peu de "votes" pour corriger les erreurs
- 1000 epochs = risque de storage overflow

**Verdict** : Converge mais fragile, risque de débordement mémoire. ⚠️

---

### Test 3 : Noisy augmenté (SUCCÈS)

```
Commande:
let r (train '(0.0 0.0 0.0 0.0) xor-noisy-aug 1.0 400 0)
   cons r cons (outputs car r xor-noisy-aug) nil

Résultat:
Poids: (1.17 1.28 -2.7985 -1.0)
Epochs: 6
Outputs: (0.0 0.0 0.0 0.0 | 1.0 1.0 1.0 1.0 | 1.0 1.0 1.0 1.0 | 0.0 0.0 0.0 0.0)
         └─ (0,0)→0 ─┘   └─ (0,1)→1 ─┘   └─ (1,0)→1 ─┘   └─ (1,1)→0 ─┘
         ✅ 100% correct sur tous les 16 exemples
```

**Succès** : Augmentation de données fonctionne !
**Raison** :
- 16 exemples = 4 réalisations bruités par classe
- Les erreurs d'une réalisation sont corrigées par les autres
- "Voting" par bruit : chaque point vote plusieurs fois
- Converge en 6 epochs seulement

**Verdict** : Robustesse accrue, convergence rapide. ✅✅

---

### Test 4 : Robustesse — Clean weights sur données bruitées

```
Commande:
let r (train '(0.0 0.0 0.0 0.0) xor-clean 1.0 100 0)
   cons r cons (outputs car r xor-noisy-aug) nil

Résultat:
Poids: (1.0 1.0 -3.0 0.0)  [poids clean idéaux]
Epochs: 7
Outputs: (1.0 1.0 0.0 0.0 | 1.0 1.0 1.0 1.0 | 1.0 1.0 1.0 1.0 | 0.0 0.0 0.0 0.0)
         └─ (0,0)→0 ─┘
         ❌ Erreurs sur indices 0-1 : (0,0) bruité prédit 1.0 au lieu de 0.0
         Accuracy: 14/16 = 87.5% ⚠️
```

**Observation** : Les poids idéaux ne sont PAS robustes au bruit !
**Raison** :
- Points (0,0) bruités : a = 0.03 + (-0.02) - 3×(-0.0006) = 0.0118 > 0
- → Prédit 1.0, mais cible 0.0 ❌

**Conclusion** : Entraîner sur le bruit est nécessaire pour la robustesse. 🎯

---

## Pièges et solutions

### Piège 1 : Pas de quote sur les données

**Problème**
```lisp
train (0.0 0.0 0.0 0.0) xor-clean 1.0 100 0
```

Chaitin Lisp évalue `(0.0 0.0 0.0 0.0)` comme appel de fonction → erreur.

**Solution**
```lisp
train '(0.0 0.0 0.0 0.0) xor-clean 1.0 100 0
```

Le `'` (quote) traite la liste comme donnée littérale, pas expression.

### Piège 2 : Bruit sur les cibles

**Problème** 
```lisp
((0.03 -0.02 -0.0006 1.0) 0.02)  ; (0,0)→0 avec cible=0.02 bruitée
```

Deux "zéros" reçoivent des targets différents → **signaux contradictoires**.

Exemple :
```
Point 1: (0, 0) → cible 0.02
Point 2: (0, 0) bruité → cible 0.0
Le perceptron ne peut pas apprendre une fonction déterministe.
```

**Solution**
```lisp
((0.03 -0.02 -0.0006 1.0) 0.0)  ; cible EXACT, bruit SUR x1, x2 SEULEMENT
```

### Piège 3 : Petit dataset + bruit = oscillation

**Problème**
```lisp
train '(0.0 0.0 0.0 0.0) xor-noisy 1.0 1000 0
```

Avec 4 exemples bruités et 1000 epochs :
- Le perceptron oscille (ne converge jamais)
- L'arborescence des poids croît sans limite
- Storage overflow après quelques centaines d'epochs

**Solution**
- Augmenter le dataset : 4 → 16-20 exemples
- Réduire epochs : 1000 → 100-400
- Garder LR = 1.0 (cf. règle)

### Piège 4 : Learning rate trop petit

**Problème**
```lisp
train '(0.0 0.0 0.0 0.0) xor-noisy 0.1 1000 0
```

LR=0.1 avec 16 exemples et 1000 epochs = trop d'itérations accumulées en mémoire.

**Solution**
- LR=1.0 pour convergence rapide
- LR=2.0 pour bruit moyen
- Epochs réduits (100-500, pas 1000+)

**Ne pas oublier**
Recalculer systématiquement : `x₁_noisy × x₂_noisy` pour chaque exemple.

---

## Conclusions

### Succès clés

| Stratégie | Epochs | Accuracy | Robustesse |
|-----------|--------|----------|-----------|
| **Clean** | 7 | 100% | ❌ Faible |
| **Noisy (4 ex)** | 12 | 100% (noisy) | ⚠️ Instable |
| **Noisy-aug (16 ex)** | **6** | **100%** | **✅ Bonne** |
| Clean poids → noisy data | 7 | 87.5% | ⚠️ Partielle |

### Apprentissages

1. **L'augmentation de données fonctionne** : 4 → 16 exemplaires fait converger le bruit
2. **Le "voting" par bruit** : plusieurs réalisations d'une classe corrigent les erreurs
3. **Entraîner sur le bruit crée la robustesse** : poids clean ≠ poids robustes
4. **Syntaxe Chaitin critique** : quote `'` obligatoire pour données littérales
5. **Bruit asymétrique** : le bruit non-uniforme pousse systématiquement les points → nécessite augmentation
6. **Target exact, input bruité** : jamais de bruit sur les targets (signaux contradictoires)
7. **Hyperparamètres serrés** : LR=1.0, epochs=100-400, dataset≥16 pour bruit

### Implémentation sur iPhone 5s

```bash
# Créer le fichier de test
cat > perceptronxor-noise.l << 'EOF'
[ Code complet du perceptron + datasets + tests ]
EOF

# Exécuter et sauvegarder résultats
lisp < perceptronxor-noise.l | tee perceptronxor-noise.r

# Voir résultats
cat perceptronxor-noise.r
```

---

**Frédéric Voisin** — neuromuse-ios  
iPhone 5s, Chaitin's lisp.c + neuromuse.patch  
2026-09-25

---

**Licence** : PolyForm Noncommercial 1.0.0