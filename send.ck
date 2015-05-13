OscOut oout;

oout.dest("255.255.255.255", 6449);

while(true)
{
    for(0 => int i; i < 4; i++)
    {
        oout.start("/ping");
        oout.add(i);
        oout.send();
        
        0.5::second => now;
    }
}
