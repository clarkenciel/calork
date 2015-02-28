public class Source extends Chugen {
    OscOut out;
    string members[0];
    string names[0];
    string dest;
    57120 => int port;
    57121 => int chainPort;

    float sig[0];
    for( int i; i < 44100; i ++ ) {
        sig << Math.sin( (i/44100.0) * pi );
    }
    int count;

    fun float tick( float in ) {
        count++; count % sig.cap() => count;
        out.dest( dest, port );
        out.start( "/sig, f");
        out.add( sig[count] );
        out.send();
        return sig[count];
    }

    fun void addMem( string name, string ip ) {
        names << name;
        ip @=> members[ name ];
        if( names.cap() == 1 ) {
            ip => dest;
        }
    }

    fun void setDest( string name ) {
        members[ name ] @=> dest;
        <<< "sending to",name,"" >>>;
    }

    fun void changeIp ( string name, string nuIP ) {
        nuIP @=> members[name];
    }

    fun void connect( string from, string to ) {
        members[ from ] @=> dest;
        out.dest( dest, chainPort );
        out.start( "/connect, s" );
        out.add( members[ to ] );
        out.send();
    }
    
    fun void disconnect( string name ) {
        members[ name ] @=> dest;
        out.dest( dest, chainPort );
        out.start( "/disconnect, s" );
        out.add( "localhost" );
        out.send();
    }
}
