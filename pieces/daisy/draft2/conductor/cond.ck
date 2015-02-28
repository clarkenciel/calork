// server for conductor
// Author: Danny Clarke
OscIn cmd;
OscMsg m;

cmd.port( 57120 );
cmd.listenAll();

Source s => blackhole;

while( true ) {
    cmd => now;
    while( cmd.recv( m ) ) {
        if( m.address == "/addMem" ) {
            s.addMem( m.getString(0), m.getString(1) );
        } else if ( m.address == "/connect" ) {
            s.connect( m.getString(0), m.getString(1) );
        } else if( m.address == "/disconnect" ) {
            s.disconnect( m.getString(0) );
        } else if( m.address == "/send" ) {
            s.setDest( m.getString(0) );
        } else if( m.address == "/changeip" ) {
            s.changeIp( m.getString(0), m.getString(1) );
        }
    }
}
