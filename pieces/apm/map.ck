5 => float t;

<<< map( 5, 0, 10, -50, 50 ) >>>;

fun float map( float in, float inLo, float inHi, float gLo, float gHi ) {
    inHi - inLo => float inRange;
    gHi - gLo => float gRange;
    in - inLo => float inPos;
    inPos / inRange => inPos;
    inPos * gRange => float gPos;
    gPos + gLo => gPos;

    return gPos;
}
