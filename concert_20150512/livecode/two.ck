OscIn in;
OscMsg m;
in.port(57120);
in.listenAll();
adc => LiSa l => dac;
l.duration(minute);
int rec;
int play;
l.record(1);

spork ~ listen();
while(ms => now);

fun void listen()
{
while(true)
{
    in => now;
    while(in.recv(m))
    {
        if(m.address.find("bang"))
        {
        }
        if(m.address.find("float"))
        {
            l.rate(m.getFloat(0));
            l.play(1);
        }
        if(m.address.find("int"))
        {
        }
    }
}
}
