// APM
// Eric Heep
// Calork

"Apple Internal Keyboard / Trackpad" => string keyboardName;
"USB Optical Mouse" => string mouseName;

CalorkOsc c;

c.myAddr("/eric");

c.addIp("10.0.0.2", "/shauryja");
//c.addIp("10.0.0.3", "/shauryja");
//c.addIp("10.0.0.7", "/mike");
//c.addIp("10.0.0.5", "/justin");

c.setParams(["/0total", "/1total", "/2total", "/3total",
"/4total", "/5total", "/6total", "/0apm", "/1apm", "/2apm",
"/3apm", "/4apm", "/5apm", "/6apm", "/atotal", "/vtotal", "/btotal", 
"/aapm", "/vapm", "/bapm", "/mltotal", "/mrtotal", "/mmtotal",
"/mlapm", "/mrapm", "/mmapm", "/mx" ]);

//spork ~ c.recv();

// durations 
30 => int num_durs;
dur durations[num_durs];

for (int i; i < num_durs; i++) {
    0.5::second * (i + 1) => durations[i];
}

// number ascii 
[49, 50, 51, 52, 53 ,54, 55] @=> int num[];

// number addresses
["/0total", "/1total", "/2total", 
 "/3total", "/4total", "/5total", "/6total"] @=> string num_total_addr[];  
["/0apm", "/1apm", "/2apm", 
 "/3apm", "/4apm", "/5apm", "/6apm"] @=> string num_apm_addr[];  

// number arrays
int num_total[7];
float num_apm[7][num_durs];

// character ascii
[65, 66, 86] @=> int char[];

// character addresses
["/atotal", "/vtotal", "/btotal"] @=> string char_total_addr[];
["/aapm", "/vapm", "/bapm"] @=> string char_apm_addr[];

int char_total[3];
float char_apm[3][num_durs];

["/mltotal", "/mrtotal", "/mmtotal"] @=> string mouse_total_addr[];
["/mlapm", "/mrapm", "/mmapm"] @=> string mouse_apm_addr[];

int mouse_total[3];
float mouse_apm[3][num_durs];

["/misctotal", "/miscapm"] @=> string overall_addr[];

int overall_total;
float overall_apm[num_durs];

// keyboard setup
Hid keyboard[5];
int whichKeyboard;

for (int i; i < keyboard.size(); i++) {
    if(keyboard[i].openKeyboard(i)) {
        if (keyboard[i].name() == keyboardName) {
            <<< keyboard[i].name() + " ready!", "" >>>;
            i => whichKeyboard;
            break;
        }
    }
}

// mouse setup
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
                    if (msg.ascii == num[i]) {
                        overallStatistics();
                        statistics(i, num_total, num_apm, num_total_addr[i], num_apm_addr[i]); 
                    }
                }
            }
        }
    }
}

fun void mouseInput() {
    HidMsg msg;
    while (true) {
        mouse[whichMouse] => now;
        while (mouse[whichMouse].recv(msg)) {
            if (msg.isButtonDown()) {
                msg.which => int idx;
                overallStatistics();
                statistics(idx, mouse_total, mouse_apm, mouse_total_addr[idx], mouse_apm_addr[idx]);
            }
            else { 
                c.send("/all", "/mx", msg.fdata);
            }
        }
    }
}

spork ~ keyboardInput();
spork ~ mouseInput();

fun void statistics(int which, int total[], float apm[][], string t_addr, string a_addr) {
    float avg;
    total[which]++;
    for (int i; i < num_durs; i++) {
        spork ~ counter(i, apm[which]);        
        apm[which][i] +=> avg; 
    }
    c.send("/all", t_addr, total[which]);
    c.send("/all", a_addr, avg/num_durs);
}

fun void overallStatistics() {
    float avg;
    overall_total++;
    for (int i; i < num_durs; i++) {
        spork ~ counter(i, overall_apm);
        overall_apm[i] +=> avg;
    }
    c.send("/all", overall_addr[0], overall_total);
    c.send("/all", overall_addr[1], avg/num_durs);
}

fun void counter(int idx, float apm[]) {
    1 * (1::minute/durations[idx]) +=> apm[idx];
    durations[idx] => now;;    
    1 * (1::minute/durations[idx]) -=> apm[idx];
}
                             
<<< " ", "" >>>;
<<< "           ******             ", "" >>>;
<<< "  ******  /**///** ********** ", "" >>>;
<<< " //////** /**  /**//**//**//**", "" >>>;
<<< "  ******* /******  /** /** /**", "" >>>;
<<< " **////** /**///   /** /** /**", "" >>>;
<<< "//********/**      *** /** /**", "" >>>;
<<< " //////// //      ///  //  // ", "" >>>;
<<< " ", "" >>>;

while (true) {
    1::second => now;
}
