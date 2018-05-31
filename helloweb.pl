:- use_module(library(http/thread_httpd)).

:- use_module(library(http/http_dispatch)).

server(Port):-
    http_server(http_dispatch, [port(Port)]).

:- http_handler(/, say_hi, []).

say_hi(_Request) :-
    format('Content-type: text/html~n~n'),
    format('<html>\c
        <head>\c
            <title>Howdy</title>\c
        </head>\c
        <body>\c
            <h2>A Simple Web Page</h2>\c
            <p>With some text.</p>\c
        </body>\c
        </html>~n').
    %format(_Request).
:- server(8000).