-module(fluentd).
-export([send/2]).
-define(WORKER, fluentd_client).

%%%===================================================================
%%% API
%%%===================================================================

%% Label in format "prefix.dbname.tablename" - the prefix must match your td-agent.conf/fluent.conf file
%% RawData is the data you want sent in format {[{key, value}]}
send(Label, RawData) -> 
    gen_server:cast(?WORKER, {send, Label, RawData}).

