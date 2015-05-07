// freq.ck
// change the frequency of the source signal in Daisy
// Author: Danny Clarke
OscOut cmd;
cmd.dest( "localhost", 37120 );
string msg;

if( me.args() ) {
    me.arg(0).trim() => msg;
    <<< "\tChanging freq to:",msg,"">>>;
    cmd.start( "/freq" ).add(msg).send();
} else {
    <<< "\n\tPlease add this file again with commands:\n\tfilename.ck:cmd1:cmd2:etc","" >>>;
}
