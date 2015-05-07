public class Speaker extends Chubgraph {
    Noise n => ResonZ b => ADSR a => Gain g => JCRev r;
    Delay d1;
    d1 => Delay d2 => d1;

    // VARS
    10 => float del;
    0.9 => float gn;
    50 => float vTime;
    time later;
    440 => float f;
    
    // SETUP
    d1.max( 44100::samp );
    d2.max( 44100::samp );
    d1.delay( del::ms );
    d2.delay( del::ms );
    r.mix( 0.05 );
    b.gain(0.9);
    d1.gain(0.9);
    d2.gain(0.9);

    fun void speak( string char ) {
        if( char == "perc" ) {
            g.gain(gn);
            a.set(15::ms, 30::ms, 0.0, 0::ms);
            a.keyOn(1);
        } else if( char == "noise" ) {
            g.gain(gn);
            b.Q(Math.random2( 1, 20 ));
            b.freq( Math.random2f( f-100, f+100 ) );
            a.keyOn(1);
        } else if( char == "soft" ) {
            g.gain(gn);
            a.set(vTime::ms, vTime::ms, 0.0, 0::ms);
            a.keyOn(1);
        } else if( char == "hum" ) {
            g.gain(gn);
            a.set( (vTime*2)::ms, (vTime*2)::ms, gn, 100::ms );  
            b.Q( 100 );
            a.keyOn(1);
            (vTime*4)::ms => now;
        } else if( char == "misc" ) {
            now + (vTime*4)::ms => later;
            while( now < later ) {
                (0.3/(vTime::ms/samp)) -=> gn;
                samp => now;
            }
            now + (vTime*4)::ms => later;
            while( now < later ) {
                (0.3/(vTime::ms/samp)) +=> gn;
                samp => now;
            }
        } else if( char == "vowel" ) {
            a =< g; 
            a => d1 => g;
            g.gain(gn);
            a.set( vTime::ms, vTime::ms,0.0, 0::ms );
            a.keyOn(1);
            now + vTime::ms => later;
            while( now < later ) {
                del + (10.0/(vTime::ms/samp)) => del;
                del::ms => d2.delay;
                del::ms => d1.delay;
                b.Q() + (10.0/(vTime::ms/samp)) => b.Q;
                samp => now;
            }
            now + vTime::ms => later;
            while( now < later ) {
                del - (10.0/(vTime::ms/samp)) => del;
                del::ms => d2.delay;
                del::ms => d1.delay;
                b.Q() - (10.0/(vTime::ms/samp))=> b.Q;
                samp => now;
            }
            d1 =< g;
            a =< d1;
            a => g;
        }
    }

    fun void connect( UGen _o ) {
        r => _o;
    }

    fun void disconnect( UGen _o ) {
        r =< _o;
    }

    fun float freq( float _f ) {
        _f => f;
        (0.05 / (f/10000) ) +=> gn;
        return f;
    }

    fun float gain( float _g ) {
        _g + (0.05 / (f/10000) ) => gn;
        return gn;
    }

    fun float vowSpeed( float _v ) {
        _v => vTime;
        return vTime;
    }
}

Speaker s; Pan2 p1 => dac;
Speaker s2; Pan2 p2 => dac;
p1.pan(-1); p2.pan(1);
s.connect( p1 ); s2.connect( p2 );
s.freq(200); s2.freq(1000);
["perc","noise","soft","hum","misc"] @=> string cmds[];

spork ~ play( s );
spork ~ play( s2 );
now + 30::second => time later;
while( now < later ) ms => now;
s.disconnect(p1);s2.disconnect(p2);

fun void play( Speaker s ) {
    int i, idx, idx2;
    2 => int meas;
    while( true ) {
        if( i%meas != 0 )  {
            Math.random2(0, cmds.cap()-1) => idx;
            s.speak( cmds[idx]);
            Math.random2( 2, 10 ) => meas;
        } else {
            s.speak( "vowel"  );
        }
        i++;
    }
}
