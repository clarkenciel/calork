OSCOscIn in[3];
OSCOscOut out[3];

in[0].setAddr("/net/one, f");
in[1].setAddr("/net/two, f");
in[2].setAddr("/net/three, f");

out[0].setAddr("/net/two, f");
out[1].setAddr("/net/three, f");
out[2].setAddr("/net/one, f");

in[0] => blackhole;
in[1] => blackhole;
in[2] => blackhole;
in[2] => dac;
dac => WvOut w => blackhole;
"walkie2" => w.wavFilename;

SinOsc s;
s.gain( 0.2 );
in[2] => s;
2 => s.sync;

for( 0 => int i; i < in.cap(); i++ ) {
    in[i].gain( 0.5);
}

spork ~ out[0].send( in[0] );
spork ~ out[1].send( in[1] );
spork ~ out[2].send( in[2] );
spork ~ out[2].send( s );
spork ~ in[0].listen();
spork ~ in[1].listen();
spork ~ in[2].listen();
null @=> w;
while( ms => now );
