// Server for chuck-based chat client using OSC messages
// Author: Danny Clarke

public class ChuckleServer {
    OscOut out[0]; // to push messages out to clients
    //OscOut out;

    string names[0]; // Names of chat members
    string ips[0]; // ips of chat members; indexed to names

    17000 => int cliPort; // port number for clients
    16000 => int mePort;

    // add a new members
    fun void add( string name, string ip ) {
        //<<< "checking",name,"@", ip,"" >>>;
        if( !nameCheck( name ) ) { // if the name is new go ahead and add new name
            names.size( names.size() + 1 ); // expand list of names
            name @=> names[ names.cap() - 1];

            ip @=> ips[ name ];

            out.size( out.size() + 1 );
            new OscOut @=> out[ out.size() -1 ];
            out[ out.size() -1 ].dest( ips[ names[names.size()-1] ], cliPort );

        } else if( !ipCheck(ip) ) { // if we've seen the name, but not the ip
            ip @=> ips[ name ];
            <<< name, "already stored, changing ip to:",ips[name],"">>>;
        } // do nothing otherwise
    }

    // receive a message from a meber
    fun void rec() {
        OscIn in;
        OscMsg m;
        in.port(mePort); in.listenAll();

        while( in => now ) {
            while( in.recv(m) ) {
                if( m.address == "/msg" ) {
                    snd( m.getString(0) );
                }
            }
        }
    }

    // pass a message out to the clients
    fun void snd( string mout ) {
        for( int i; i < out.cap(); i ++ ) {
            out[i].start("/broadcast").add(mout).send();
        }
    }

    // listen for new members
    fun void logIn() {
        OscIn in;
        OscMsg m;
        in.port(mePort); in.listenAll();

        string lmsg;

        while( in => now ) {
            while( in.recv(m) ) {
                if( m.address == "/login" ) {
                    add( m.getString(0), m.getString(1) );  
                    "\n\t"+names[names.cap()-1]+" has entered" => lmsg;
                    snd( lmsg );
                }
            }
        }
    }
            

    // Check if a name has already been added
    fun int nameCheck( string name ) {
        int out;
        for( int i; i < names.cap(); i++ ) {
            if( names[i] == name ) {
                1 => out;
                break;
            }
        }
        return out;
    
    }

    // Check if an IP has already been added
    fun int ipCheck( string ip ) {
        int out;
        for( int i; i < names.cap(); i ++ ) {
            if( ips[ names[i] ] == ip ) {
                1 => out;
                break;
            }
        }
        return out;
    }
}

// TEST CODE
ChuckleServer s;

spork ~ s.logIn();
spork ~ s.rec();
while( ms => now );
