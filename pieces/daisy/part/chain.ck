public class ChainOut extends Chugen {
    OscIn in;
    OscMsg msg;
    OscOut out;
    string dest;
    float sig;
    0 => float tog;
    67120 => int port;

    in.port( 67121 );
    in.listenAll();

    fun float tick( float in ) {
        float out;
        in => sig;
        in * tog => out;
        return out;
    }

    fun void listen() {
        while( true ) {
            in => now;
            while( in.recv(msg) ){
                if( msg.address == "/disconnect" || msg.address == "/connect" ) {
                    msg.getString(0) => dest;
                    out.dest( dest, port );
                } else if( msg.address == "/tog" ) {
                    if( tog > 0 ) {
                        0 => tog;
                        <<< "\n\tYou have been silenced. You can still affect your fellows, however.\n","" >>>;
                    } else {
                        1 => tog;
                        <<< "\n\tYou're voice has been restored!","">>>;
                    }
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
