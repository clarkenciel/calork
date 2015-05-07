// Conductor "score" file
// Author: Danny Clarke

OscIn in;
OscMsg m;
OscOut print;
KBHit k;
int kVal;

in.port(12000);
in.listenAll();
print.dest("localhost", 57120 );

me.dir() => string d;

Machine.add( d + "source.ck" ) => int source;
Machine.add( d + "cond.ck" ) => int cond;

string commands;
<<<"\n\n\n\t\t\t\tWelcome to DAISY\n\n","">>>;
<<<"\tSupport files now loaded. \n\tUse the following at the command line to control Daisy:\n","">>>;
"\t\taddmem:name:ip - to add member and ip\n" +=> commands;
"\t\tconnect:from:to - to connect two members\n" +=> commands;
"\t\tdisconnect:name - to disconnect a member\n" +=> commands;
"\t\tsend:name - to send the source signal to a member\n" +=> commands;
"\t\tstop - to stop sending the source\n" +=> commands;
"\t\ttog:name - to silence/un-silence a player\n" +=> commands;
"\t\tfreq - to change the frequency of the source\n" +=> commands;
"\t\tprint - to print the current state of your Daisy system\n" +=> commands;
"\t-----------------------------------------------------------------\n" +=> commands;
<<< commands, "" >>>;

spork ~ cListen();
spork ~ kListen();
while( ms => now );

// FUNCS
fun void cListen() {
    while( true ) {
        in => now;
        while( in.recv(m) ) {
            if( m.address == "/msg" ) {
                <<< m.getString(0), "" >>>;
            }
            if( m.address =="/print" ) {
                <<< m.getString(0), "" >>>;
                <<< commands, "" >>>;
            }
        }
    }
}

fun void kListen() {
    while( true ) {
        k => now;
        while( k.more() ) {
            k.getchar() => kVal;
            if( kVal == 32 ) {
                print.start("/print").send(); 
                0 => kVal;
            }
        }
    }
}
