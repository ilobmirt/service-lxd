#!/bin/bash

#=================================================================================================#
#set_path.sh
#----------
#By: ilobmirt @ 2023_01_08
#
# It combines the existing set of paths that it points to and also makes sure that other defined
#paths are included as well in a unique fashion
#=================================================================================================#

#The main function that executes our program
add_to_path(){

  local path_to_add=$( echo "$1" | sed -e 's|:|\n|g' )
  local calc_path=$( echo "${PATH}" | sed -e 's|:|\n|g' )
  
  for path_index in $path_to_add ; do
    if [[ ! (${calc_path[*]} =~ ${path_index}) ]] ; then
      calc_path=$(echo -e "${calc_path}\n${path_index}")
    fi
  done
  
  PATH=$(echo "${calc_path}" | sed -r -z 's|\n|:|g' | sed 's|:$||')
  
}

#TO-DO: append add_to_path commands at the end of the script
#This would be typically done with ANSIBLE and go much like...

#add_to_path /target_dir/bin:/another_target_dir/alt/path/bin

