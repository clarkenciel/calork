s.boot;
(
// SET UP PORTS
~addr = NetAddr.langPort;
~data = "/danny/data";
~freq = "/danny/freq";
~amp = "/danny/amp";
)
(
// SET UP ADDRESSES
~sh = NetAddr( "169.254.74.231", ~addr );
~justinSC = NetAddr( "169.254.87.91", ~addr );
~justinMAX = NetAddr( "169.254.87.91", ~addr );
~ed = NetAddr( "169.254.24.203", ~addr);
~eric = NetAddr( "169.254.249.113", ~addr );
~mike = NetAddr( "169.254.55.120", ~addr );
)
(
// SEND SINGLE MESSAGES
~sh.sendMsg(~addr, 10.0);
~justinSC.sendMsg(~addr, 10.0);
~justinMAX.sendMsg(~addr, 10.0);
~ed.sendMsg(~addr, 10.0);
~eric.sendMsg(~data, 10.0);
~mike.sendMsg(~data, 10.0).postln;
)

(
// LOOP SEND
t = Task.new({
	inf.do({
		~ed.sendMsg(~data, 10.0);
		~eric.sendMsg(~data, 10.0);
		~mike.sendMsg(~data, 10.0);
		~sh.sendMsg(~data, 10.0);
		~justinSC.sendMsg(~data, 10.0);
		~justinMAX.sendMsg(~data, 10.0);
		"send".postln;
		1.wait;
	});
}).start;
)

(
// RECEIVE
OSCFunc.newMatching({
	|msg, time, addr, recvPort|
	msg[1].postln;
}, '/justin /data');
OSCFunc.newMatching({
	|msg, time, addr, recvPort|
	msg[1].postln;
}, '/ed');
OSCFunc.newMatching({
	|msg, time, addr, recvPort|
	msg[1].postln;
}, '/shaurjya /data');
OSCFunc.newMatching({
	|msg, time, addr, recvPort|
	msg[1].postln;
}, '/eric /data');
)