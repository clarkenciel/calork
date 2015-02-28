// server for conductor
// Author: Danny Clarke
OscIn cmd;
OscMsg m;
OscOut print;

KBHit k;

string msg, kmsg;
int kVal;

cmd.port( 57120 );
cmd.listenAll();
print.dest( "localhost", 12000 );

Source s => blackhole;

while( true ) {
    cmd => now;
    while( cmd.recv( m ) ) {
        if( m.address == "/addMem" ) {
            s.addMem( m.getString(0), m.getString(1) );
            for( int i; i < s.names.cap(); i++ ) {
                "\t\t" + s.names[i] + ": " + s.members[ s.names[i] ] + "\n" +=> msg;
            }
            print.start( "/msg, s" ); print.add( msg ).send();
        } else if ( m.address == "/connect" ) {
            s.connect( m.getString(0), m.getString(1) );
            for( int i; i < s.connections.cap(); i++ ) {
                "\t\t" + s.connections[i][0] + " => " + s.connections[i][1] + "\n" +=> msg;
            }
            print.start( "/msg, s" ); print.add( msg ).send();
        } else if( m.address == "/disconnect" ) {
            s.disconnect( m.getString(0) );
            for( int i; i < s.connections.cap(); i++ ) {
                "\t\t" + s.connections[i][0] + " => " + s.connections[i][1] + "\n" +=> msg;
            }
            print.start( "/msg, s" ); print.add( msg ).send();
        } else if( m.address == "/send" ) {
            s.setDest( m.getString(0) );
        } else if( m.address == "/changeip" ) {
            s.changeIp( m.getString(0), m.getString(1) );
            for( int i; i < s.names.cap(); i++ ) {
                "\t\t" + s.names[i] + ": " + s.members[ s.names[i] ] + "\n" +=> msg;
            }
            print.start( "/msg, s" ); print.add( msg ).send();
        } else if( m.address == "/print" ) {
            "\tCurrent Members:\n" +=> msg;
            for( int i; i < s.names.cap(); i++ ) {
                "\t\t" + s.names[i] + ": " + s.members[ s.names[i] ] + "\n" +=> msg;
            }
            "\tCurrent Connections:\n" +=> msg;
            for( int i; i < s.connections.cap(); i++ ) {
                "\t\t" + s.connections[i][0] + " => " + s.connections[i][1] + "\n" +=> msg;
            }
            "\t------------------------------------------------------\n" +=> msg; 
            print.start( "/msg, s" ).add( msg ).send();
        }
    }
    "" => msg;
}
