float i;

while( 100::ms => now ) {
    <<< triMod( i, 20 ) >>>;
    0.5 +=> i;
}

fun float triMod( float in, float hi ) {
    float diff, out;
    if( in >= hi ) {
        (in - hi) % hi => diff;
        hi - diff => out;
        return out;
    } else {
        return in;
    }
}
