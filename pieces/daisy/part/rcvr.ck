public class Rec extends Chugen {
    float sig;

    fun float tick( float in ) {
        return sig;
    }

    fun void listen( string name ) {
        OscIn in;
        OscMsg msg;
        in.port( 47120 );
        in.addAddress( "/sig" );

        while( true ) {
            in => now;
            while( in.recv( msg ) ) {
                if( msg.address == "/sig" && msg.getString(0) != name ) {
                    msg.getFloat(1) +=> sig;
                }
            }
        }
    }
}
