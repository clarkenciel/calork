public class Source extends Chugen {
    OscOut out;
    string members[0];
    string names[0];
    string connections[0][0];
    "junk" => string dest;

    47120 => int port;

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
        out.start( "/sig" );
        out.add( "source" );
        out.add( sig[idx] );
        out.send();
        return sig[idx];
    }

    fun void freq( float in ) { 
        in => f;
    }

    fun void addMem( string name, string ip ) {
        // add check to make sure I don't re-add people
        if( !exists( name ) ) {
            names.size( names.size() + 1 );
            name @=> names[ names.cap() -1 ];
            ip @=> members[ name ];
            if( names.cap() == 1 ) {
                ip => dest;
                out.dest( dest, port );
            }
        } else if( exists(name) ) {
            ip @=> members[ name ];
        }
    }

    fun void addMult( string _names[], string _ips[] ) {
        for( int i; i < _names.cap(); i ++ ) {
            addMem( _names[i], _ips[i] );
        }
    }

    fun void setDest( string name ) {
        members[ name ] @=> dest;
        out.dest( dest, port );
        <<< "sending to",name,"" >>>;
    }

    fun void changeIp ( string name, string nuIP ) {
        nuIP @=> members[name];
    }

    fun void connect( string from, string to ) {
        int exists;
        string tDest;

        for( int i; i < connections.cap(); i ++ ) {
            if( connections[i][0] == from && connections[i][1] == to ) {
                <<< "\n\tConnection from",from,"to",to,"already exists","">>>;
                1 => exists;
            }
        }

        if( exists == 0 ) {
            dest => tDest;
            members[ from ] => dest;
            out.dest( dest, port );
            out.start( "/connect, s" );
            out.add( members[ to ] );
            out.send();
            out.dest( tDest, port );

            connections.size( connections.size() + 1 );
            new string[2] @=> connections[connections.size()-1];
            from @=> connections[connections.size()-1][0];
            to @=> connections[connections.size()-1][1];
        }
    }
    
    fun void disconnect( string name ) {
        dest => string tDest;
        members[ name ] @=> dest;
        out.dest( dest, port );
        out.start( "/disconnect, s" );
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
        out.dest( tDest, port );
    }

    fun void tog( string name ) {
        dest => string tDest;
        members[ name ] @=> dest;
        out.dest( dest, port );
        out.start( "/tog" ).send();
        out.dest( tDest, port );
    }

    fun void stopSend() {
        "junk" => dest;
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
