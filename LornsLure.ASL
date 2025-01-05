state("LornsLure")
{
    long checkpoint0 : "UnityPlayer.dll", 0x017FE578, 0xA50, 0x2D8, 0x190, 0x150, 0x60, 0x98, 0x28;
    long checkpoint1 : "UnityPlayer.dll", 0x017FE578, 0xDE8, 0x2D8, 0x190, 0x150, 0x60, 0x98, 0x28;
    long checkpoint2 : "UnityPlayer.dll", 0x017FE578, 0xA60, 0x2D8, 0x190, 0x150, 0x60, 0x98, 0x28;
    float timer : "UnityPlayer.dll", 0x01840978, 0x140, 0x38,0xD0,0x18,0x0,0x98,0x127C;


 }

startup{
    
    settings.Add("ch1");
    settings.Add("ch2", false);
    settings.Add("ch3", false);
    settings.Add("ch4", false);
    settings.Add("ch5", false);
    settings.Add("ch6", false);
    settings.Add("ch7", false);
    settings.Add("ch8", false);
    settings.Add("logging");
    settings.Add("logging (checkpoints only)");
    settings.Add("notifications");
    refreshRate = 30;
}



init
{

    bool[] chapters = new bool[8] {
        settings["ch1"],
        settings["ch2"],
        settings["ch3"],
        settings["ch4"],
        settings["ch5"],
        settings["ch6"],
        settings["ch7"],
        settings["ch8"],
    };    

    vars.Chapter = Array.IndexOf(chapters, true);
    print(vars.Chapter.ToString());
    
    long[][] splits = new long[3][];

    splits[0] = new long[8]{ // chapter 1 wall
        -4373552839777700413,
        -4385081773233411850,
        -4320555043569424466,
        -4329197726793636250,
        -4337754568658742477,
        -4311594988003837215,
        -4324369023901106094,
        -4324369023901106094,
    };

    splits[1] = new long[6] { // chapter 2 failed
        (long)4684509228000795024,
        (long)4799339757095101457,
        (long)4810840824823091696,
        (long)4730130692769749402,
        (long)-4324834864661969512,
        (long)-4315743226360814132,
    };

    splits[2] = new long[4]{ //chapter 3 waste
        (long)-4406547053403452211,
        (long)-4279745393882900398,
        (long)-4274786506247099069,
        (long)-4267886147363575726,
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
        MessageBox.Show("Welcome to my Lorn's Lure Autosplitter! \n To calibrate the program, please restart Chapter 1. The Wall, and run the first three checkpoints until the timer starts. If the timer does not start after the third checkpoint, please hold T to reset and try again", "Needs calibration, lures need lorning");
    }

}   

update
{
    if (!vars.Setup) {
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
    else{
        

        if (vars.Base.GetType() == typeof(int)){
            IntPtr Base = IntPtr.Zero;
            vars.m = new DeepPointer("UnityPlayer.dll",vars.hexofs[vars.ofsind][0],
                                    vars.hexofs[vars.ofsind][1],vars.hexofs[vars.ofsind][2],
                                    vars.hexofs[vars.ofsind][3],vars.hexofs[vars.ofsind][4],
                                    vars.hexofs[vars.ofsind][5],vars.hexofs[vars.ofsind][6],
                                    vars.hexofs[vars.ofsind][7]).DerefOffsets(game, out Base);//.Deref<long>(game);
            vars.Base = Base;

            if (settings["logging"]){
                File.AppendAllText(vars.logs, "START: Base found: "+ vars.Base.ToString("x") + '\n');
            }
            if (settings["notifications"]){
                MessageBox.Show("System memory located, program is calibrated for use. \n Memory Address: "+vars.Base.ToString("x")+"\n Please ensure the right level is selected (via Edit Layout>Layout Settings>Scriptable Auto Splitter>Advanced), and that your matchings splits are opened :) \n Happy running!", "System Calibrated! Lure's Lorned.",MessageBoxButtons.OK, MessageBoxIcon.None, MessageBoxDefaultButton.Button1, MessageBoxOptions.DefaultDesktopOnly);
            }
        }
        
        vars.d = memory.ReadValue<long>((IntPtr)vars.Base);
        if(current.timer < old.timer){
            vars.Reset = true;
            vars.splitx=0;

            bool[] chapters = new bool[8] {
                settings["ch1"],
                settings["ch2"],
                settings["ch3"],
                settings["ch4"],
                settings["ch5"],
                settings["ch6"],
                settings["ch7"],
                settings["ch8"],
            };    

            vars.Chapter = Array.IndexOf(chapters, true);


            if (settings["logging"]){
                File.AppendAllText(vars.logs, "RESET: Chapter:"+vars.Chapter.ToString() + '\n');
            }
           
        }

        if (vars.d != vars.d2){
            vars.d2 = vars.d;
            if (settings["logging"]){
                File.AppendAllText(vars.logs, "UPDATE:"+vars.d.ToString() +" activated: next checkpoint: "+
                vars.splits[vars.Chapter][vars.splitx].ToString()+ '\n');
            }
            if (settings["logging (checkpoints only)"]){
                File.AppendAllText(vars.logs, vars.d.ToString()+"\n");
            }

            if (vars.d == vars.splits[vars.Chapter][vars.splitx]){
                vars.Split = true;
                vars.splitx++;
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


