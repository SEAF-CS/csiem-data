#!/bin/bash
matlab_exec=matlab
echo "execute_import_pipeline();
exit();"| ${matlab_exec} -nodisplay -nosplash -nodesktop > 'FullPipelineRun.txt' 

# #!/bin/bash
# matlab_exec=matlab
# echo "addpath(genpath('../functions'));
# plot_datawarehouse_csv_all(1);
# exit();"| ${matlab_exec} -nodisplay -nosplash -nodesktop