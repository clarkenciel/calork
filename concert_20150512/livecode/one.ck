OscOut out[2];
out[0].dest("10.0.0.2", 57120);
out[1].dest("10.0.0.5", 57120);

SinOsc s => blackhole;
s.gain(1);
s.freq(0.1);

while(minute => now)
{
    for(int i; i < out.size(); i++)
    {
        out[i].start("/danny/bang").add(1).send();
        out[i].start("/danny/float").add(Math.fabs(s.last())).send();
    }
}
