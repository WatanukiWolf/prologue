% 線形分離関数を内蔵したパーセプトロンを学習させ、適切な係数ベクトルを得た。
% 線形分離関数g([x1, x2])=w1 * x1 + w2 * x2 + w3
% パーセプトロンは、g([x2, x2])>=0の時+1に分類し、それ以外で-1に分類する。
% 分類がx1とx2の論理積に一致するように、w1~3を学習することが目的。
% training([_,_,_], X).  (_には数を入れる)
% で、第一引数をw1~3の初期値とし、全部の[x1, x2]に対して間違いがなくなるまで
% 学習する。

point([0, 0], -1).
point([0, 1], -1).
point([1, 0], -1).
point([1, 1], +1).

filter([], _).
filter(List, Proc):-
    List = [Head|Tail],
    A =.. [Proc, Head],
    call(A),
    filter(Tail, Proc).

vector3(X):-
    length(X, 3),
    filter(X, number).

linear_discriminant_function(Point, Vec3, Ans):-
    vector3(Vec3),
    point(Point, _),
    Vec3 = [V1, V2, V3],
    Point = [P1, P2],
    Ans is V1 * P1 + V2 * P2 + V3.

step_function(X, Y):-
    X >= 0,
    Y = 1.
step_function(X, Y):-
    X < 0,
    Y = -1.

perceptron(Point, Vec3, Ans):-
    linear_discriminant_function(Point, Vec3, X),
    step_function(X, Ans).

run_perceptron(Point, Vec3, Ans, Expected):-
    perceptron(Point, Vec3, Ans),
    point(Point, Expected).

check(Point, Vec3, Ans):-
    run_perceptron(Point, Vec3, Ans2, Expected),
    \+(Ans2 is Expected),
    Ans = Point.

check(Point, Vec3, Ans):-
    run_perceptron(Point, Vec3, Ans2, Expected),
    Ans2 is Expected,
    Ans = true.

incorrectly_classified_point(Point, Vec3):-
    check(Point, Vec3, Ans),
    \+(Ans = true).

new_coefficients(Vec3, Ans):-
    incorrectly_classified_point(Point, Vec3),
    point(Point, Expected),
    Vec3 = [V1, V2, V3],
    Point = [P1, P2],
    A is V1 + P1 * Expected,
    B is V2 + P2 * Expected,
    C is V3 + Expected,
    Ans = [A, B, C].

new_coefficients(Vec3, Ans):-
    \+incorrectly_classified_point(_, Vec3),
    Ans = Vec3.

training(Vec3, Ans):-
    new_coefficients(Vec3, X),
    Vec3 = X,
    Ans = X.

training(Vec3, Ans):-
    new_coefficients(Vec3, X),
    \+(Vec3 = X),
    training(X, Y),
    Ans = Y.