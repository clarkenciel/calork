me.dir() => string d;
string name;

if( me.args() < 1 ) {
    <<< "Please Re-try this file with your name as an argument:","">>>;
    <<< "\tpartScore.ck:name","">>>;
    me.exit();
} else {
    me.arg(0) => name;

    Machine.add( d + "/chain.ck" ) => int out;
    Machine.add( d + "/rcvr.ck" ) => int in;
    Machine.add( d + "/part.ck:"+name ) => int part;
    while( ms => now );

}
