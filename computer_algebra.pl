% derivative(pls(pls(mul(3, pow(x, 2)), mul(2, pow(x, 1))), 5), X), 
% simplify_formula(X, Y), simplify_formula(Y, Z),
% simplify_formula2(Z, Ans).
% X = pls(pls(mul(3, mul(2, pow(x, 1))), mul(2, mul(1, pow(x, 0)))), 0),
% Y = pls(mul(3, mul(2, x)), mul(2, 1)),
% Z = Ans, Ans = pls(mul(3, mul(2, x)), 2) ;
% 整式の微分ができる。でも出力がかなり冗長。注意してみたらわかる程度かも。

mul(_, _).
pls(_, _).

pow(X, N):-
    simple(X),
    number(N).

simplify_formula(N, N):-
    number(N).

simplify_formula(X, X):-
    var(X).

simplify_formula(pow(_, 0), 1).

simplify_formula(pow(X, 1), X2):-
    S =.. [simplify_formula, X, X2],
    call(S).

simplify_formula(mul(0, _), Ans):-
    Ans = 0, !.

simplify_formula(mul(X, 0), Ans):-
    simplify_formula(mul(0, X), Ans).

simplify_formula(mul(1, X), Ans):-
    S =.. [simplify_formula, X, X2],
    call(S),
    Ans = X2, !.

simplify_formula(mul(X, 1), Ans):-
    simplify_formula(mul(1, X), Ans).

simplify_formula(mul(X, Y), Ans):-
    S =.. [simplify_formula, X, X2],
    call(S),
    S2 =.. [simplify_formula, Y, Y2],
    call(S2),
    Ans = mul(X2, Y2), !.

simplify_formula(mul(X, Y), Ans):-
    simplify_formula(mul(Y, X), Ans), !.

simplify_formula(pls(0, X), Ans):-
    S =.. [simplify_formula, X, X2],
    call(S),
    Ans = X2, !.

simplify_formula(pls(X, 0), Ans):-
    simplify_formula(pls(0, X), Ans).

simplify_formula(pls(X, Y), Ans):-
    S =.. [simplify_formula, X, X2],
    call(S),
    S2 =.. [simplify_formula, Y, Y2],
    call(S2),
    Ans = pls(X2, Y2), !.

simplify_formula(pls(X, Y), Ans):-
    simplify_formula(pls(Y, X), Ans), !.

simplify_formula(Formula, Formula).

simplify_formula2(mul(N1, mul(N2, X)), Ans):-
    number(N1),
    number(N2),
    N3 is N1 * N2,
    Ans = mul(N3, X).

simplify_formula2(pls(N1, pls(N2, X)), Ans):-
    number(N1),
    number(N2),
    N3 is N1 + N2,
    Ans = pls(N3, X).

simplify_formula2(Formula, Formula).

% sigma(Index, Upper_bound, Lower_bound, Formula, Ans):-
    % inspect Formula to find Index.
    % change Index to corrent index number.
    % go next Index value to generate next terms.
    % sum up all terms.

derivative(mul(A, X), Ans):-
    S =.. [derivative, X, Y],
    call(S),
    Ans = mul(A, Y).

derivative(pls(A, B), Ans):-
    S =.. [derivative, A, X],
    S2 =.. [derivative, B, Y],
    call(S),
    call(S2),
    Ans = pls(X, Y).

derivative(N, Ans):-
    number(N),
    Ans is 0, !.

derivative(pow(_, 0), 0):- !.

derivative(pow(X, N), Ans):-
    N_1 is N - 1,
    Ans = mul(N, pow(X, N_1)).

% mul caluclation
arith_calc(X, Ans):-
    number(X),
    Ans is X, !.

arith_calc(mul(X, Y), Ans):-
    number(X),
    number(Y),
    Ans is X * Y, !.

arith_calc(mul(X, Y), Ans):-
    number(X),
    arith_calc(Y, Y2),
    arith_calc(mul(X, Y2), Ans).

arith_calc(mul(X, Y), Ans):-
    arith_calc(mul(Y, X), Ans), !.

% plus
arith_calc(pls(X, Y), Ans):-
    number(X),
    number(Y),
    Ans is X + Y, !.

arith_calc(pls(X, Y), Ans):-
    number(X),
    arith_calc(Y, Y2),
    arith_calc(pls(X, Y2), Ans).

arith_calc(pls(X, Y), Ans):-
    arith_calc(pls(Y, X), Ans), !.