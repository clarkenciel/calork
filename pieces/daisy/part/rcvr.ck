public class Rec extends Chugen {
    float sig;

    fun float tick( float in ) {
        return sig;
    }

    fun void listen() {
        OscIn in;
        OscMsg msg;
        in.port( 67120 );
        in.listenAll();

        while( true ) {
            in => now;
            while( in.recv( msg ) ) {
                if( msg.address == "/sig" || msg.address == "/chain" ) {
                    msg.getFloat(0) => sig;
                }
            }
        }
    }
}
