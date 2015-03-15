public class ChainOut extends Chugen {
    OscOut oOut;
    "junk" => string dest;

    float sig;

    0 => float tog => float tmpTog;
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
                    "junk" => dest;      
                    oOut.dest( dest, 47120 ); 
                } else if( msg.address == "/connect" ) {
                    msg.getString(0) => dest;
                    oOut.dest( dest, 47120 ); 
                } else if( msg.address == "/tog" ) {
                    if( tog > 0 ) {
                        tog => tmpTog;
                        0 => tog;
                        <<< "\n\tYou have been silenced. You can still affect your fellows, however.\n","" >>>;
                    } else {
                        while( tog < tmpTog ) {
                            0.05 +=> tog;
                        }
                        <<< "\n\tYour voice has been restored!","">>>;
                    }
                }
            }
        }
    }

    fun void send( string name ) {
        while( samp => now ) {
            if( dest != "junk" ) {
                oOut.start( "/sig" );
                oOut.add( name );
                oOut.add( sig );
                oOut.send();
            }
        }
    }
}
