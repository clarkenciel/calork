// sndr.ck
// sender test code for APM
// Author: Danny Clarke

spork ~ sndTest();
while( ms => now );

fun void sndTest() {
    int choice;
    float mx;
    OscOut o;
    o.dest( "localhost", 57120 );

    while( 50::ms => now ) {
        Math.random2( 0, 6 ) => choice;
        Math.random2f( 0.0, 10.0 ) => mx;
        if( choice == 0  ) {
            o.start("/eric").add("/atotal").add(mx).send();
            (mx*100)::ms => now;
        } else if( choice == 1 ) {
            o.start("/eric").add("/vtotal").add(mx).send();
            (mx*100)::ms => now;
        } else if( choice == 2 ) {
            o.start("/eric").add("/btotal").add(mx).send();
            (mx*100)::ms => now;
        } else if( choice == 3 ) {
            o.start("/eric").add("/mmapm").add(mx).send();
            (mx*10)::ms => now;
        } else if( choice == 4 ) {
            o.start("/eric").add("/mx").add(mx).send();
            (mx*10)::ms => now;
        } else if( choice == 5 ) {
            o.start("/eric").add("/mltotal").add(mx).send();
            (mx*10)::ms => now;
        } else if( choice == 6 ) {
            o.start("/eric").add("/mrtotal").add(mx).send();
            (mx*10)::ms => now;
        }
    }
}
