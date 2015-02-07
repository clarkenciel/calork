(
// ensemble "class"
~ensemble = {
	| members, ips, params |
	var m = members;
	var i = ips;
	var p = params;

	(
		// public functions
        // listen for events from variety of members and parameters
		receive: {
			|member, params, store, value|
			OSCFunc.newMatching({
				|msg, time, addr, recvPort|


			});
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
	var add_mem={
        | member |


    };
    var make_listener{};
};
)
(
d = (
    port: NetAddr.langPort, members: Dictionary.new, params: Dictionary.new,

    new: {
        |self, members|
        self.members.putAll( members );
    },
    send: {},
    receive: {}
);
d.new([eric: "169.123.123.1"]);
d.members.at(\eric).postln;
)

(
d = (hello: 9, whello: 77, z: 99);
d.getPairs;
)