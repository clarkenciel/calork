// changeip.ck
// change the IP address of a member of Daisy
// Author: Danny Clarke
OscOut cmd;
cmd.dest( "localhost", 37120 );
string mem[0];
string ip[0];

if( me.args() % 2 == 0 && me.args() > 0 ) {
    mem.size( me.args() / 2 );
    ip.size( me.args() / 2 );
    for( int i; i < me.args(); 2 +=> i ) {
        me.arg(i).lower() @=> mem[i/2];
        mem[i/2].trim();
        me.arg(i+1).trim() @=> ip[i/2];
        if( mem[i/2] == "" || ip[i/2] == "" ) {
            <<< "\n\tSomething went wrong. Please check your arguments and try again.",""  >>>;
            me.exit();
        }
    }
        for( int i; i < mem.cap(); i ++ ) {
            <<< "\tadding", mem[i],"@", ip[i],"" >>>;
            cmd.start( "/changeip" ); 
            cmd.add( mem[i] ).add( ip[i] );
            cmd.send();
        }
} else {
    <<< "\n\tPlease add this file again with an EVEN number of commands:\n\tfilename.ck:name1:ip1:name2:ip2:etc","" >>>;
}
