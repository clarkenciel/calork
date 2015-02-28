OSCOscIn in;
OSCOscOut out;

in => BPF b => Gain g => Delay d => dac;
SinOsc s => blackhole;
dac => Pan2 p => WvOut2 w => blackhole;

s.freq( 1 );
s.gain( 500 );
g.gain( 0.9 );
d.max( 100::ms );

d.delay( 100::ms );
"chuck-stereo" => w.autoPrefix;
"special:auto" => w.wavFilename;
<<< "writing to file:", "'"+w.filename()+"'">>>;

spork ~ out.send( adc );
spork ~ in.listen();
spork ~ bpfMod();
null @=> w;
while( ms => now );

fun void bpfMod() {
    while( samp => now ) {
        b.set( s.last() + 1001, (Math.fabs( s.last() ) / 50) + 1 );
        p.pan( s.last() / 500.0 );
    }
}
