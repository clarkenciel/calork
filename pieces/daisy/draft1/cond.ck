// conductor server
// Author: Danny Clarke
/* Jist:
*   conductor runs loops this file in the VM
*   runs another file for each of the commands
*   
*   Messages:
*       /add, ss - add new address
*       /tog, si - toggle a particular player
*       /set, sisf - set up a new player
*       /change, sisf - change who a player is sending to
*       /play, sis - send a signal to a player
*/

Send con;

spork ~ add();
spork ~ tog();
spork ~ setup();
spork ~ change();
spork ~ play();
spork ~ send();

while( ms => now );

// Listeners
fun void add() {
    OscIn in;
    OscMsg msg;
    in.port( 57120 );
    while( true ) {
        in => now;
        while( in.recv( msg ) ) {
            if( msg.address == "/add" ) {
                msg.get
