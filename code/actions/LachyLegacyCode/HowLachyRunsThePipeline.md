# Running Pipeline 
My Current method of running the pipeline is double checking the execute_import_pipeline.m script to ensure that its going to run the desired parts, I then open the shell script called run_LAC.sh and ensure that the output text file is one that I dont mind overwriting, or simply change to a new name. Then I open a new ssh terminal navigate to actions (cd /GIS_DATA/csiem-data-hub/csiem-data/code/actions/) and run the "bash run_LAC.sh &> OUTLOG.lg &" and then i exit with the command "exit". I think the exit command is necessary when doing this I dont know how or why but i think it then doesnt rely on that terminal staying open to keep running, (in my experience if you leave the terminal open in the background it times out and that appears to cause the matlab to silently crash). Anecdoatally i dont think it has silently crashed since i have started exitting after intitiallising a run.

# Summary
1. Check execute_import_pipeline.m for what you want to import
2. Check the output file name in run_LAC.sh to ensure you arent overriding important information
3. Open a new terminal and ssh into Davy
   
        ssh hydro@130.95.44.8
4. Change into actions dir
    
        cd /GIS_DATA/csiem-data-hub/csiem-data/code/actions/ 
5. Run bash script (In trying to find silent error causes i started pipeing all outputs somewhere, this could probably be skipped, &> filename, pipes standard error and outputs to filename, the final & puts everything in the background)

        bash run_LAC.sh &> 'NameOfTopLog.log' &
6. Im not sure why, but after the script has been initialised I always "disociate" the task with the current shell environment (which has seemed to help with silent crashes) by running the command:
   
        exit
