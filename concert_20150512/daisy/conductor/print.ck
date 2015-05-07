// print.ck
// print the current state of Daisy
// Author: Danny Clarke

OscOut cmd;
cmd.dest( "localhost", 37120 );
cmd.start("/print").send();
