card(Suit, Number):-
    member(Suit, [hart, spade, dia, club]),
    between(1, 13, Number).

a(hart, Number):-
    card(hart, Number).
a(Suit, Number):-
    card(Suit, Number),
    0 is Number mod 3.

b(Suit, Number):-
    card(Suit, Number),
    \+(Suit = spade),
    \+(0 is Number mod 6).

c(Suit, Number):-
    card(Suit, Number),
    0 is Number mod 2,
    \+(0 is Number mod 4).

d(Suit, Number):-
    card(Suit, Number),
    Number >= 5.

card_satisfy_A_B_C_D(Suit, Number):-
    a(Suit, Number),
    b(Suit, Number),
    c(Suit, Number),
    d(Suit, Number).

:-  card_satisfy_A_B_C_D(Suit, Number),
    write([Suit, Number]),
    write('\n').
