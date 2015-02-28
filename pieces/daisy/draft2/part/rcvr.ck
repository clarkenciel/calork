public class Rec extends Chugen {
    OscIn in;
    OscMsg msg;

    float sig;

    in.port( 57120 );
    in.listenAll();

    fun float tick( float in ) {
        return sig;
    }

    fun void listen() {
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
