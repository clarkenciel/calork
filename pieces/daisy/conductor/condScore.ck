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
<<<"\n\n\n\t\tRUN THIS FILE IN A LOOPING VM: chuck condScore.ck --loop\n\n","">>>;
<<<"\tSupport files now loaded. Use the 'ctls.ck' file to send commands:\n","">>>;
"\t\tctls.ck:addMem:name:ip - to add member and ip\n" +=> commands;
"\t\tctls.ck:connect:from:to - to connect two members\n" +=> commands;
"\t\tctls.ck:disconnect:name - to disconnect a member\n" +=> commands;
"\t\tctls.ck:send:name - to send the source signal to a member\n" +=> commands;
"\t\tctls.ck:tog:name - to silence/un-silence a player\n" +=> commands;
"\t\tctls.ck:print - to print the current state\n" +=> commands;
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
