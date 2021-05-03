-module(primality).
-export([lastdigit/1, prime/1, primality/1, start/0, digitize/1, start_prime_checker/0, fac/1]).



digitize(N) when N < 10 -> N;
digitize(N) when N >= 10 -> digitize(digitize(N div 10) + N rem 10).

lastdigit(D) -> D rem 10.

prime(1) -> false;
prime(2) -> true;
prime(3) -> true;
prime(5) -> true;
prime(7) -> true;

% prime(P) when digitize(P) == 9 -> false;

prime(P) ->
	D=digitize(P),
	% io:fwrite("digitize of ~p is ~p~n", [P, D]),
	% case D of
	% 	{D} when D == 9 -> false;
	% 	{D} when D < 9 -> io:fwrite("call prime of ~p~n", [P]),
	% if
	% 	P rem 2 == 0 -> false;
	% 	% P rem 10 == 1 -> io:fwrite("will call next~n"), prime(P, P-1);
	% 	P rem 10 == 1 -> prime(P, P-1);
	% 	P rem 10 == 3 -> prime(P, P-1);
	% 	P rem 10 == 5 -> false;
	% 	P rem 10 == 7 -> prime(P, P-1);
	% 	P rem 10 == 9 -> prime(P, P-1);
	% 	true -> nil
	% end
	% end.
	DIV = trunc(math:sqrt(P))*2+1,
	if
		P rem 2 == 0 -> false;
		P rem 10 == 5 -> false;
		true ->
			if
				% D == 9 -> io:fwrite("digitize of ~p is ~p~n", [P, D]), false;
				D == 9 -> false;
				% P rem 10 == 1 -> io:fwrite("will call next~n"), prime(P, P-1);
				P rem 10 == 1 -> prime(P, DIV);
				P rem 10 == 3 -> prime(P, DIV);
				P rem 10 == 7 -> prime(P, DIV);
				P rem 10 == 9 -> prime(P, DIV);
				true -> nil
			end
	end.

% prime(P, D) -> io:fwrite("/2:will divide ~p rem ~p and counter 0~n", [P, D]), prime(P, D, 0).
prime(P, D) -> prime(P, D, 0).

prime(_, _, 1) -> false;
prime(_, 1, _) -> true;
prime(P, D, C) ->
	if
		% P rem D == 0 -> io:fwrite("/3:true:will divide ~p rem ~p and counter:~p~n", [P, D-1, C+1]), prime(P, D-1, C+1);
		% true -> io:fwrite("/3:false:will divide ~p rem ~p and counter:~p~n", [P, D-1, C]), prime(P, D-1, C)
		P rem D == 0 -> prime(P, D-2, C+1);
		true -> prime(P, D-2, C)
	end.

forp(0, C) -> C;
forp(N, C) when N > 0 ->
	% io:fwrite("~p:\t~w~n", [N, prime(N)]),
	PP = prime(N),
	if
		% PP == true -> io:fwrite("~p:\t~w~n", [N, prime(N)]), forp(N-1, C+1);
		PP == true -> forp(N-1, C+1);
		true -> forp(N-1, C)
	end.

% Not working 
start() ->
	LP = init:get_argument(primer),
	Function = fun(P) -> io:fwrite("~p~n", [primality(P)]) end,
	lists:foreach(Function, LP),
	
	% io:fwrite("~p~n", [primality(P)]),
	init:stop().

primality([P])
	% -> primality(erlang:list_to_integer(atom_to_list(P))) ;
	-> io:fwrite("~p~n", [primality(list_to_integer(atom_to_list(P)))]),
	init:stop();
primality(P)
	when erlang:is_list(P) -> primality(erlang:list_to_integer(P)) ;
primality(P)
	-> PP = P,
	% Checker = spawn(fun() -> start_prime_checker() end),
	forp(PP, 0).

fac([N]) ->
    X = fac(list_to_integer(atom_to_list(N))),
    io:format("~p~n", [X]);
fac(0) -> 1;
fac(N) -> N * fac(N-1).




%%%%%%%%%%%%%%%%%%%%%%
forp_spawn(P, D) ->
	Self = self(),       % The spawned funs need a Pid to send to, use a closure
	Ppsp = spawn(fun() -> Self ! {self(), forp(P, D)} end),
	wait_for_response(Ppsp, 0).

wait_for_response(undefined, Prime) ->
	Prime;
wait_for_response(Ppsp, Prime) ->
	receive
		{Ppsp, V} -> wait_for_response(undefined, Prime+V)
	end.

prime_spawn(P) ->
	Self = self(),       % The spawned funs need a Pid to send to, use a closure
	Ppsp = spawn(fun() -> Self ! {self(), prime(P)} end),
	wait_for_response_p(Ppsp, 0).

% wait_for_response_p(undefined, Prime) ->
% 	Prime;
wait_for_response_p(undefined, [Prime|_]) ->
	Prime;

wait_for_response_p(Ppsp, Prime) ->
	receive
		{Ppsp, P} -> wait_for_response_p(undefined, [P|Prime])
	end.

%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%
start_prime_checker() ->
	% register(prime, spawn(primality, prime, P)).
	receive
		P ->
			prime(P),
			start_prime_checker()
	end.

% prime_message(P) ->
% 	prime_message(P, Node).

% prime_message(P, Node) ->

% prime_checker(P) ->

%%%%%%%%%%%%%%%%%%%%%%
