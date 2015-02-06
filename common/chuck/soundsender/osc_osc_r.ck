public class OSCOscIn extends Chugen {
    OscIn in;
    OscMsg msg;
    0.0 => float OSCVal;
    "/net, f"  => string addr;
    int port;

    setPort( 7000 );
    in.addAddress( addr );

    fun float tick( float in ) {
        return OSCVal;
    }

    fun void listen() {
        while( true ) {
            in => now;
            while( in.recv( msg ) ) {
                msg.getFloat(0) => OSCVal;
            }
        }
    }

    fun void set( string a, int p ) {
        a => addr;
        p => port;
        in.addAddress( addr );
        in.port( port );
    }

    fun void setAddr( string a ) {
        a => addr;
        in.addAddress( addr );
    }

    fun void setPort( int p ) {
        p => port;
        in.port( port );
    }
}


//TEST----------------
/*
OSCOscIn i => dac;

spork ~ i.listen();
while( ms => now );
