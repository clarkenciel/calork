OscIn oin;
6449 => oin.port;

"/ping" => oin.addAddress;

Impulse i => ResonZ filter => dac;
150 => filter.Q;

while(true)
{
    oin => now;
    <<< "ping" >>>;
    Math.random2f(72, 96) => Std.mtof => filter.freq;
    100 => i.next;
}
