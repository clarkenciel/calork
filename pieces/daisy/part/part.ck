// non-conductor "part"
// Author: Danny Clarke

me.arg(0) => string name;

KBHit k; Hid kH; HidMsg kM;
kH.openKeyboard(0);
Rec r;
ChainOut s;
OscIn in; OscMsg m;
in.port(47120);
in.listenAll();

// Sound Chain
r => BPF b => s => NRev rev => Gain g => dac;
s => Delay d => rev;

// control vars
1.0 => float Q; 440 => float bFreq;
0.5 => float master;

b.set( bFreq, Q ); g.gain( master );
rev.mix(0.01);
d.max(44100::samp);
d.delay(1::ms);

//----------------SPORKED OFF FUNCS--------------
spork ~ s.listen(in);
spork ~ r.listen( name );
spork ~ s.send( name );
//spork ~ hidListen( kH, kM );
spork ~ kbhitListen();

//------------------WELCOME MESSAGE---------------
string welcome;
<<<"\n\n\t\tWelcome to Daisy",name,"!\n\n","">>>;
<<<"\tYou are a non-conductor.\n\tHere are your controls:\n\n","">>>;
"\tUp/Down Arrows: Increase/Decrease BPF Q\n" +=> welcome;
"\tRight/Left Arrows: Increase/Decrease BPF Frequency\n" +=> welcome;
"\t+/-: Increase/Decrease Gain\n" +=> welcome;
"\tSPACE: View current settings\n" +=> welcome;
"\tENTER: View these commands again\n\n" +=> welcome;
"-------------------------------------------------------------"+=> welcome;
<<< welcome,"" >>>;

while( ms => now );

//-------------KEYBOARD COMMANDS LISTENER---------
fun void hidListen( Hid kH, HidMsg k) {
    int kVal; int shift; int once;
    while( true ) {
        kH => now;
        while( kH.recv(k) ) {
            k.which => kVal;
            //<<< kVal >>>;
            if( kVal == 229 && shift > 0 ) {
                0 => shift;
            } else if( kVal == 229 && shift == 0 ) {
                1 => shift;
            }
            if( kVal == 44 ) {
                <<< "\n\nBPF Q:", b.Q(), "BPF Freq", b.freq(),"Gain:",g.gain(), "\n\n","" >>>;
            }
            if( kVal == 82 ) {
                if( Q + 1 < 200.0 ) {
                    1 +=> Q;
                    Q => b.Q;
                    <<< "Q:", b.Q(),"">>>;
                } else {
                    <<< "Maximum Allowed reached:","">>>;
                }
            }
            if( kVal == 81 ) {
                if( Q - 1 > 1.0 ) {
                    1 -=> Q;
                    Q => b.Q;
                    <<< "Q:", b.Q(),"">>>;
                } else {
                    <<< "Minimum Allowed reached:","">>>;
                }
            }
            if( kVal == 79 ) {
                if( bFreq + 10 < 15000 ) {
                    10 +=> bFreq;
                    bFreq => b.freq;
                    <<< "BPF Freq:", b.freq(),"" >>>;
                } else {
                    <<< "Maximum Allowed reached:","">>>;
                }
            }
            if( kVal == 80) {
                if( bFreq - 10.0 > 100 ) {
                    10 -=> bFreq;
                    bFreq => b.freq;
                    <<< "BPF Freq:", b.freq(),"" >>>;
                } else {
                    <<< "Minimum Allowed reached:","">>>;
                }
            }
            if( kVal + shift == 47 || kVal + shift == 46 ) {
                if( master + 0.05 <= 1.25 ) {
                    0.05 +=> master;
                    master => g.gain;
                    <<< "Gain:",g.gain(),"">>>;
                } else {
                    <<< "Maximum Allowed reached:","">>>;
                }
                
            }
            if( kVal + shift == 45 || kVal + shift == 45 ) {
                if( master - 0.05 >= 0.01 ) {
                    0.05 -=> master;
                    master => g.gain;
                    <<< "Gain:",g.gain(),"">>>;
                } else {
                    <<< "Minimum Allowed reached:","">>>;
                }
            }
            if( kVal == 40 ) {
                <<< "\n\n","">>>;
                <<< "\n\tBPF Q:", b.Q(), "BPF Freq", b.freq(),"Gain:",g.gain(), "\n\n","" >>>;
                <<< welcome,"" >>>;
            }
        }
    }
}

fun void kbhitListen() {
    int kVal;
    while( true ) {
        k => now;
        while( k.more() ) {
            k.getchar() => kVal;
	    //<<< kVal >>>;
            if( kVal == 32 ) {
                <<< "\n\nBPF Q:", b.Q(), "BPF Freq", b.freq(),"Gain:",g.gain(), "\n\n","" >>>;
            }
            if( kVal == 72 || kVal == 65 ) {
                if( Q + 1 < 200.0 ) {
                    1 +=> Q;
                    Q => b.Q;
                    <<< "Q:", b.Q(),"">>>;
                } else {
                    <<< "Maximum Allowed reached:","">>>;
                }
            }
            if( kVal == 80 || kVal == 66 ) {
                if( Q - 1 > 1.0 ) {
                    1 -=> Q;
                    Q => b.Q;
                    <<< "Q:", b.Q(),"">>>;
                } else {
                    <<< "Minimum Allowed reached:","">>>;
                }
            }
            if( kVal == 77 || kVal == 67 ) {
                if( bFreq + 10 < 15000 ) {
                    10 +=> bFreq;
                    bFreq => b.freq;
                    <<< "BPF Freq:", b.freq(),"" >>>;
                } else {
                    <<< "Maximum Allowed reached:","">>>;
                }
            }
            if( kVal == 75 || kVal == 68) {
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
}
