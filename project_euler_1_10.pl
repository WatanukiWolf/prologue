% Problem 1: Multiples of 3 and 5
find_multiples_of_3_5([], []).

find_multiples_of_3_5([H|T], Ans):-
    is_multiples_of_3_5(H, X),
    find_multiples_of_3_5(T, R),
    Ans = [X|R].

is_multiples_of_3_5(N, Ans):-
    number(N),
    0 is N mod 3 -> Ans = N;
    0 is N mod 5 -> Ans = N;
    true -> Ans is 0.

sum_of_all_the_multiples_of_3_or_5_below_1000(Ans):-
    numlist(1, 999, L),
    find_multiples_of_3_5(L, Multiples),
    sumlist(Multiples, Ans).

:-  write('----Problem 1----\n'),
    sum_of_all_the_multiples_of_3_or_5_below_1000(Ans),
    write(Ans),
    write('\n').

%Problem 2: Even Fibonacci numbers
fibonacci_numbers_no_more_than_four_million(Prev1, Prev2, Memo, Ans):-
    Prev2 > 4000000 ->
        append(Memo, [Prev1], Ans), !
        ;
        Next is Prev1 + Prev2,
        append(Memo, [Prev1], Memo2),
        fibonacci_numbers_no_more_than_four_million(Prev2, Next, Memo2, Ans).

find_even([], Memo, Memo).

find_even([H|T], Memo, Ans):-
    (0 is H mod 2 -> H2 is H; H2 is 0),
    append(Memo, [H2], Memo2),
    find_even(T, Memo2, Ans).

:-  write('----Problem 2----\n'),
    fibonacci_numbers_no_more_than_four_million(1, 1, [], Fibo),
    find_even(Fibo, [], Even_fibo),
    sumlist(Even_fibo, Ans),
    write(Ans),
    write('\n').

%Problem 3: Largest prime factor
prime_numbers_no_more_than(Bound, N, Memo, Ans):-
    N > Bound ->
        !, Ans = Memo
        ;
        is_N_List_relatively_prime(N, Memo) ->
            N2 is N + 1,
            append(Memo, [N], Memo2),
            prime_numbers_no_more_than(Bound, N2, Memo2, Ans)
            ;
            N2 is N + 1,
            prime_numbers_no_more_than(Bound, N2, Memo, Ans).

is_N_List_relatively_prime(_, []).

is_N_List_relatively_prime(N, [H|T]):-
    0 is N mod H -> false; is_N_List_relatively_prime(N, T).

find_factors_of(_, [], Memo, Memo).

find_factors_of(N, [H|T], Memo, Ans):-
    0 is N mod H ->
        append(Memo, [H], Memo2),
        find_factors_of(N, T, Memo2, Ans)
        ;
        find_factors_of(N, T, Memo, Ans).

multilist([], Memo, Memo).

multilist([H|T], Memo, Ans):-
    Memo2 is Memo * H,
    multilist(T, Memo2, Ans).

division_loop(N, 1, N).

division_loop(N, Divider, Ans):-
    Mod is N mod Divider,
    (Mod =\= 0) ->
        Ans is N
        ;
        N2 is N / Divider,
        division_loop(N2, Divider, Ans).

division_loop_list(N, [], N).

division_loop_list(N, [H|T], Ans):-
    division_loop(N, H, N2),
    division_loop_list(N2, T, Ans).

prime_factors_of(1, _, Memo, Memo):- !.

prime_factors_of(N, Upper_bound_of_scope, Memo, Ans):-
    prime_numbers_no_more_than(Upper_bound_of_scope, 2, [], Prime_numbers),
    find_factors_of(N, Prime_numbers, [], Factors),
    division_loop_list(N, Factors, N2),
    union(Memo, Factors, Memo2),
    Next_scope is Upper_bound_of_scope * 10,
    prime_factors_of(N2, Next_scope, Memo2, Ans).

:-  write('----Problem 3----\n'),
    prime_factors_of(600851475143, 10, [], Factors),
    max_list(Factors, Ans),
    write(Ans),
    write('\n').

% Problem 4: Largest palindrome product
substrate_from_list([], _, Memo, Memo).

substrate_from_list([H|T], N, Memo, Ans):-
    H2 is H - N,
    append(Memo, [H2], Memo2),
    substrate_from_list(T, N, Memo2, Ans).

multiple_of_number_and_list([], _, Memo, Memo).

multiple_of_number_and_list([H|T], N, Memo, Ans):-
    H2 is H * N,
    append(Memo, [H2], Memo2),
    multiple_of_number_and_list(T, N, Memo2, Ans).

parindrome_number(N):-
    number_to_chars(N, Codes),
    substrate_from_list(Codes, 48, [], Digits),
    reverse(Digits, Digits).

find_parindromes_from_list([], Memo, Memo).

find_parindromes_from_list([H|T], Memo, Ans):-
    parindrome_number(H) ->
        append(Memo, [H], Memo2),
        find_parindromes_from_list(T, Memo2, Ans)
        ;
        find_parindromes_from_list(T, Memo, Ans).

largest_palindrome_from_product_of_two_3digit_numbers(1000, Memo, Memo):- !.

largest_palindrome_from_product_of_two_3digit_numbers(I, Memo, Ans):-
    numlist(I, 999, List),
    multiple_of_number_and_list(List, I, [], Multiples),
    find_parindromes_from_list(Multiples, [], Parindromes),
    max_list(Parindromes, Max),
    Max > Memo ->
        I2 is I + 1,
        largest_palindrome_from_product_of_two_3digit_numbers(I2, Max, Ans)
        ;
        I2 is I + 1,
        largest_palindrome_from_product_of_two_3digit_numbers(I2, Memo, Ans).

% :-  write('----Problem 4----\n'),
%     largest_palindrome_from_product_of_two_3digit_numbers(1, 0, Ans),
%     write(Ans),
%     write('\n').

% f([], _, []).
% f([H|T], N, [H2|T2]):-
%     H2 is H - N,
%     f(T, N, T2).
% 反省点、Memoを使わなくてもこういう風にパターンマッチを活用すれば再帰的に処理できる。

% Problem 5: Smallest multiple
factorization(1, [], Memo, Memo).

factorization(N, [H|T], Memo, Ans):-
    \+(0 is N mod H)
    ->  factorization(N, T, Memo, Ans)
    ;   N2 is N / H,
        append(Memo, [H], Memo2),
        factorization(N2, [H|T], Memo2, Ans).

count_factors([], Memo, Memo).

count_factors([H|T], Memo, Ans):-
    last(Memo, [H|Exponent])
    ->  reverse(Memo, [_|R]),
        reverse(R, R2),
        Exponent2 is Exponent + 1,
        append(R2, [[H|Exponent2]], Memo2),
        count_factors(T, Memo2, Ans)
    ;   append(Memo, [[H|1]], Memo2),
        count_factors(T, Memo2, Ans).

factorization_list(21, Memo, Memo).

factorization_list(N, Memo, Ans):-
    factorization(N, [2, 3, 5, 7, 11, 13, 17, 19], [], Factors),
    count_factors(Factors, [], Counts),
    append(Memo, [Counts], Memo2),
    N2 is N + 1,
    factorization_list(N2, Memo2, Ans).

substitute(X, Y, List1, List2) :-
        append(L1, [X | L2], List1),
        append(L1, [Y | L2], List2).

max_counts(_, [], Memo, Memo):- !.

max_counts(20, [_|T], Memo, Ans):-
    max_counts(2, T, Memo, Ans), !.

max_counts(N, [H|T], Memo, Ans):-
    N < 20,
    (member([N|Exponent], H), member([N|Exponent2], Memo))
    ->  Max is max(Exponent, Exponent2),
        substitute([N|Exponent2], [N|Max], Memo, Memo2),
        N2 is N + 1,
        max_counts(N2, [H|T], Memo2, Ans)
    ;   N2 is N + 1,
        max_counts(N2, [H|T], Memo, Ans).

smallest_multiple([], Memo, Memo).

smallest_multiple([[N|Exponent]|T], Memo, Ans):-
    N2 is N ** Exponent,
    Memo2 is Memo * N2,
    smallest_multiple(T, Memo2, Ans).

:-  factorization_list(2, [], Factorization_list),
    max_counts(2, Factorization_list, [[2|1], [3|1], [5|1], [7|1], [11|1], [13|1], [17|1], [19|1]], Max_counts),
    smallest_multiple(Max_counts, 1, Ans),
    write(Ans).