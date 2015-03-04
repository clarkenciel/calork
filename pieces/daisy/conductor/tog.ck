// tog.ck
// toggle a member of Daisy on/off
// Author: Danny Clarke
OscOut cmd;
cmd.dest( "localhost", 37120 );
string dests[0];

if( me.args() ) {
    dests.size( me.args() );
    for( int i; i < me.args(); i++ ) {
        me.arg(i).trim() @=> dests[i];
        if( dests[i] == "" ) {
            <<< "\n\tSomething went wrong. Please check your arguments and try again.",""  >>>;
            me.exit();
        }
    }
    for( int i; i < dests.cap(); i ++ ) {
        <<< "\tToggling:",dests[i],"">>>;
        cmd.start( "/tog" ).add( dests[i] ).send();
    }
} else {
    <<< "\n\tPlease add this file again with commands:\n\tfilename.ck:cmd1:cmd2:etc","" >>>;
}
