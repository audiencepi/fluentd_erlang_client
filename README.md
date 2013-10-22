Fluentd Erlang Client

# How it works
To get started, you need to set your environment variables

	application:set_env(fluentd, fluentd_host, "127.0.0.1"),
	application:set_env(fluentd, fluentd_port, 24224),
	application:start(fluentd).



To send data, see below for an example.
	
	%% fluentd:send(<<"prefix.dbname.tablename">>, Data).
	Data = {[{<<"userid">>, <<"111">>},{<<"counter">>, <<"1">>}]},
	fluentd:send(<<"td.website1.statistics">>, Data).


Note that the prefix must match your td-agent/fluent conf file. For example for the above example, it would match the conf below.


	<match td.*.*>
	  type tdlog
	  apikey "yourapikey"
	</match>


Update your own dependencies in rebar if you need to.