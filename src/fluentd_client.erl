-module(fluentd_client).
-behaviour(gen_server).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, {host, port, sock}).

%%====================================================================
%% API
%%====================================================================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% ===================================================================
%% gen_server callbacks
%% =================================================================== 
init([]) ->
    Host = get_env(fluentd_host, "127.0.0.1"),
    Port = get_env(fluentd_port, 24224),
    {ok, Sock} = gen_tcp:connect(Host, Port, [binary, {packet, 0}]),
    {ok, #state{host=Host, port=Port, sock=Sock}}.
    
handle_cast({send, Label, RawData}, State = #state{sock = Sock}) ->
    TimeStamp = get_unix_timestamp(),
    RawLogs = [Label, TimeStamp, RawData], 
    MsgLogs = msgpack:pack(RawLogs),
    gen_tcp:send(Sock, MsgLogs),
    {noreply, State}.

handle_call(_Other, _From, State) ->
    {reply, ok, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Helpers/Private
%%%===================================================================
get_unix_timestamp() ->
    {Msec,Sec,_} = erlang:now(),
    Timestamp = (Msec * 1000000) + Sec,
    Timestamp.
    
get_env(Key) ->
    get_env(Key, undefined).

get_env(Key, Default) ->
    case application:get_env(fluentd, Key) of
        {ok, Value} -> Value;
        undefined -> Default
    end.
