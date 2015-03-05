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
        string lmsg;
        
        if( nameCheck( name ) < 1) { // if the name is new go ahead and add new name
            names.size( names.size() + 1 ); // expand list of names
            name @=> names[ names.cap() - 1];

            ip @=> ips[ name ];

            out.size( out.size() + 1 );
            new OscOut @=> out[ out.size() -1 ];
            out[ out.size() -1 ].dest( ips[ names[names.size()-1] ], cliPort );
            
            "\n\t"+names[names.cap()-1]+" has entered" => lmsg;
            snd( "all", lmsg );
        } else if( ipCheck(ip) < 1 ) { // if we've seen the name, but not the ip
            ip @=> ips[ name ];
            <<< name, "already stored, changing ip to:",ips[name],"">>>;
        } // do nothing otherwise
    }

    // receive a message from a meber
    fun void rec() {
        OscIn in;
        OscMsg m;
        in.port(mePort); in.addAddress("/msg");
        string msg[0];
        string out[0];
        string notAt[0];

        while( in => now ) {
            while( in.recv(m) ) {
                atParse( m.getString(0) ) @=> msg; // parse message for @ commands
                getLeader( msg[0] ) @=> notAt; // parse for any messages after the leader
                notAt[1] @=> msg[0];
                for( int i; i < msg.cap(); i++ ) {
                    getDest( msg[i] ) @=> out; // parse for addresses and messages
                    <<< "From",notAt[0]," ",out[1],"=>",out[0],"">>>;
                    if( out[1].length() > 0 )
                        snd( out[0], notAt[0], out[1] ); // send messages
                }
            }
        }
    }

    // pass a message out to the clients
    fun void snd( string dest, string leader, string mout ) {
        getInd( dest, names ) => int idx;
        if( dest == "all" && mout != " " ) {
            for( int i; i < out.cap(); i ++ ) {
                if( idx != i )
                    out[i].start("/"+dest).add(leader+" "+mout).send();
            }
        } else {
            if( idx >= 0 )
                out[ idx ].start( "/"+dest ).add(mout).send();
        }
    }
    
    fun void snd( string dest, string mout ) {
        getInd( dest, names ) => int idx;
        if( dest == "all") {
            for( int i; i < out.cap(); i ++ ) {
                if( idx != i )
                    out[i].start("/"+dest).add(mout).send();
            }
        } else {
            if( idx >= 0 )
                out[ idx ].start( "/"+dest ).add(mout).send();
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
                }
            }
        }
    }

    // Check if a name has already been added
    fun int nameCheck( string name ) {
        int out;
        for( int i; i < names.cap(); i++ ) {
            if( names[i] == name )
                1 => out; break;
        }
        return out;
    
    }

    // Check if an IP has already been added
    fun int ipCheck( string ip ) {
        int out;
        for( int i; i < names.cap(); i ++ ) {
            if( ips[ names[i] ] == ip )
                1 => out; break;
        }
        return out;
    }
    
    // Get index of item in array
    fun int getInd( string s, string a[] ) {
        -1 => int ind;
        for( int i; i < a.cap(); i ++ ) {
            if( a[i] == s )
                i => ind; break;
        }
        return ind;
    }
    // get message leader
    fun string[] getLeader( string s ) {
        string out[2];
        s.find( ":" ) => int cInd;
        s.substring(0, cInd+1) @=> out[0];
        s.substring(cInd+1) @=> out[1];
        return out;
    }
    
    // get destination of an @-parsed message
    fun string[] getDest( string s ) { 
        s => string t;
        string out[2];
        t.find("@") => int atInd;
        t.find(":") => int colonInd;
        if( colonInd - atInd > 0 ) {
            t.substring(atInd + 1, colonInd - atInd - 1) @=> out[0]; // the address
            t.substring( colonInd+1 ) @=> out[1]; // the message
        }       
        
        if( out[0] != "" ) return out;
        else {
            "all" @=> out[0];
            s @=> out[1];
            return out;
        }
    }

    // parse string for @-addresses (to be used after cmdParse)
    //  NB: first index == message pre-first-@ 
    fun string[] atParse( string s ) {
        string out[0]; "@" => string at;
        int atIdx[0]; int idx;
        
        // get indexes of @ symbols
        while( s.find(at, idx) >= 0 ) {
            atIdx.size( atIdx.size()+1 );
            s.find(at, idx) @=> atIdx[ atIdx.size()-1 ];
            atIdx[ atIdx.size()-1 ] + 1 @=> idx;
        }
        
        // add pre-first-@ part of message
        if( atIdx.cap() > 0 && s.substring( 0, atIdx[0] ).length() > 0 ) {
            out.size( out.size()+1 );
            s.substring( 0, atIdx[0] ) @=> out[ out.size()-1 ];
        }
        
        // get rest of post-@ strings
        for( int i; i < atIdx.cap(); i ++ ) {
            atIdx[i] @=> idx;
            if( i >= atIdx.cap()-1 ) {
                out.size( out.size()+1 );
                s.substring( atIdx[i] ) @=> out[ out.size()-1 ];
            } else {
                atIdx[ i+1 ] @=> idx;
                out.size( out.size()+1 );
                s.substring( atIdx[i], idx - atIdx[i] ) @=> out[ out.size()-1 ];
            }
        }
        
        if( out.cap() < 1 ) {
            out.size( out.size()+1 );
            s @=> out[0];
        }
        return out;
    }
}

// TEST CODE
ChuckleServer s;

spork ~ s.logIn();
spork ~ s.rec();
while( ms => now );
