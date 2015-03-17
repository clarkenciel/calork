OscIn in;
OscMsg msg;

in.port(57121);

in.listenAll();

while (true) {
    in => now;
    while (in.recv(msg)) {
        <<< msg.address >>>;
        <<< msg.getString(0) >>>; 
        <<< msg.getFloat(1) >>>;
    }
}


fun void map( float in, float inLo, float inHi, float gLo, float gHi ) {
    inHi - inLo => float inRange;
    gHi - gLo => float gRange;
    in - inLo => float inPos;
    inPos / inRage => inPos;
    inPos * gRange => float gPos;
    gPos + gLo => float gPos;
    
    return gPos;
}
