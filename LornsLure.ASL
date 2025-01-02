state("LornsLure")
{
    long checkpoint2 : "UnityPlayer.dll", 0x017FE578, 0xA50, 0x2D8, 0x190, 0x150, 0x60, 0x98, 0x28;
    long checkpoint0 : "UnityPlayer.dll", 0x017FE578, 0xDE8, 0x2D8, 0x190, 0x150, 0x60, 0x98, 0x28;
    long checkpoint1 : "UnityPlayer.dll", 0x017FE578, 0xA60, 0x2D8, 0x190, 0x150, 0x60, 0x98, 0x28;



 }

startup{
    settings.Add("mission1");
    settings.Add("mission2");
    settings.Add("mission3");
    settings.Add("mission4");
    settings.Add("mission5");
    settings.Add("mission6");
    settings.Add("mission7");

}



init
{
    vars.logs = "logs.txt";
    vars.Base = 0;
    vars.d = 0;
    vars.d2 = 0;

    vars.splitx=0;
    long[] splits = new long[8] {
        -4373552839777700413,
        -4385081773233411850,
        -4320555043569424466,
        -4329197726793636250,
        -4337754568658742477,
        -4311594988003837215,
        -4324369023901106094,
        -4324369023901106094,
    };

    vars.splits = splits;

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

        

        //print(validpointers.ToString());

        for (int i = 0; i < checkpointers.Length; i++) {
            for (int ii = 0; ii < checkvals.Length; ii++){
                if (checkpointers[i]== checkvals[ii]){
                    //print("found value in pointer");
                    //print(checkpointers[i].ToString());
                    
                    if (Array.IndexOf(vars.validpointers[i], checkvals[ii]) == -1){
                        vars.validpointers[i][ii] = checkvals[ii];
                    }
                    print(i.ToString()+":"+"["+ vars.validpointers[i][0].ToString() +","+
                    vars.validpointers[i][1].ToString()+ ","+
                    vars.validpointers[i][2].ToString()+"]");
                }
            }
        }

        for (int jj = 0; jj < vars.validpointers.Length; jj++ ){
            int containsNull = Array.IndexOf(vars.validpointers[jj], (long)0);
            if (containsNull == -1){
                vars.Setup = true;
                print("perfect pointer found");
                print(jj.ToString());
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
                                    vars.hexofs[vars.ofsind][7]).DerefOffsets(game, out Base);//.Deref<long>(game);
            vars.Base = Base;
            print(vars.Base.ToString());
        }

        if (current.checkpoint2 != old.checkpoint2){
            if(current.checkpoint2.ToString() == "0"){
                print(old.checkpoint2.ToString()+">"+current.checkpoint2.ToString());
                print("pointer reset!!!");
                vars.IsLoading = true;
                vars.Reset = false;
            }
            if(old.checkpoint2.ToString() == "0"){
                print(old.checkpoint2.ToString()+">"+current.checkpoint2.ToString());
                print("pointer reset!!!");
                vars.IsLoading = false;
                vars.Reset = true;
            }
        }



        if (vars.d != vars.d2){
            print(vars.d.ToString()+"<"+vars.d2.ToString());
            vars.d2 = vars.d;
            print("checkpoint changed yipee!!!");
            File.AppendAllText(vars.logs, vars.d.ToString() + '\n');

            if (vars.d == vars.splits[vars.splitx]){
                vars.Split = true;
                vars.splitx++;
            }
            

        }

        
        vars.d = memory.ReadValue<long>((IntPtr)vars.Base);
        //print(vars.Base.ToString("x"));
        //print(vars.d.ToString());
        //print(vars.d2.ToString());

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
    print("yippee");
    return true;
    }

