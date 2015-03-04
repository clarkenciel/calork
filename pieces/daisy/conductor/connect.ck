// connect.ck
// connect to members of Daisy together
// Author: Danny Clarke
OscOut cmd;
cmd.dest( "localhost", 37120 );
string from;
string to;
string dests[0];

if( me.args() > 0 ) {
    dests.size( me.args() );
    for( int i; i < me.args(); i++ ) {
        me.arg(i).trim() @=> dests[i];
        if( dests[i] == "" ) {
            <<< "\n\tSomething went wrong, please check your arguments.","" >>>;
            me.exit();
        }
        dests[i].lower();
    }
    for( 1 => int i; i < dests.cap(); i ++ ) {
        cmd.start("/connect");
        dests[i] @=> to;
        dests[i-1] @=> from;
        <<< "\n\tConnecting:",from,"=>",to,"">>>;
        cmd.add(from).add(to).send();
    }
} else {
    <<< "\n\tPlease add this file again with commands:\n\tfilename.ck:cmd1:cmd2:etc","" >>>;
}
