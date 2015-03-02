FileIO f;
f.open( "stickers.txt", FileIO.READ | FileIO.ASCII );
f.readLine() => string line;
chout <= line; chout.flush();
