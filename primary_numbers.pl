% 素数を順次生成するプログラム
relatively_prime([], _).

relatively_prime([H|T], N):-
    \+(0 is N mod H),
    relatively_prime(T, N).

is_next_primary_number([], 2):- !.

is_next_primary_number([2], 3):- !.

is_next_primary_number(Primary_numbers, Candidate):-
    relatively_prime(Primary_numbers, Candidate).

next_primary_number(Primary_numbers, Candidate, Ans):-
    is_next_primary_number(Primary_numbers, Candidate)
        ->  Ans is Candidate
        ;   Next_candidate is Candidate + 2,
            next_primary_number(Primary_numbers, Next_candidate, Ans).

find_next_primary_number(Primary_numbers, Ans):-
    last(Primary_numbers, Last),
    Candidate is Last + 2,
    next_primary_number(Primary_numbers, Candidate, Ans).

add_next_primary_number(Primary_numbers, Ans):-
    find_next_primary_number(Primary_numbers, Next),
    append(Primary_numbers, [Next], Ans).

loop(Upper_bound, Upper_bound, _, Memo, Memo):- !.

loop(Lower_bound, Upper_bound, Proc, Memo, Ans):-
    S =.. [Proc, Memo, Memo2],
    call(S),
    Next is Lower_bound + 1,
    loop(Next, Upper_bound, Proc, Memo2, Ans).

inc(A, B):-
    B is A + 1.

ten_thousandth_primary_number(Ans):-
    loop(1, 9999, add_next_primary_number, [2, 3], X),
    last(X, Ans).

:-  ten_thousandth_primary_number(N),
    write(N),
    write('\n').