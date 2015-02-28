// part patch
// Author: Danny Clarke
/* Jist:
*   Player receives data and instructions about where to send signal
*       from conductor. player has keyboard commands to change the data of the
*       signal
*/

KBHit k;
Rec r;

BPF b => Gain g => dac;
1.0 => float Q; 400.0 => float freq;
bpf.set( freq, Q );

spork ~ r.setup();
spork ~ r.play();
spork ~ r.change();
spork ~ r.send( b, g );

while( true ) {
    k => now;

// funcs

