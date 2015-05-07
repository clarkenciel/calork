OSCOscIn in[2];
in[0].setAddr("/one, f");
in[1].setAddr("/two, f");

20 => float q;
400 => float f;
Pan2 p[2];
BPF b => dac;
NRev r => dac;
b.set( f, q );
r.mix( 0.2 );

for( 0 => int i; i < in.cap(); i ++ ) {
    in[i] => p[i];
    p[i].pan( ((2/(in.cap()-1)) * i) - 1.0 );
}

p[0] => b;
p[1] => r;

OSCOscOut out;
out.setAddr("/null, f");

// SNDBUF SETUP 
SndBuf sb => blackhole;
int c;

me.dir() + "snd.wav" => string file;
<<< file >>>;
file => sb.read;
sb.samples() => int len;
sb.rate( 1.0 );
sb.gain( 0.5 );
sb.pos( 0 );

// PROGRAM

spork ~ out.send( sb );
for( 0 => int i; i < in.cap(); i++ ) {
    spork ~ in[i].listen();
}
spork ~ change();
spork ~ bpfUpdate();
while( ms => now );

// FUNCS

fun void change() {
    KBHit k;
    "/one, f" => string a1;
    "/two, f" => string a2;
    while( true ) {
        k => now;
        while( k.more() ) {
            k.getchar() => int K;
            <<< K >>>;
            if( K == 49 ) out.setAddr( a1 );
            if( K == 50 ) out.setAddr( a2 );
        }
        <<< out.addr >>>;
    }
}

fun void bpfUpdate() {
    Hid m;
    HidMsg msg;
    m.openMouse(0);
    while( samp => now ) {
        while( m.recv( msg ) ) {
            if( msg.isMouseMotion() ) {
                Math.fabs( msg.x ) * 10 => q;
                Math.fabs( msg.y ) * 100 => f;
            }
        }
        b.set( f, q );
    }
}
            
