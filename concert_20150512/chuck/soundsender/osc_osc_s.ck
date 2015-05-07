public class OSCOscOut  {
    OscOut out;
    "/net, f" => string addr;
    "localhost" => string ip;
    7000 => int port;

    out.dest( ip, port );

    // simply pass in a ugen and spork this
    fun void send( UGen g ) {
        g => blackhole;
        while( samp => now ) {
            out.start( addr );
            out.add( g.last() );
            out.send();
        }
    }
    // overload above
    fun void send( Chugen g ) {
        g => blackhole;
        while( samp => now ) {
            out.start( addr );
            out.add( g.last() );
            out.send();
        }
    }

    fun void send( SndBuf g ) {
        g => blackhole;
        g.samples() => int len;
        int c;
        while( samp => now ) {
            if( c == len ) {
                0 => g.pos;
                0 => c;
            }
            out.start( addr );
            out.add( g.last() );
            out.send();

            c++;
        }
    }

    fun void setServer( string s ) {
        s => ip;
        out.dest(ip, port);
    }

    fun void setPort( int p ) {
        p => port;
        out.dest(ip, port);
    }

    fun void setBoth( string s, int p ) {
        s => ip;
        p => port;
        out.dest( ip, port );
    }

    fun void setAddr( string a ) {
        a => addr;
    }
}

// TEST-----------------
WvIn s;
me.dir() + "snd.wav" => string f;
<<< f >>>;
//f => s.read;
f => s.path;
//s.samples() => int len;
//<<< len >>>;
s.rate(1.0);
<<< s.rate() >>>;
s => Gain g;
g.gain( 0.9 );

OSCOscOut o;
o.setServer("10.40.1.108");
//o.setBoth( "localhost", 57120 );
o.send( g );

while( ms => now );
/*
SndBuf s => Gain g => dac;
me.dir() + "snd.wav" => string file;
file => s.read;
s.rate( 1.0 );
s.gain( 0.9 );
s.pos( 0 );
OSCOscOut o;

o.setServer("10.40.1.108");

spork ~ o.send( g );
while( ms => now );
