state("LornsLure")
{
    float checkpoint2 : "UnityPlayer.dll", 0x017FE578, 0xA50, 0x2D8, 0x190, 0x150, 0x60, 0x98, 0x28;
    float checkpoint0 : "UnityPlayer.dll", 0x017FE578, 0xDE8, 0x2D8, 0x190, 0x150, 0x60, 0x98, 0x28;
    float checkpoint1 : "UnityPlayer.dll", 0x017FE578, 0xA60, 0x2D8, 0x190, 0x150, 0x60, 0x98, 0x28;
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
    
    float[] splits = new float[8] {
        (float)83.10500336,
        (float)225.9100037,
        (float)404.2000122,
        (float)-549.5999756,
        (float)-786.2999878,
        (float)-1385.839966,
        (float)-1376.01001,
        (float)-1657.72998,
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

    float[][] validpointers = new float[3][];
    validpointers[0] = new float[3];
    validpointers[1] = new float[3];
    validpointers[2] = new float[3];

    vars.validpointers = validpointers;
    vars.hexofs = hexofs;
    vars.ofsind = false;


}   

update
{
    if (!vars.Setup) {
        float[] checkvals = new float[3] {
            (float)0.6000000238,(float)-1.600000024,(float)5.889999866
        };

        float[] checkpointers = new float[3] {
            current.checkpoint0,
            current.checkpoint1,
            current.checkpoint2,
        };

        
        for (int i = 0; i < checkpointers.Length; i++) {
            for (int ii = 0; ii < checkvals.Length; ii++){
                if (checkpointers[i]== checkvals[ii]){
                    
                    if (Array.IndexOf(vars.validpointers[i], checkvals[ii]) == -1){
                        vars.validpointers[i][ii] = checkvals[ii];
                    }

                    // print(i.ToString()+":"+"["+ vars.validpointers[i][0].ToString() +","+
                    // vars.validpointers[i][1].ToString()+ ","+
                    // vars.validpointers[i][2].ToString()+"]");
                }
            }
        }

        for (int jj = 0; jj < vars.validpointers.Length; jj++ ){
            int containsNull = Array.IndexOf(vars.validpointers[jj], (float)0);
            if (containsNull == -1){
                vars.Setup = true;
                // print("perfect pointer found");
                // print(jj.ToString());
                vars.ofsind = jj;
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
                                    vars.hexofs[vars.ofsind][7]).DerefOffsets(game, out Base);//.Deref<float>(game);
            vars.Base = Base;
            print(vars.Base.ToString());
        }

        vars.d = memory.ReadValue<float>((IntPtr)vars.Base);
        
        if(current.timer < old.timer){
            vars.Reset = true;
            vars.splitx=0;
            if (settings["logging"]){
                File.AppendAllText(vars.logs, "" + '\n');
            }
           
        }

        if (vars.d != vars.d2){
            vars.d2 = vars.d;
            if (settings["logging"]){
                File.AppendAllText(vars.logs, vars.d.ToString("") + '\n');
            }

            if (vars.d == vars.splits[vars.splitx]){
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
onSplit{vars.Split = false;}

isLoading{return vars.IsLoading;}

reset{return vars.Reset;}
onReset{vars.Reset = false;}

start{
    // print("yippee");
    return true;
    }


