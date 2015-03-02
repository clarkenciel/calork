// non-conductor "part"
// Author: Danny Clarke

KBHit k;
Rec r;
ChainOut s;

// Sound Chain
r => BPF b => s => NRev rev => Gain g => dac;
s => Delay d => rev;

// control vars
1.0 => float Q; 440 => float bFreq;
0.5 => float master;
int kVal;

s.op(4);
b.set( bFreq, Q ); g.gain( master );
rev.mix(0.05);
d.max(44100::samp);
d.delay(1::ms);

//----------------SPORKED OFF FUNCS--------------
spork ~ r.listen();
spork ~ s.listen();
spork ~ s.send();

//------------------WELCOME MESSAGE---------------
string welcome;
<<<"\n\n\t\tWelcome to Daisy!\n\n","">>>;
<<<"\tYou are a non-conductor.\n\tHere are your controls:\n\n","">>>;
"\tUp/Down Arrows: Increase/Decrease BPF Q\n" +=> welcome;
"\tRight/Left Arrows: Increase/Decrease BPF Frequency\n" +=> welcome;
"\t+/-: Increase/Decrease Gain\n" +=> welcome;
"\tSPACE: View current settings\n" +=> welcome;
"\tENTER: View these commands again\n\n" +=> welcome;
"-------------------------------------------------------------"+=> welcome;
<<< welcome,"" >>>;

//-------------KEYBOARD COMMANDS LISTENER---------
while( true ) {
    k => now;
    while( k.more() ) {
        k.getchar() => kVal;
        if( kVal == 32 ) {
            <<< "\n\nBPF Q:", b.Q(), "BPF Freq", b.freq(),"Gain:",g.gain(), "\n\n","" >>>;
        }
        if( kVal == 72 ) {
            if( Q + 1 < 200.0 ) {
                1 +=> Q;
                Q => b.Q;
                <<< "Q:", b.Q(),"">>>;
            } else {
                <<< "Maximum Allowed reached:","">>>;
            }
        }
        if( kVal == 80 ) {
            if( Q - 1 > 1.0 ) {
                1 -=> Q;
                Q => b.Q;
                <<< "Q:", b.Q(),"">>>;
            } else {
                <<< "Minimum Allowed reached:","">>>;
            }
        }
        if( kVal == 77 ) {
            if( bFreq + 10 < 15000 ) {
                10 +=> bFreq;
                bFreq => b.freq;
                <<< "BPF Freq:", b.freq(),"" >>>;
            } else {
                <<< "Maximum Allowed reached:","">>>;
            }
        }
        if( kVal == 75 ) {
            if( bFreq - 10.0 > 100 ) {
                10 -=> bFreq;
                bFreq => b.freq;
                <<< "BPF Freq:", b.freq(),"" >>>;
            } else {
                <<< "Minimum Allowed reached:","">>>;
            }
        }
        if( kVal == 61 || kVal == 43 ) {
            if( master + 0.05 <= 1.25 ) {
                0.05 +=> master;
                master => g.gain;
                <<< "Gain:",g.gain(),"">>>;
            } else {
                <<< "Maximum Allowed reached:","">>>;
            }

        }
        if( kVal == 45 || kVal == 95 ) {
            if( master - 0.05 >= 0.01 ) {
                0.05 -=> master;
                master => g.gain;
                <<< "Gain:",g.gain(),"">>>;
            } else {
                <<< "Minimum Allowed reached:","">>>;
            }
        }
        if( kVal == 13 ) {
            <<< "\n\n","">>>;
            <<< "\n\tBPF Q:", b.Q(), "BPF Freq", b.freq(),"Gain:",g.gain(), "\n\n","" >>>;
            <<< welcome,"" >>>;
        }
    }
}
