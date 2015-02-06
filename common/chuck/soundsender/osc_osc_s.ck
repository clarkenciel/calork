public class OSCOscOut  {
    OscOut out;
    "/net, f" => string addr;
    "localhost" => string ip;
    7000 => int port;
    float val;

    out.dest( ip, port );

    fun void send() {
        while( samp => now ) {
            out.start( addr );
            out.add( val );
            out.send();
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
/*
SinOsc s => blackhole;
s.gain( 0.5 );
s.freq( 1000 );
OSCOscOut o;

spork ~ calc();
spork ~ o.send();
while( ms => now );

fun void calc() {
    while( samp => now ) {
        s.last() => o.val;
    }
}
