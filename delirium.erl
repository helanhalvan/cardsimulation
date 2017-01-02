-module(delirium).

-export([simulate/2]).

-compile(export_all).

test()->
    {simulate_many_delirium([{lands, 24}, {creatures,19}, {e,4}, {i,4}, {s,3}, {a,3}, {p,3}],16,100000),
    simulate_many_delirium([{lands, 24}, {creatures,19}, {e,7}, {i,7}, {s,1}, {a,1}, {p,1}],16,100000),
    simulate_many_delirium([{lands, 24}, {creatures,19}, {e,6}, {i,6}, {s,5}],16,100000),
    simulate_many_delirium([{lands, 24}, {creatures,19}, {e,7}, {i,5}, {s,5}],16,100000),
    simulate_many_delirium([{lands, 24}, {creatures,19}, {e,4}, {i,4}, {s,4}, {a,5}],16,100000)}.
    %{simulate_many([{lands, 24}, {creatures,19}, {e,5}, {i,5}, {s,6}, {p,1}],8,100000),
    %simulate_many([{lands, 24}, {creatures,19}, {e,4}, {i,4}, {s,5}, {a,3}, {p,1}],8,100000),
    %simulate_many([{lands, 24}, {creatures,19}, {e,4}, {i,4}, {s,4}, {a,3}, {p,2}],8,100000),
    %simulate_many([{lands, 24}, {creatures,19}, {e,5}, {i,5}, {s,7}],8,100000)}.
    % GW deck sum([{lands, 24}, {creatures,19}, {e,4}, {i,4}, {s,5}, {a,3}, {p,1}]).
    %sum([{lands,24},{creatures,24},{s,4},{i,4},{p,4}]).
    %simulate([{lands,4},{creatures,4},{s,4},{i,4},{p,4}],20).

test2()->{simulate_many_landhits([{land, 29},{other,31}],100000),
          simulate_many_landhits([{land, 28},{other,32}],100000),
          simulate_many_landhits([{land, 27},{other,33}],100000),
          simulate_many_landhits([{land, 26},{other,34}],100000),
          simulate_many_landhits([{land, 25},{other,35}],100000),
          simulate_many_landhits([{land, 24},{other,36}],100000),
          simulate_many_landhits([{land, 23},{other,37}],100000),
          simulate_many_landhits([{land, 22},{other,38}],100000),
          simulate_many_landhits([{land, 21},{other,39}],100000),
          simulate_many_landhits([{land, 20},{other,40}],100000)}.

test3()->{many_good_hand([{land, 29},{other,31}],100000),
          many_good_hand([{land, 28},{other,32}],100000),
          many_good_hand([{land, 27},{other,33}],100000),
          many_good_hand([{land, 26},{other,34}],100000),
          many_good_hand([{land, 25},{other,35}],100000),
          many_good_hand([{land, 24},{other,36}],100000),
          many_good_hand([{land, 23},{other,37}],100000),
          many_good_hand([{land, 22},{other,38}],100000),
          many_good_hand([{land, 21},{other,39}],100000),
          many_good_hand([{land, 20},{other,40}],100000)}.



%returns the top N cards drawns from deck A
%Deck format [{type,Quantity},...]
simulate(A,N)->
    simulate(A,N,[]).

simulate(_,0,Done)->Done;
simulate(Deck,N,Done)->
    H=sum(Deck),
    C=rand:uniform(H),
    {Card,D2}=draw(C,Deck),
    simulate(D2,N-1,[Card|Done]).

sum(L)->
    sum(L,0).

sum([],N)->N;
sum([{_,H}],N)->H+N;
sum([{_,H}|T],N)->sum(T,H+N).

draw(C,L)->draw(C,L,[]).

draw(C,[{_,0}|T],L) -> draw(C,T,L);
draw(C,[{W,H}|T],L) when H>=C, H>1-> {W,L++[{W,H-1}|T]};
draw(C,[{W,H}|T],L) when H>=C, H==1-> {W,L++T};
draw(C,[{_,D}=H|T],L) -> draw(C-D,T,L++[H]).

simulate_many_landhits(A,N)->
    simulate_many_landhits(A,N,[]).

%returns list [{Lands_droped,Occurances},....]
simulate_many_landhits(_,0,List)->[H|_]=lists:sort(fun({A,_},{B,_})-> B>A end ,List),H;
simulate_many_landhits(A,N,List)->
    Q=simulate_landhits(A),
    simulate_many_landhits(A,N-1,add(Q,List)).

many_good_hand(A,N)->
    many_good_hand(A,N,[]).

%returns list [{Lands_droped,Occurances},....]
many_good_hand(_,0,List)->H=lists:sort(fun({_,A},{_,B})-> A>B end ,List),H;
many_good_hand(A,N,List)->
    Q=good_hand(A,7),
    many_good_hand(A,N-1,add(Q,List)).

good_hand(A,4)->{simulate_landhits(A,4,0,4),4};

good_hand(A,N)->
    case simulate_landhits(A,N,0,N) of
        W when W>1 -> {W,N};
        _W -> good_hand(A,N-1)
    end.

simulate_landhits(A)->
    simulate_landhits(A,7,0,7). %starting hand of 7 cards, starting with 0 lands and

simulate_landhits(_,0,N,S)->N-S; %number of turns we can land drop

simulate_landhits([],_,N,S)->N-S; %all cards in deck

simulate_landhits(Deck,N,N2,S)->
    H=sum(Deck),
    C=random:uniform(H),
    {Card,D2}=draw(C,Deck),
    case Card of
        land -> simulate_landhits(D2,N,N2+1,S);
        _ -> simulate_landhits(D2,N-1,N2+1,S)
    end.

simulate_many_delirium(A,N,N2)->
    simulate_many_delirium(A,N,N2,0).

simulate_many_delirium(_A,_N,0,R)->R;

simulate_many_delirium(A,N,N2,R)->
     %simulate_many(A,N,N2-1,R+types(simulate(A,N))).
     case types(simulate(A,N)) of
            Q when Q>=4 -> simulate_many_delirium(A,N,N2-1,R+1);
            _ -> simulate_many_delirium(A,N,N2-1,R)
     end.

types(L)->types(L,[],0).
types([],_,N)->N;
types([H|T],L,N)->
      case is_in(H,L) of
        true -> types(T,L,N);
        false -> types(T,[H|L],N+1)
      end.

is_in(_A,[])->false;
is_in(A,[A|_T])->true;
is_in(A,[_H|T])->is_in(A,T).

add(I,[])->[{I,1}];
add(I,[{I,N}|T])->[{I,N+1}|T];
add(I,[H|T])->[H|add(I,T)].
