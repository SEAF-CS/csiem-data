#!/bin/bash
matlab_exec=matlab
echo "execute_import_pipeline();" > matlab_command.m
${matlab_exec} -nodisplay -nosplash -nodesktop < matlab_command.m
rm matlab_command.m
