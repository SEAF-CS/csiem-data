#!/bin/bash
matlab_exec=matlab
echo "execute_import_pipeline();
exit();"| ${matlab_exec} -nodisplay -nosplash -nodesktop &> 'FullPipelineRun1_11_2024.txt' 

# #!/bin/bash
# matlab_exec=matlab
# echo "addpath(genpath('../functions'));
# plot_datawarehouse_csv_all(0);
# exit();"| ${matlab_exec} -nodisplay -nosplash -nodesktop