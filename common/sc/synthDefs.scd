(
SynthDef( \nSweep, {
	|fLo=100, fHi=1000, rate=1, amp=0.5|
	var shape, sig, out;
	shape = SinOsc.kr( rate, mul: fHi - fLo );
	sig = BrownNoise.ar();
	out = BPF.ar( sig, shape + (fHi - fLo), 0.2, amp );

	Out.ar( 0, out );
}).add;
)

Synth(\nSweep);