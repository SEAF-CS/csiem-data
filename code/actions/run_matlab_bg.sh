#!/bin/bash
matlab_exec=matlab
echo "execute_import_pipeline();
exit();"| ${matlab_exec} -nodisplay -nosplash -nodesktop > 'FullPipelineRun.txt' &