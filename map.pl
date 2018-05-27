map([], _, []).

map(List, Proc, X):-
    List = [H|T],
    A =.. [Proc, H, H2],
    call(A),
    map(T, Proc, T2),
    X = [H2|T2].

bitrev(0, 1).
bitrev(1, 0).