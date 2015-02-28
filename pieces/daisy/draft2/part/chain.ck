public class ChainOut extends Chugen {
    OscIn in;
    OscMsg msg;
    OscOut out;
    string dest;
    float sig;
    1 => int first;
    57120 => int port;

    in.port( 57121 );
    in.listenAll();

    fun float tick( float in ) {
        in => sig;
        return in;
    }

    fun void listen() {
        while( true ) {
            in => now;
            while( in.recv(msg) ){
                if( msg.address == "/disconnect" || msg.address == "/connect" ) {
                    msg.getString(0) => dest;
                    out.dest( dest, port );
                    1 => first;
                }
            }
        }
    }

    fun void send() {
        while( samp => now ) {
            if( dest != "localhost" && dest != "" ) {
                out.start( "/chain, f" );
                out.add( sig );
                out.send();
            }
        }
    }
}
