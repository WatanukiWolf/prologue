% 決定性有限オートマトンの実装。
% せっかくPrologでやるなら単一化を生かした非決定性有限オートマトンを実装したい。
% is_acceptable([a, b, b, a]).
% で、abbaという文字列がここで定義したDFAに受理されるか判定できます。
% ちなみにこのDFAはaの後に2つ以上bが続くものだけを受理します。

alphabet(A):-
    member(A, [a, b]).

node(N):-
    member(N, [1, 2, 3, 4]).

start_node(N):-
    N is 1.

accept_node(N):-
    N is 1.

target(1, a, 2).
target(1, b, 1).
target(2, a, 4).
target(2, b, 3).
target(3, a, 4).
target(3, b, 1).
target(4, _, 4).

delta(N, Input, Target):-
    node(N),
    alphabet(Input),
    target(N, Input, Target).

filter([], _).
filter(List, Proc):-
    List = [Head|Tail],
    A =.. [Proc, Head],
    call(A),
    filter(Tail, Proc).

word(List):-
    filter(List, alphabet).

run_dfa([], Start, Start).
run_dfa(Word, Start, Ans):-
    word(Word),
    Word = [H|T],
    delta(Start, H, Target),
    run_dfa(T, Target, Ans2),
    Ans = Ans2.

is_acceptable(Word):-
    start_node(N),
    run_dfa(Word, N, Ans),
    accept_node(Ans).