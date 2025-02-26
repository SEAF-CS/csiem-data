#!/bin/bash
matlab_exec=matlab
echo "execute_import_pipeline();
exit();"| ${matlab_exec} -nodisplay -nosplash -nodesktop &> 'MonitoredPipelineRun/MonitoredMatlab(8UpdateingWWMSP3SedData_SMD_Matfiles_Marvl).txt'
#'MonitoredPipelineRun/MonitoredFullRUN2.txt' 

# #!/bin/bash
# matlab_exec=matlab
# echo "addpath(genpath('../functions'));
# plot_datawarehouse_csv_all(0);
# exit();"| ${matlab_exec} -nodisplay -nosplash -nodesktop