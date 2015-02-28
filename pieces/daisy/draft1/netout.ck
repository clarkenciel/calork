SinOsc s2 => SinOsc s => ADSR a => dac;
SinOsc s3 => s;
s => s3 => s2;
s => s2;

Delay d2;
a => Delay d => Pan2 p;
p => d => d2 => Pan2 p2 => dac;

s3.freq( 700 );
s2.freq( 200 );
s.freq( 100);
s3.sync(2);
s2.sync(2);
s.gain( 0.5 );
s2.gain( 100 );
s3. gain( 110 );
a.set( 20::ms, 50::ms, 0.0, 0::ms );
d2.gain( 0.5 );
d.gain( 0.4 );
d.max(44100::samp);
d2.max(22050::samp);
d.delay( 10::ms );
d2.delay( 100::ms );
p.gain( 0.9 );
p2.gain(0.5);

int r;
[2, 3, 5, 7] @=> int multi[];
[-1, 1] @=> int pan[];

while( 110::ms => now ) {
    Math.random2( 1, 2 ) => r;
    //<<< r,"" >>>;
    s.op( r );
    s2.freq( s.freq() * multi[ Math.random2(0, multi.cap() - 1 ) ] );
    s3.freq( s.freq() * multi[ Math.random2(0, multi.cap() - 1) ] );
    if( maybe ) s2.sync(r);
    if( maybe ) s3.sync(r);
    if( maybe ) Math.pow( 2, pan[maybe] ) * s.freq() => s.freq;
    p2.pan( pan[maybe] ); 
    a.keyOn();
}
