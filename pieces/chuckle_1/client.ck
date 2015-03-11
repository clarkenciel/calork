// client for chuck-based chat using OSC messages
// Author: Danny Clarke
private class Speaker extends Chubgraph {
    Noise n => ResonZ b => ADSR a => Gain g => JCRev r;
    Delay d1;
    d1 => Delay d2 => d1;

    // VARS
    10 => float del;
    0.9 => float gn;
    50 => float vTime;
    time later;
    440 => float f;
    
    // SETUP
    d1.max( 44100::samp );
    d2.max( 44100::samp );
    d1.delay( del::ms );
    d2.delay( del::ms );
    r.mix( 0.05 );
    b.gain(0.9);
    d1.gain(0.9);
    d2.gain(0.9);

    fun void speak( string char ) {
        if( char == "perc" ) {
            g.gain(gn);
            a.set(15::ms, 30::ms, 0.0, 0::ms);
            a.keyOn(1);
        } else if( char == "noise" ) {
            g.gain(gn);
            b.Q(Math.random2( 1, 20 ));
            b.freq( Math.random2f( f-100, f+100 ) );
            a.keyOn(1);
        } else if( char == "soft" ) {
            g.gain(gn);
            a.set(vTime::ms, vTime::ms, 0.0, 0::ms);
            a.keyOn(1);
        } else if( char == "hum" ) {
            g.gain(gn);
            a.set( (vTime)::ms, (vTime)::ms, gn/2.0, 100::ms );  
            b.Q( 100 );
            a.keyOn(1);
            (vTime*4)::ms => now;
        } else if( char == "misc" ) {
            now + (vTime)::ms => later;
            while( now < later ) {
                (0.3/(vTime::ms/samp)) -=> gn;
                samp => now;
            }
            now + (vTime)::ms => later;
            while( now < later ) {
                (0.3/(vTime::ms/samp)) +=> gn;
                samp => now;
            }
        } else if( char == "vowel" ) {
            a =< g; 
            a => d1 => g;
            g.gain(gn);
            a.set( vTime::ms, vTime::ms,0.0, 0::ms );
            a.keyOn(1);
            now + vTime::ms => later;
            while( now < later ) {
                del + (10.0/(vTime::ms/samp)) => del;
                del::ms => d2.delay;
                del::ms => d1.delay;
                b.Q() + (10.0/(vTime::ms/samp)) => b.Q;
                samp => now;
            }
            now + vTime::ms => later;
            while( now < later ) {
                del - (10.0/(vTime::ms/samp)) => del;
                del::ms => d2.delay;
                del::ms => d1.delay;
                b.Q() - (10.0/(vTime::ms/samp))=> b.Q;
                samp => now;
            }
            d1 =< g;
            a =< d1;
            a => g;
        }
    }

    fun void connect( UGen _o ) {
        r => _o;
    }

    fun void disconnect( UGen _o ) {
        r =< _o;
    }

    fun float freq( float _f ) {
        _f => f;
        (0.05 / (f/10000) ) +=> gn;
        return f;
    }

    fun float gain( float _g ) {
        _g + (0.05 / (f/10000) ) => gn;
        return gn;
    }

    fun float vowSpeed( float _v ) {
        _v => vTime;
        return vTime;
    }
}

public class ChuckleClient {
    OscOut out; // send messages to server
    int mePort, sPort;
    string name, sIp, meIp, line, omsg, leader;
    
    // ------------------------OSC SETUP -------------------------
    17000 => mePort; 16000 => sPort;  

    // ---------------------PARSING SETUP------------------------
    ["Loop:"] @=> string cmds[];
    
    ["b","p","t","d","g","k","q"] @=> string perc[];
    ["s","h","f","x"] @=> string noise[];
    ["v","m","n","j","z","r"] @=> string hum[];
    ["y","w","l"] @=> string soft[];
    ["a","e","i","o","u"] @=> string vowel[];
    [" ","0","1","2","3","4","5","6","7","8","9","!","@","#","$",
     "%","^","&","*","(",")","-","_","=","+","\\","}","{","'","\"",
     ";",":",",",".","/","<",">","?"] @=> string misc[];
    [perc, noise, hum, soft, misc, vowel] @=> string delimits[][]; 
    ["perc","noise","hum","soft","misc", "vowel"] @=> string pcmds[];


    // -----------------------FUNCS-------------------------------
    // receive a message
    fun void rcv() {
        OscIn in; // receive messages from server
        OscMsg m;
        in.port( mePort ); in.listenAll();
        string msg, c;

        while( true ) {
            in => now;
            while( in.recv(m) ) {
                if( m.address == "/all" || m.address == "/"+name ) {
                    m.getString(0) => msg;
                    <<< msg, "" >>>;
                    spork ~ play( msg, 50::ms );
                }
            }
        }
    }

    fun void play( string msg, dur wait ) {
        string c;
        Speaker speaker;
        speaker.connect( dac );
        speaker.freq( Math.random2f( 300, 1000 ) );
        speaker.vowSpeed( wait/ms );

        for( int i; i < msg.length(); i++ ) {
            msg.substring(i,1) => c;
            c.lower() => c;
            pcmds[ isIn2D( c, delimits ) ] => c;
            speaker.speak( c );
            wait => now;
        }

        wait => now;
        speaker.disconnect( dac );
        NULL @=> speaker;
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
    
                if( (v == 8 || v == 127 ) && txt.length() )
                    txt.substring( 0, txt.length()-1 ) => txt;
    
                if( v == 13 || v == 10 ) {
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

    // is in 2d
    fun int isIn2D( string val, string a[][] ) {
        int out;
        for( int i; i < a.cap(); i++ ) {
            if( isIn( val, a[i] ) ) {
                i => out;
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
