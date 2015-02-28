me.dir() => string d;

Machine.add( d + "source.ck" ) => int source;
Machine.add( d + "cond.ck" ) => int cond;
<<< "\n\n\n\t\tRUN THIS FILE IN A LOOPING VM: chuck condScore.ck --loop\n\n","" >>>;
<<< "\tSupport files now loaded. Use the 'ctls.ck' file to send commands:","">>>;
<<< "\t\tctls.ck:addMem:name:ip - to add member and ip","">>>;
<<< "\t\tctls.ck:connect:from:to - to connect two members","">>>;
<<< "\t\tctls.ck:disconnect:name - to disconnect a member","">>>;
<<< "\t\tctls.ck:send:name - to send the source signal to a member","">>>;
while( ms => now );
