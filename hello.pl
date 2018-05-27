f(Acc, 0, Acc).

f(Acc, N, X):-
    N >= 0,
    append(Acc, [0], A),
    N_1 is N - 1,
    f(A, N_1, X).

f(Acc, N, X):-
        N >= 0,
        append(Acc, [1], A),
        N_1 is N - 1,
        f(A, N_1, X).

number_of_combination_consist_of_0_1(N, X):-
    f([], N, X).