-module(fluentd_sup).
-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).

%%====================================================================
%% API
%%====================================================================
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================
init([]) ->
    Children = [{fluentd, {fluentd_client, start_link, []},
                permanent, 5000, worker, [fluentd]} ],
    {ok, { {one_for_one, 10, 10}, Children} }.    

