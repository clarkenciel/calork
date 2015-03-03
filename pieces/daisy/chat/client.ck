// client for chuck-based chat using OSC messages
// Author: Danny Clarke

public class ChuckleClient {
    OscOut out; // send messages to server
    int mePort, sPort;
    string name, sIp, meIp, line, omsg, leader;
    
    // ------------------------OSC SETUP -------------------------
    17000 => mePort; 16000 => sPort;  

    // -----------------------FUNCS-------------------------------
    // receive a message
    fun void rcv() {
        OscIn in; // receive messages from server
        OscMsg m;
        in.port( mePort ); in.listenAll();

        while( true ) {
            in => now;
            while( in.recv(m) ) {
                if( m.address == "/all" || m.address == "/"+name ) {
                    <<< m.getString(0), "" >>>;
                }
            }
        }
    }

    // "Log in"
    fun void login( string myName, string myIp, string server ) {
        myName => name; myIp => meIp; server => sIp; name+": " => leader;
        <<< "\n\n\tLogging in as:",name,"@",meIp,"sending to:",sIp,"">>>;
        out.dest( sIp, sPort );
        out.start("/login").add(name).add(meIp).send();
    }
    
    // "Log in" overload
    fun void login( string myName, string myIp, string server, int _p ) {
        myName => name; myIp => meIp; server => sIp; name+": " => leader;
        _p => mePort;

        <<< "\n\n\tLogging in as:",name,"@",meIp,"sending to:",sIp,"">>>;
        out.dest( sIp, sPort );
        out.start("/login").add(name).add(meIp).send();
    }
    
    // parse string for Loop: commands
    fun string loopParse( string s ) {
        "Loop:" => string starter;
        "n:" => string number;
    
        // find the index of the start of the command
    
        // find the index of the end of the command
    
        // find the number of repetitions, if any
    
    
    }

    // send a message (down here because it's long
    fun void snd() {
        int v; string txt;
        KBHit k; // keyboard listener

        // DICTIONARY
        ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"] @=> string chars[];
        ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"] @=> string cap[];
        ["0","1","2","3","4","5","6","7","8","9"] @=> string nos[];
        ["!","\"" /*"*/,"#","$","%","&","'","(",")","*","+",",","-",".","/"] @=> string nonA1[];
        [":",";","<","=",">","?","@"] @=> string nonA2[];

        while( true ) {
            k => now;
            while( k.more() ) {
                k.getchar() => v;
                if( v >= 97 && v <= 122 )
                    chars[v - 97] +=> txt;
    
                if( v >= 48 && v <= 57 )
                    nos[ v - 48 ] +=> txt;
    
                if( v >= 33 && v <= 47 )
                    nonA1[v - 33] +=> txt;
    
                if( v >= 58 && v <= 64 )
                    nonA2[v-58] +=> txt;
    
                if( v >= 65 && v <= 90 )
                    cap[v-65] +=> txt;
    
                if( v == 32 )
                    " " +=> txt;
    
                if( v == 8 && txt.length() )
                    txt.substring( 0, txt.length()-1 ) => txt;
    
                if( v == 13 ) {
                    //<<< leader,txt,"" >>>;
                    out.start("/msg").add(leader+txt).send();
                    "" => txt;
                }
            }
        }
    }

    // see if in array
    fun int isIn( string val, string a[] ) {
        int out;
        for( int i; i < a.cap(); i++ ) {
            if( a[i] == val ) {
                1 => out;
                break;
            }
        }
        return out;
    }
}


// TEST CODE (Actually this is functional...)
ChuckleClient c;
OscOut out;
out.dest( "localhost", 17000 );

if( me.args() == 3 ) {
    c.login( me.arg(0), me.arg(1), me.arg(2) );
} else if ( me.args() == 4 ) {
    c.login( me.arg(0), me.arg(1), me.arg(2), Std.atoi(me.arg(3)) );
} else {
    <<< "\n\n\t PLEASE RUN THIS FILE AGAIN WITH ARGUMENTS:","">>>;
    <<< "\t\tclient:name:your IP:server IP","">>>; 
    me.exit();
}

spork ~ c.rcv();
spork ~ c.snd();
while( ms => now );
