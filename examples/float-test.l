[ tests flottants ]
+ 0.5 0.25
- 3.0 5
- 3 5
* 2 1.5
/ 1 3
exp 1
sqrt 2
- 0 1e-3
< -1.5 2
= 2 2.0
= 0.5 0.5
floor 3.7
floor -2.5
+ floor 3.7 4
^ 2.0 0.5
' (0.1 -2 3)
size 0.5
seed 42
random
random
seed 42
random
define (sq x) * x x
define (dist2 a b) if atom a 0.0 + (sq - car a car b) (dist2 cdr a cdr b)
(dist2 '(0.0 0.0) '(3.0 4.0))
sqrt (dist2 '(1 2) '(4 6.0))
define (sigmoid x) / 1.0 + 1.0 exp - 0.0 x
(sigmoid 0)
(sigmoid 2.5)
