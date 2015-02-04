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
var new_method;
var test = {
	| a, b, c|
	var one = a;
	var two = b;
	var three = c;

	var methods = (
        get_one: one,
        get_two: two,
        get_three: three
    ).value();

    var addMethod = {
        |name, value|
        methods.name = value;
    };

    (
        methods: methods,
        addMethod: { |new| addMethod( new.getPairs(0), new.getPairs(1) ); }
    )
};

t = test.value(1, 2, 3);
t.methods.addMethod.value( [newmethod: {|i, j| postln(j) }]  );
t.methods.newmethod.value(2,2);

)

(
a = Dictionary.new;
a.add( b -> 0 ).postln;
a.add( f -> {
    |input|
    postln( input );
});
a.at( b ).postln;
a.at( f ).value( 3 );
)





( // stream demo for Zoe
e = ( a: "b", c: "d", e: "f" ).value();
)