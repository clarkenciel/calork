class Ping {
    OscIn in;
    OscMsg msg;
    OscOut out;

    in.iaddAddress( "/calorkping, s" ); // will send out name and IP
    in.port( 57120 ); // calOrk default port

    // ping a bunch of IPs to see which ones return
    fun void ping() {
        string one, two, three, four, out_ip;
         
        // first part of IP
        for( 0 => int i; i < 255; i++ ) {
            Std.itoa( i ) => one;
            // second part of IP
            for( 0 => int j; j < 255; j++ ) {
                Std.itoa( j ) => two;
                // third part of IP
                for( 0 => int k; k < 255; k++ ) {
                    Std.itoa( k ) => three;
                    // fourth part of IP
                    for( 0 => int l; l < 255; l++ ) {
                        Std.itoa( l ) => four;
                        out.dest( out_ip, 57120 ); 
                    }
                }
            }
        }
    }

    // if you get pinged, send your name and IP
    fun void pingBack() {
        while( true ) {
            in => now;

            while( in.recv(msg) ) {
                // store name/IP and send back our info

            }
        }
    }

    // store a ping
    fun void store() {
        

    }



}
