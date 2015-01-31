(
// ensemble "class"
~ensemble = {
	| members, ips, params |
	var m = members;
	var i = ips;
	var p = params;

	(
		// public functions
		receive: {
			|member, param, value|
		},
		send: {
			|member, param, value|
		},
		get_param: {
			|param|
		}
	)

	// private functions
	var set_mems={};
	var set_ips={};
	var set_params={};
	var add_param={};
	var add_ip={};
	var add_mem={};
};
)