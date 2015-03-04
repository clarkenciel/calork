// stop.ck
// Stop the source signal in Daisy
// Author: Danny Clarke

OscOut cmd;
cmd.dest( "localhost", 37120 );

<<< "\tStopping signal.","">>>;
cmd.start( "/stop" ).send();
