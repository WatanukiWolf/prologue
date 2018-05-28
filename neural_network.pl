sigmoid(X, Ans):-
    Ans is 1 / (1 + exp(-X)).

input(X):-
    member(Number, [-10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0,
                    1, 2, 3, 4, 5, 6, 7, 8, 9, 10]),
    X is Number / 10.

output_of_secret_one(Weight, Bias, Input, Output):-
    input(Input),
    X is Input * Weight + Bias,
    sigmoid(X, Output).

output_of_secret_two(Weight, Bias, Input, Output):-
    output_of_secret_one(Weight, Bias, Input, Output).

output(W1_11, W1_21, W1_31, W2_11, W2_12, W2_21, W2_22, Input, Output):-
    input(Input),
    output_of_secret_one(W2_11, W2_21, Input, O1),
    output_of_secret_two(W2_12, W2_22, Input, O2),
    X is W1_11 * O1 + W1_21 * O2 + W1_31,
    sigmoid(X, Output).

expected(Input, Expected):-
    Expected is Input * Input.

loss_function(Input, Output, Ans):-
    expected(Input, Expected),
    Ans is (Output - Expected) * (Output - Expected).

run_neural_network(List, Loss):-
    length(List, 7),
    [W1_11, W1_21, W1_31, W2_11, W2_12, W2_21, W2_22] = List,
    output(W1_11, W1_21, W1_31, W2_11, W2_12, W2_21, W2_22, Input, Output),
    loss_function(Input, Output, Loss).
