public class ChainOut extends Chugen {
    OscOut oOut;
    string dest;

    float sig;

    0 => float tog;
    47120 => int port;
    
    fun float tick( float in ) {
        float out;
        in => sig;
        in * tog => out;
        return out;
    }

    fun void listen( OscIn in) {
        int size; OscMsg msg;

        while( true ) {
            in => now;
            while( in.recv(msg) ){
                if( msg.address == "/disconnect" ) {
                    "" => dest;      
                } else if( msg.address == "/connect" ) {
                    msg.getString(0) => dest;
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

    fun void send( string name ) {
        while( samp => now ) {
            if( dest != "" ) {
                oOut.dest( dest, 47120 ); 
                oOut.start( "/sig" );
                oOut.add( name );
                oOut.add( sig );
                oOut.send();
            }
        }
    }
}
