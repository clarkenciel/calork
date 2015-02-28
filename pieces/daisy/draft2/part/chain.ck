public class ChainOut extends Chugen {
    OscIn in;
    OscMsg msg;
    OscOut out;
    string dest;
    57120 => int port;

    in.port( 57121 );
    in.listenAll();

    fun float tick( float in ) {
        if( dest != "localhost" && dest != "" ) {
            out.dest( dest, port );
            out.start( "/chain, f" );
            out.add( in );
            out.send();
        }
        return in;
    }

    fun void listen() {
        while( true ) {
            in => now;
            while( in.recv(msg) ){
                if( msg.address == "/disconnect" || msg.address == "/connect" ) {
                    msg.getString(0) => dest;
                }
            }
        }
    }

}
