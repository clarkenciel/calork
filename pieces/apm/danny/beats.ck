// beats.ck
// rhythmic sounds for APM
// Author: Danny Clarke

OscIn in;
OscMsg m;
in.port( 57120 );
in.listenAll();

100 => float temp;
int shredCount;

spork ~ listen();
//spork ~ sndTest();
while( ms => now );

fun void listen() {
    while( true ) {
        in => now;
        while( in.recv(m) ) {
            if( m.address == "/eric" ) {
                //<<< m.address, m.getString(0), m.getFloat(1) ,"">>>;

                if( m.getString(0) == "/atotal" ||
                    m.getString(0) == "/vtotal" ||
                    m.getString(0) == "/btotal")
                {
                    if( shredCount < 10 && m.getFloat(1) > 0 ) {
                        spork ~ play( temp::ms, m.getFloat(1) );
                        shredCount++;
                    }
                }
            }
            if( m.getString(0) == "/mmapm" && m.getFloat(1) > 0 ) {
                m.getFloat(1) => temp;
                while( temp < 50 ) {
                    5 *=> temp;
                }
            }

        }
    }
}

fun void play( dur tempo, float reps ) {
    <<< "\tplaying beats:", me.id(), "">>>;
    Noise n => BPF b => ADSR a => JCRev j => dac;

    Math.random2f( 20, 1000 ) => float freq;
    Math.random2f( 1, 10 ) => float Q;
    Q * 10 => float goalQ;
    freq * 10 => float goalF; 
    float diff;
    float step;
    
    b.set(freq, Q);
    a.set(15::ms, 50::ms, 0, 0::ms);
    j.mix( 0.1 );
    
    1.0 => float mod;

    for( int i; i < reps; i++ ) {
        // bpf Q
        goalQ - b.Q() => diff;
        diff / (reps - i) => step;
        b.Q() + step => b.Q;
        
        // bpf freq
        goalF - b.freq() => diff;
        diff / (reps-i) => step;
        b.freq() + step => b.freq;
        
        // bpf gain
        1.0 / i+1 => mod;
        b.gain(mod);
        
        // play
        a.keyOn(1);
        tempo => now;
    }
    (tempo * 2) => now;

    // clean up
    j =< dac;
    a =< j;
    b =< a;
    n =< b;
    NULL @=> n; NULL @=> b; NULL @=> a; NULL @=> j; 
    
    shredCount--; // adjust manager
}

fun void sndTest() {
    int choice;
    float mx;
    OscOut o;
    o.dest( "localhost", 57120 );

    while( 50::ms => now ) {
        Math.random2( 0, 3 ) => choice;
        Math.random2f( 0.0, 10.0 ) => mx;
        if( choice == 0  ) {
            o.start("/eric").add("/atotal").add(mx).send();
            (mx*100)::ms => now;
        } else if( choice == 1 ) {
            o.start("/eric").add("/vtotal").add(mx).send();
            (mx*100)::ms => now;
        } else if( choice == 2 ) {
            o.start("/eric").add("/btotal").add(mx).send();
            (mx*100)::ms => now;
        } else if( choice == 3 ) {
            o.start("/eric").add("mmapm").add(mx).send();
            (mx*10)::ms => now;
        }
    }
}
