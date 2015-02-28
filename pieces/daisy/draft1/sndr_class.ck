// sndr.ck
// sending class for ChucK (i.e. conductor)

public class Send {
    OscOut out;
    SinOsc sig => blackhole;
    string hosts[0];
    57120 => int port;
    sig.freq( 200 );
    sig.gain( 0.5);

    fun void change( string host, int id, string newAddr, float pulse ) {
        // send out "change" message
        out.dest( hosts[host], port );
        out.start( "/change, isf" );
        out.add(id).add(newAddr).add(pulse).send();
        <<< "send changed",host,id,newAddr,pulse,"" >>>;
    }

    fun void setup( string host, int id, string addr, float pulse, int tog  ) {
        // send out "setup" message
        out.dest( hosts[host], port );
        out.start( "/setup, isfi" );
        out.add(id).add(addr).add(pulse).add(tog).send();
        <<< "send setup",host, id, addr, pulse, tog,"">>>;
    }

    fun void play( string host, int id, float sig ) {
        // send out "play" message
        out.dest( hosts[host], port );
        out.start( "/play, if" );
        out.add(id).add(sig).send();
        <<< "send play",host, id, sig,"" >>>;
    }

    fun void toggle( string host, int id, int tog ) {
        // send message to toggle a player
        out.dest( hosts[host], port );
        out.start( "/toggle, ii" );
        out.add(id).add(tog).send();
        <<< "send toggle",host,id,tog,"">>>;
    }

    fun void addHost( string name, string ip ) {
        ip @=> hosts[ name ];
        <<< "Added",ip,"for",name,"">>>;
    }

    fun void play() {
        while( samp => now )
            out.start( "/sig, f" );
            out.add( sig.last() );
            out.send();
        }
    }
}

// TEST CODE
Send s;
s.addHost( "danny", "localhost" );
s.setup("danny", 0, "/danny", 100, 1 );

while( second => now ) {
    s.toggle( "danny", 0, maybe );
}
