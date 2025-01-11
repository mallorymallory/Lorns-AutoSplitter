state("LornsLure")
{
    long checkpoint0 : "UnityPlayer.dll", 0x017FE578, 0xA50, 0x2D8, 0x190, 0x150, 0x60, 0x98, 0x28;
    long checkpoint1 : "UnityPlayer.dll", 0x017FE578, 0xDE8, 0x2D8, 0x190, 0x150, 0x60, 0x98, 0x28;
    long checkpoint2 : "UnityPlayer.dll", 0x017FE578, 0xA60, 0x2D8, 0x190, 0x150, 0x60, 0x98, 0x28;
    float timer0 : "UnityPlayer.dll", 0x01840978, 0x140, 0x38,0xD0,0x18,0x0,0x98,0x127C;
    float timer1 : "UnityPlayer.dll", 0x01840978, 0x140, 0x48,0xD0,0x18,0x0,0x98,0x127C;
    float timer2 : "UnityPlayer.dll", 0x018136F8, 0x110, 0x480, 0x10, 0x38, 0x0, 0x16CC;
    float timer3 : "UnityPlayer.dll"+ 0x01812AF8, 0x110, 0x480, 0x10, 0x38, 0x0, 0x16CC;
    int end : "mono-2.0-bdwgc.dll", 0x0049D208, 0x198, 0x410, 0x720, 0x100, 0x208, 0x40, 0xC0;
 }  //int end : "mono-2.0-bdwgc.dll", 0x0049D208, 0x198, 0x428, 0x710, 0x100, 0x208, 0x40, 0xC0

startup{
    settings.Add("ch1");
    settings.Add("ch2", false);
    settings.Add("ch3", false);
    settings.Add("ch4", false);
    settings.Add("ch5", false);
    settings.Add("ch6", false);
    settings.Add("ch7", false);
    settings.Add("ch8", false);
    settings.Add("full run", false);
    settings.Add("logging", false);
    settings.Add("logging (checkpoints only)", false);
    settings.Add("notifications");

    refreshRate = 30;
}

init
{
    bool[] chapters = new bool[9] {
        settings["ch1"],    settings["ch2"],
        settings["ch3"],    settings["ch4"],
        settings["ch5"],    settings["ch6"],
        settings["ch7"],    settings["ch8"],
        settings["full run"]
    };    

    vars.Chapter = Array.IndexOf(chapters, true);
    long[][] splits = new long[9][];

    splits[0] = new long[]{ // chapter 1 wall
        -4373552839777700413,
        -4385081773233411850,
        -4320555043569424466,
        -4329197726793636250,
        -4337754568658742477,
        -4311594988003837215,
        -4324369023901106094,
    };

    splits[1] = new long[] { // chapter 2 failed
        4684509228000795024,
        4799339757095101457,
        4810840824823091696,
        4730130692769749402,
        -4324834864661969512,
    };

    splits[2] = new long[]{ //chapter 3 waste
        -4406547053403452211,
        -4279745393882900398,
        -4274786506247099069,
    };

    splits[3] = new long[]{ //chapter 4 cistern
        4747694716686172161,
        4684644321929347072,
        -4794715118743255450,
        4614568391451473019,
        4604479822516042196,
        4571333944988624732,
        4603399002591013292,
        4604479822524100608,
        4546834626904515789,
        4691850108846158643,
        4604479822527998771,
        4728779612048236126,
        4744767404469858260,
        4650416868581083879,
        4660324842737057792,
        -4520262997653782938,
        -4352391263131809382,
    };

    splits[4] = new long[]{ //chapter 5 undercity
        -4337361912066390098,
        -4282001413530963149,
        -4271907018453931131,
        -4278644119229232579,
        -4281347685145813975,
        -4282291334545211392,
        -4288547817693413212,
        -4278141687460527309,
        -4278210299554593341,
    };

    splits[5] =  new long[]{ //chapter 6 foundation
        -4306792321252589568,
        -4310296685985975501,
        -4252664682334421811,
        -4251208048463782707,
        -4248863009203407667,
        -4254128351344776397,
        -4243120921396469760,
    };

    splits[6] = new long[]{ //chapter 7 sunken
        4797752238431371592,
        4851744770526680515,
        4907357188195675996,
        4926508748020474675,
        4926515783181473382,
        4940464977965308969,
        4949125259825980792,
        4965292478802635162,
        4975571593968257843,
        4982768911183000044,
    };

    splits[7] = new long[]{ //chapter 8 dissolution
        4579620390657736049,
        4689102897389224591,
        -4388577689776506798,
        -4324464728666827325,
        -4321292504474303857,
        -4315994438979343536,
        -4288313488580126310,
        -4282194577509813453,
    };
    splits[8] = new long[]{ //full run, basic no segments
        0,0,0,0,0,0,0,0
    };
    
    vars.splitx = 0;
    vars.splits = splits;

    vars.logs = "logs.txt";
    vars.Base = 0;
    vars.d = 0;
    vars.d2 = 0;
    vars.Setup = false;
    vars.Split = false;
    vars.Reset = false;
    vars.IsLoading = false;
    vars.fgnore = false;

    vars.pointerOffsetSelector = 0;
    int[][] hexofs = new int[3][];
    hexofs[0] = new int[] {0x017FE578,0xA50,0x2D8,0x190,0x150,0x60,0x98,0x28};
    hexofs[1] = new int[] {0x017FE578,0xDE8,0x2D8,0x190,0x150,0x60,0x98,0x28};
    hexofs[2] = new int[] {0x017FE578,0xA60,0x2D8,0x190,0x150,0x60,0x98,0x28};

    long[][] validpointers = new long[3][];
    validpointers[0] = new long[3];
    validpointers[1] = new long[3];
    validpointers[2] = new long[3];

    vars.validpointers = validpointers;
    vars.hexofs = hexofs;
    vars.ofsind = false;
    if (settings["notifications"]){
        MessageBox.Show("welcome to Lorn's Lure autosplitter~ \n\nto calibrate the program, please restart Chapter 1. The Wall, and run the first three checkpoints until the timer0 starts. if the timer0 does not start after the third checkpoint, please hold T to reset and try again", "Needs calibration, lures need lorning",MessageBoxButtons.OK, MessageBoxIcon.None, MessageBoxDefaultButton.Button1, MessageBoxOptions.DefaultDesktopOnly);
    }
}   
File.AppendAllText(vars.logs, current.timer0.ToString() +","+current.timer1.ToString() +","+current.timer2.ToString() +","+current.timer3.ToString() + '\n');
update
{
    if (!vars.Setup) { // locating the checkpoint memory address from reliable chapter 1 pointers
        long[] checkvals = new long[3] {
            -4652038270201783910,4600156804709403853,-4581782114269365535
        };

        long[] checkpointers = new long[3] {
            current.checkpoint0,
            current.checkpoint1,
            current.checkpoint2,
        };

        
        for (int i = 0; i < checkpointers.Length; i++) {
            for (int ii = 0; ii < checkvals.Length; ii++){
                if (checkpointers[i]== checkvals[ii]){
                    if (Array.IndexOf(vars.validpointers[i], checkvals[ii]) == -1){
                        vars.validpointers[i][ii] = checkvals[ii];
                        if (settings["logging"]){
                            File.AppendAllText(vars.logs, 
                                "START:checkpoint found:"+
                                i.ToString()+":"+ii.ToString()+":"+
                                vars.validpointers[i][0].ToString()+","+
                                vars.validpointers[i][1].ToString()+","+
                                vars.validpointers[i][2].ToString()
                                + '\n');
                        }
                    }
                }
            }
        }

        for (int jj = 0; jj < vars.validpointers.Length; jj++ ){
            int containsNull = Array.IndexOf(vars.validpointers[jj], (long)0);
            if (containsNull == -1){
                vars.Setup = true;
                vars.ofsind = jj;
                if (settings["logging"]){
                    File.AppendAllText(vars.logs, "START: Pointer found: "+ vars.ofsind.ToString() + '\n');
                }
            }
        }
    }
    else{ // the splitting 
        
        if (vars.Base.GetType() == typeof(int)){ // init located memory address if not set
            IntPtr Base = IntPtr.Zero;
            vars.m = new DeepPointer("UnityPlayer.dll",vars.hexofs[vars.ofsind][0],
                                    vars.hexofs[vars.ofsind][1],vars.hexofs[vars.ofsind][2],
                                    vars.hexofs[vars.ofsind][3],vars.hexofs[vars.ofsind][4],
                                    vars.hexofs[vars.ofsind][5],vars.hexofs[vars.ofsind][6],
                                    vars.hexofs[vars.ofsind][7]).DerefOffsets(game, out Base);
            vars.Base = Base;
            if (settings["logging"]){
                File.AppendAllText(vars.logs, current.timer0.ToString("N2")+": START: Base found: "+ vars.Base.ToString("x") + '\n');
                File.AppendAllText(vars.logs, current.timer0.ToString("N2")+": START: end valid?: "+ current.end.ToString() + '\n');
            }
            if (settings["notifications"]){
                MessageBox.Show("System memory located, program is calibrated for use. \n\nMemory Address: "+vars.Base.ToString("x")+"\n\nDouble-check the level is selected (via Edit Layout>Layout Settings>Scriptable Auto Splitter>Advanced), and that the matching splits are opened :) \n\nHappy running!", "System Calibrated! Lure's Lorned.",MessageBoxButtons.OK, MessageBoxIcon.None, MessageBoxDefaultButton.Button1, MessageBoxOptions.DefaultDesktopOnly);
            }
        }
        vars.d = memory.ReadValue<long>((IntPtr)vars.Base);     // get current checkpoint value from memory 

        if (vars.d != vars.d2){                                 //check if checkpoint changed, and if split needed
            vars.d2 = vars.d;
            if (settings["logging"]){
                File.AppendAllText(vars.logs, current.timer0.ToString("N2")+": UPDATE:"+vars.d.ToString() +" activated: next checkpoint: "+
                vars.splits[vars.Chapter][vars.splitx].ToString()+ '\n');
            }
            if (settings["logging (checkpoints only)"]){
                File.AppendAllText(vars.logs, vars.d.ToString()+"\n");
            }
            if (vars.d == vars.splits[vars.Chapter][vars.splitx]){ 
                vars.Split = true;
                vars.splitx++;
                if (vars.Chapter == 8){                         // if full run, pause until timer0 resets (new level start)
                    vars.fgnore = true;
                    vars.IsLoading = true;
                }
            }
        }

	if (current.end != old.end){
        	if (current.end == 1 && old.end == 208601088){          //check if endscreen is showing > split
        	    vars.Split = true; 
        	    if (settings["logging"]){
        	        File.AppendAllText(vars.logs, current.timer0.ToString("N2")+": END: end trigger activated");
        	    }
        	}
		File.AppendAllText(vars.logs, current.timer0.ToString("N2")+": END: end trigger changed: "+old.end.ToString()+">"+current.end.ToString());
	}
        if(current.timer0 < old.timer0){                          // check if timer0 reset > reset (if not full run)
            if (!vars.fgnore){
                vars.Reset = true;
                vars.splitx=0;
            } 
            else {
                vars.fgnore = false;
                vars.IsLoading = false;
            }
            bool[] chapters = new bool[9] {
                settings["ch1"],    settings["ch2"],
                settings["ch3"],    settings["ch4"],
                settings["ch5"],    settings["ch6"],
                settings["ch7"],    settings["ch8"],
                settings["full run"]
            };    
            vars.Chapter = Array.IndexOf(chapters, true);
            if (settings["logging"]){
                File.AppendAllText(vars.logs, current.timer0.ToString("N2")+": RESET: Chapter:"+vars.Chapter.ToString() + '\n');
            }  
        }

    }
    if (!vars.Setup){
        return false;
    }
}

split{return vars.Split;}
onSplit{vars.Split = false;
    if (settings["logging"]){
        File.AppendAllText(vars.logs, "SPLIT: split" + '\n');
    }
}

isLoading{return vars.IsLoading;}

reset{return vars.Reset;}
onReset{vars.Reset = false;
    if (settings["logging"]){
        File.AppendAllText(vars.logs, "RESET: reset" + '\n');
    }
}

start{
    // print("yippee");
    return true;
    }


