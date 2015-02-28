public class Source extends Chugen {
    OscOut out;
    string members[0];
    string names[0];
    string connections[0][0];
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
        // add check to make sure I don't re-add people
        if( !exists( name ) ) {
            names << name;
            ip @=> members[ name ];
            if( names.cap() == 1 ) {
                ip => dest;
            }
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
        connections << [from, to];
    }
    
    fun void disconnect( string name ) {
        members[ name ] @=> dest;
        out.dest( dest, chainPort );
        out.start( "/disconnect, s" );
        out.add( "localhost" );
        out.send();
        for( int i; i < connections.cap(); i++ ) {
            if( connections[i][0] == name ) {
                NULL @=> connections[i];
                for( i+1 => int j; j < connections.cap(); j++ ) {
                    connections[j] @=> connections[j-1];
                }
                connections.popBack();
            }
        }
    }

    fun int exists( string name ) {
        int out;
        for( int i; i < names.cap(); i++ ) {
            if( names[i] == name ) {
                1 => out;
                break;
            }
        }
        return out;
    }
}
