// disconnect.ck
// disconnect a member of daisy from the chain
// Author: Danny Clarke
OscOut cmd;
cmd.dest( "localhost", 37120 );
string mem;
string dests[0];

if( me.args() > 0 ) {
    dests.size( me.args() );
    for( int i; i < me.args(); i++ ) {
        me.arg(i).trim() @=> dests[i];
        if( dests[i] == "" ) {
            <<< "\n\tSomething went wrong. Please check your arguments and try again.",""  >>>;
            me.exit();
        }
        dests[i].lower();
    }
    for( int i; i < dests.cap(); i ++ ) {
        cmd.start( "/disconnect" );
        <<< "\tDisconnecting:",dests[i],"">>>;
        cmd.add( dests[i] ).send();
    }
} else {
    <<< "\n\tPlease add this file again with commands:\n\tfilename.ck:cmd1:cmd2:etc","" >>>;
}
