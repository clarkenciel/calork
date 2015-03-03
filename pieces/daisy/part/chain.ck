public class ChainOut extends Chugen {
    OscOut dests[0];

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

        in.addAddress( "/disconnect" );
        in.addAddress( "/connect" );
        in.addAddress( "/tog" );
        while( true ) {
            in => now;
            while( in.recv(msg) ){
                if( msg.address == "/disconnect" ) {
                    0 => size;
                    dests.size(size);

                } else if( msg.address == "/connect" ) {
                    dests.size() + 1 => size;
                    dests.size( size ); // increase array

                    new OscOut @=> dests[ size - 1 ]; // add new destination
                    dests[ size - 1].dest( msg.getString(0), port );

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
            if( dests.size() > 0 ) {
                for( int i; i < dests.size(); i ++ ) {
                    dests[i].start( "/chain, f" );
                    dests[i].add( sig );
                    dests[i].send();
                }
            }
        }
    }
}
