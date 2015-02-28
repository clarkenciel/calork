// number ascii 
[49, 50, 51, 52, 53 ,54, 55] @=> int num[];

// number total addresses
["/0total", "/1total", "/2total", 
 "/3total", "/4total", "/5total", "/6total"] @=> string num_total_addr[];  

// number apm addresses
["/0apm", "/1apm", "/2apm", 
 "/3apm", "/4apm", "/5apm", "/6apm"] @=> string num_apm_addr[];  

[65, 66, 86] @=> int char[];

// stores values sending
int num_total[7];
int num_apm[7];


"Apple Internal Keyboard / Trackpad" => string keyboardName;
"USB Optical Mouse" => string mouseName;

Hid keyboard[5];
int whichKeyboard;

for (int i; i < keyboard.size(); i++) {
    HidMsg msg;
    if(keyboard[i].openKeyboard(i)) {
        if (keyboard[i].name() == keyboardName) {
            <<< keyboard[i].name() + " ready!", "" >>>;
            i => whichKeyboard;
            break;
        }
    }
}

Hid mouse[5];
int whichMouse;

for (int i; i < mouse.size(); i++) {
    if(mouse[i].openMouse(i)) {
        if (mouse[i].name() == mouseName) {
            <<< mouse[i].name() + " ready!", "" >>>;
            i => whichMouse;
            break;
        }
    }
}

fun void keyboardInput() {
    HidMsg msg;
    while (true) {
        keyboard[whichKeyboard] => now;
        while (keyboard[whichKeyboard].recv(msg)) {
            if (msg.isButtonDown()) {
                for (int i; i < num.size(); i++) {
                    <<< msg.ascii >>>;
                    if (msg.ascii == num[i]) {
                        spork ~ statistics(i, num_total, num_apm); 
                    }
                }
            }
        }
    }
}

fun void mouseInput() {
    HidMsg msg;
    while (true) {
        // wait on HidIn as event
        mouse[whichMouse] => now;
        
        // messages received
        while (mouse[whichMouse].recv(msg)) {

            // mouse button down
            if (msg.isButtonDown()) {
                <<< "mouse button", msg.which, "down" >>>;
            }
            // mouse button up
            else if( msg.isButtonUp()) {
                <<< "mouse button", msg.which, "up" >>>;
            }
        }
    }
}

keyboardInput();
mouseInput();

fun void statistics(int idx, int total[], int apm[]) {
    apm[idx]++;
    total[idx]++;
    //<<< total[idx], apm[idx] >>>;
    1::minute => now;
    apm[idx]--;
}

/*
So Either: /ed /atotal {value} or /eric /atotal {value} and so on.

(important keypresses)
/atotal
/aapm
/vtotal
/vamp
/btotal
/bapm
/misctotal
/miscapm

(mousestuff)
/mltotal
/mlapm
/mrtotal
/mrapm
/mmtotal
/mmapm
/mx
/my

(ControlGroups)
/0total
/0apm
/1total
/1apm
/2total
/2apm
/3total
/3apm
/4total
/4apm
/5total
/5apm
/6total
/6apm
*/
