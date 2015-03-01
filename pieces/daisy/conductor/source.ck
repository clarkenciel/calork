public class Source extends Chugen {
    OscOut out;
    string members[0];
    string names[0];
    string connections[0][0];
    string dest;

    67120 => int port;
    67121 => int chainPort;

    float sig[44100];
    440 => float f;
    for( int i; i < 44100; i ++ ) {
        Math.sin( i*2*pi/44100 ) @=> sig[i];
    }
    float count;
    int idx;


    fun float tick( float in ) {
        f +=> count; 
        while( count >= 44100 ) 44100 -=> count;
        count $ int => idx;
        out.dest( dest, port );
        out.start( "/sig, f");
        out.add( sig[idx] );
        out.send();
        return sig[idx];
    }

    fun void freq( float in ) { 
        in => freq;
    }

    fun void addMem( string name, string ip ) {
        // add check to make sure I don't re-add people
        if( !exists( name ) ) {
            names.size( names.size() + 1 );
            name @=> names[ names.cap() -1 ];
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

    fun void tog( string name ) {
        members[ name ] @=> dest;
        out.dest( dest, chainPort );
        out.start( "/tog" ).send();
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
