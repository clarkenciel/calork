// non-conductor "part"
// Author: Danny Clarke

KBHit k;
Rec r;
ChainOut s;

r => BPF b => s => Gain g => dac;

// control vars
1.0 => float Q; 440 => float bFreq;
0.5 => float master;
int kVal;

b.set( bFreq, Q ); g.gain( master );

spork ~ r.listen();
spork ~ s.listen();
spork ~ s.send();

while( true ) {
    k => now;
    while( k.more() ) {
        k.getchar() => kVal;
        //<<< kVal >>>;
        if( kVal == 32 ) {
            <<< "BPF Q:", b.Q(), "BPF Freq", b.freq(),"Gain:",g.gain(),"" >>>;
        }
        if( kVal == 104 ) {
            if( Q + 1 < 200.0 ) {
                1 +=> Q;
                Q => b.Q;
                <<< "Q:", b.Q(),"">>>;
            } else {
                <<< "Maximum Allowed reached:","">>>;
            }
        }
        if( kVal == 106 ) {
            if( Q - 1 > 1.0 ) {
                1 -=> Q;
                Q => b.Q;
                <<< "Q:", b.Q(),"">>>;
            } else {
                <<< "Minimum Allowed reached:","">>>;
            }
        }
        if( kVal == 107 ) {
            if( bFreq + 10 < 15000 ) {
                10 +=> bFreq;
                bFreq => b.freq;
                <<< "BPF Freq:", b.freq(),"" >>>;
            } else {
                <<< "Maximum Allowed reached:","">>>;
            }
        }
        if( kVal == 108 ) {
            if( bFreq - 10.0 > 100 ) {
                10 -=> bFreq;
                bFreq => b.freq;
                <<< "BPF Freq:", b.freq(),"" >>>;
            } else {
                <<< "Minimum Allowed reached:","">>>;
            }
        }
        if( kVal == 72 ) {
            if( master + 0.05 <= 0.9 ) {
                0.05 +=> master;
                master => g.gain;
                <<< "Gain:",g.gain(),"">>>;
            } else {
                <<< "Maximum Allowed reached:","">>>;
            }

        }
        if( kVal == 80 ) {
            if( master - 0.05 >= 0.01 ) {
                0.05 -=> master;
                master => g.gain;
                <<< "Gain:",g.gain(),"">>>;
            } else {
                <<< "Minimum Allowed reached:","">>>;
            }
        }
    }
}
