// send.ck
// send source signal to a member
// Author: Danny Clarke
OscOut cmd;
cmd.dest( "localhost", 37120 );
string dest;

if( me.args() == 1 ) {
    me.arg(0).trim() => dest;
    if( dest == "" ) {
        <<< "\n\tSomething went wrong. Please check your arguments and try again.",""  >>>;
        me.exit();
    }
    dest.lower();
    cmd.start( "/send" );
    <<< "\n\tSending source to:",dest,"">>>;
    cmd.add( dest ).send();
} else {
    <<< "\n\tPlease add this file again with ONE command:\n\tfilename.ck:cmd1","" >>>;
}
