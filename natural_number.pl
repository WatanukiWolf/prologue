nat(0).
nat(suc(A)):-
    nat(A).

even(0).
even(suc(suc(A))):-
    even(A).

odd(suc(0)).
odd(suc(suc(A))):-
    odd(A).

lt(A, B):-
    B = suc(A).
lt(A, B):-
    lt(suc(A), B).

