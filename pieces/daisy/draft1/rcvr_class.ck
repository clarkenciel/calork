// rcvr.ck 
// Chugen to pass on values
class Pass extends Chugen {
    1.0 => float sig;
    float step;
    float out;
    fun float tick( float in ) {
        return sig;
    }
    fun void freq( float _f ) {
        _f => sig;
    }
}

// receiver class for Daisy
public class Rec {
    OscIn in;
    OscMsg msg;
    OscOut out;
    Pass p;
    57120 => int port; 0 => int on;
    "" => string id => string outAddr;
    float sig, pulse; // NB: pulse is in samples

    port => in.port;
    in.listenAll(); // listen to everything, filter based on function

    fun void setup() {
        // listen for id messages
        while( true ) {
            in => now;
            while( in.recv( msg ) ) {
                //<<< msg.address,"">>>;
                if( msg.address == "/setup" ) {
                    msg.getInt(0) => Std.itoa => id;
                    msg.getString(1) => outAddr;
                    msg.getFloat(2) => pulse;
                    msg.getInt(3) => on;
                    <<< "RECEIVED id:",id,"send-to:",outAddr,"pulse:",pulse,"toggle:",on,"">>>;
                    me.exit();
                }
            }
        }
    }

    fun void play() {
        // play messages received
        while( true ) {
            in => now;
            while( in.recv( msg ) ) {
                //<<< "RECEIVED address",msg.address,"typetag:",msg.typetag,"" >>>;
                if( id != "" && msg.address == "/play" ) {
                    if( Std.itoa( msg.getInt(0) ) == id ) {
                        msg.getFloat(1) => sig;
                        <<<"RECEIVED sig set to:",sig,"">>>;
                    }
                }
            } 
        }
    }

    fun void change() {
        // listen for change messages
        while( true ) {
            in => now; 
            while( in.recv( msg ) ) {
                if( id != "" && msg.address == "/change" ) {
                    msg.getString(0) => outAddr;
                    msg.getFloat(1) => pulse;
                    <<<"RECEIVED new address:",outAddr,"new pulse:",pulse,"">>>;
                }
            }
        }
    }

    fun void send(UGen s, UGen e) {
        // pass sound along
        while( true ) {
            if( id != "" && on == 1 ) {
                sig => p.freq;
                p => s;
                e => blackhole;
                out.start( outAddr );
                e.last() => out.add;
                <<< e.last() >>>;
                out.send();
                pulse::samp => now;
            } 
        }
    }

    fun void toggle() {
        while( true ) {
            in => now;
            while( in.recv(msg) ){
                if( id != "" && msg.address == "/toggle" ) {
                    if( Std.itoa( msg.getInt(0) ) == id ) {
                        msg.getInt(1) => on;
                        <<< "toggle set to:",on,"">>>;
                    }
                } 
            } 
        }
    }
}

// TEST CODE
Rec r; Rec r2;

// SOUND CHAIN
NRev s; s.gain(0.9);
s.mix( 0.05 );
r2.p => blackhole; //sq.gain(0.2);

spork ~ r.setup();
spork ~ r.play();
spork ~ r.change();
spork ~ r2.setup();
spork ~ r2.play();
spork ~ r2.change();
spork ~ r.send( s, s ); // Put start and end of sound chain here

while( second => now ) {
}

fun void checker() {
    while( second => now ) {
        <<< "hey","">>>;
    }
}
