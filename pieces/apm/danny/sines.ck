// sines.ck
// sine waves for APM
// Author: Danny Clarke
0.1 => float sqFreq;
0.1 => float sqGain;
200 => float sFreq;

SinOsc s[10];
ADSR a => JCRev j => Gain master => dac;
SinOsc sq => blackhole;

for( int i; i < s.size(); i ++ ) {
    s[i] => a;
    s[i].freq( sFreq + (i * 10) );
    s[i].gain( 0.4 );
}


master.gain( 0.4 );
j.mix( 0.05 );
a.set(20::ms, second,0.3,10::ms);
sq.freq(sqFreq);
sq.gain(sqGain);

spork ~ listen();
//spork ~ sndTest();
while( ms => now );

fun void listen() {
    OscIn in;
    OscMsg m;
    in.port( 57120 );
    in.listenAll();

    int leftClicks, rightClicks;
    float mouseX;

    while( true ) {
        in => now;
        while( in.recv(m) ) {
            //<<< m.address,"">>>;
            if( m.address == "/eric" ) {
                if( m.getString(0) == "/mx" ) {
                    //<<< "move","">>>;
                    for( int i; i < s.size(); i ++ ) 
                        s[i].freq() + (i * m.getFloat(1) ) => s[i].freq;
                }
                if( m.getString(0) == "/mltotal" ) {
                    //<<< "click l","">>>;
                    leftClicks++;                    
                    spork ~ mod( sqGain, sqFreq );
                }
                if( m.getString(0) == "/mrtotal" ) {
                    //<<< "click r","">>>;
                    rightClicks++;
                    for( int i; i < s.size(); i ++ ) {
                        s[i].freq( sFreq + (i*10));
                    }
                    //spork ~  mod( sqGain, sqFreq );
                }
            }
        }
    }
}

fun void sndTest() {
    int choice;
    float mx;
    OscOut o;
    o.dest( "localhost", 57120 );

    while( 50::ms => now ) {
        Math.random2( 0, 2 ) => choice;
        Math.random2f( 0.0, 10.0 ) => mx;
        if( choice == 0  ) {
            o.start("/eric").add("/mx").add(mx).send();
        } else if( choice == 1 ) {
            o.start("/eric").add("/mltotal").add(1.0).send();
            second => now;
        } else if( choice == 2 ) {
            o.start("/eric").add("/mrtotal").add(1.0).send();
            second => now;
        }
    }
}

fun void mod( float gain, float freq ) {
        a.keyOff(1);
        for( int i; i < s.size(); i++ ) {
            s[i].gain( 0.2 );
        }
    
        sq.gain( gain );
        sq.freq( freq );
        while( sq.gain() > 0.0 ) {
            for( int i; i < s.size(); i ++ ) {
                Math.fabs(s[i].gain() * sq.gain()) / s.size() => s[i].gain;
            a.keyOn(1);
            sq.gain() - 0.05 => sq.gain; 
            sq.freq() - 10 => sq.freq;
            (sFreq)::ms => now;
        }
        a.keyOff(1);
        for( int i; i < s.size(); i++ ) {
            s[i].gain( 0.2 );
        }
    }
}
