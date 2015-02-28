// commands for conductor
// Author: Danny Clarke
OscOut cmd;
cmd.dest( "localhost", 57120 );

if( me.args() ) {
    if( me.arg(0) == "addMem" ) {
        cmd.start( "/addMem, ss" ); 
        cmd.add( me.arg(1) ).add( me.arg(2) );
        cmd.send();
    } else if( me.arg(0) == "connect" ) {
        cmd.start( "/connect, ss" );
        cmd.add( me.arg(1) ).add( me.arg(2) );
        cmd.send();
    } else if( me.arg(0) == "disconnect" ) {
        cmd.start( "/disconnect, s" );
        cmd.add( me.arg(1) );
        cmd.send();
    } else if( me.arg(0) == "send" ) {
        cmd.start( "/send, s" );
        cmd.add( me.arg(1) );
        cmd.send();
    } else if( me.arg(0) == "changeip" ) {
        cmd.start( "/changeip, ss" );
        cmd.add( me.arg(0) ).add( me.arg(1) );
        cmd.send();
    } else if( me.arg(0) == "print" ) {
        cmd.start( "/print" ).send();
    } else {
        <<< "\n\tSomething went wrong. Please check your arguments and try again." >>>;
    }
} else {
    <<< "\n\tPlease add this file again with commands:\n\tfilename.ck:cmd1:cmd2:etc","" >>>;
}
