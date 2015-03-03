// server for conductor
// Author: Danny Clarke
OscIn cmd;
OscMsg m;
OscOut print;

KBHit k;

string msg, kmsg, name, ip, to, from;
int kVal;

cmd.port( 37120 );
cmd.listenAll();
print.dest( "localhost", 12000 );

Source s => blackhole;

while( true ) {
    cmd => now;
    while( cmd.recv( m ) ) {
        if( m.address == "/addMem" ) {
            m.getString(0) => name; m.getString(1) => ip;
            s.addMem( name, ip );
            for( int i; i < s.names.cap(); i++ ) {
                "\t\t" + s.names[i] + ": " + s.members[ s.names[i] ] + "\n" +=> msg;
            }
            print.start( "/msg, s" ); print.add( msg ).send();
        } else if ( m.address == "/connect" ) {
            m.getString(0) => from; m.getString(1) => to;
            s.connect( from, to );
            for( int i; i < s.connections.cap(); i++ ) {
                "\t\t" + s.connections[i][0] + " => " + s.connections[i][1] + "\n" +=> msg;
            }
            print.start( "/msg, s" ); print.add( msg ).send();
        } else if( m.address == "/disconnect" ) {
            m.getString(0) => name;
            s.disconnect( name );
            for( int i; i < s.connections.cap(); i++ ) {
                "\t\t" + s.connections[i][0] + " => " + s.connections[i][1] + "\n" +=> msg;
            }
            print.start( "/msg, s" ); print.add( msg ).send();
        } else if( m.address == "/send" ) {
            m.getString(0) => name;
            s.setDest( name );
        } else if( m.address == "/changeip" ) {
            m.getString(0) => name; m.getString(1) => ip;
            s.changeIp( name, ip );
            for( int i; i < s.names.cap(); i++ ) {
                "\t\t" + s.names[i] + ": " + s.members[ s.names[i] ] + "\n" +=> msg;
            }
            print.start( "/msg, s" ); print.add( msg ).send();
        } else if( m.address == "/tog" ) {
            m.getString(0) => name;
            s.tog( name );
            <<< "\t\tToggling", name,"">>>;
        } else if ( m.address == "/freq" ) {
            s.freq( Std.atof(m.getString(0)) );
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
            print.start( "/print, s" ).add( msg ).send();
        }
    }
    "" => msg;
}
