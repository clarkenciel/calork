// keyboard setup
Hid keyboard[5];
int whichKeyboard;

for (int i; i < keyboard.size(); i++) {
    if(keyboard[i].openMouse(i)) {
        <<< keyboard[i].name() >>>;
    }
}
