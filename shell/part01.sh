#!/bin/bash -e
# unzip original zip files

workdir="$1"
config="$2"

# load config file
source ${config}

cd ${workdir}
if [ -e input_files ];then rm -r input_files; fi
mkdir -p input_files

case ${SATELLITE_TYPE} in
    ALOS)
        cd ${workdir}/input_files_orig
        for zip_file in `ls -F *.zip`
        do
            level=`basename $zip_file .zip | awk -F"-" '{print $2}'`
            # when processing level 1.0
            if [ $level = "L1.0" ]; then 
                unzip $zip_file -d ${workdir}/input_files
            # when processing level 1.1
            else
                dir_name=`basename $zip_file .zip | awk -F"-" '{print $1}'`
                mkdir -p ${workdir}/input_files/${dir_name}
                unzip $zip_file -d ${workdir}/input_files/${dir_name}
            fi
        done
    ;;
    
    ALOS2)
        cd ${workdir}/input_files_orig
        for zip_file in `ls -F *.zip`
        do
            dir_name=`basename $zip_file .zip | awk -F"_" '{print $3}'`
            mkdir -p ${workdir}/input_files/${dir_name}
            unzip $zip_file -d ${workdir}/input_files/${dir_name}
        done
    ;;
    
    RSAT2)
    ;;

    TSX)
        cd ${workdir}/input_files_orig
        for zip_file in `ls -F *.ZIP`
        do
            # dir_name=`basename $zip_file .zip | awk -F"_" '{print $3}'`
            # mkdir -p ${workdir}/input_files/${dir_name}
            unzip $zip_file -d ${workdir}/input_files/
        done
    ;;

    CSK)
    ;;
  *)
    # usually not come here...
    echo "ERROR : invalid parameter"
    ;;
esac

