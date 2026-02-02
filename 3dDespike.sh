#!/bin/bash 

main="/Volumes/Dissertation-Data/DAYS_FSL/Year1"
runs=("Driving_run1_15" "Driving_run2_18")
subjects=("1148")
all_files_exist=true
# First loop: Despike all subjects
for s in "${subjects[@]}"; do
    for r in "${runs[@]}"; do
        if [ ! -f "${main}/DAYS_${s}/${r}/d+orig.BRIK.gz" ]; then
            echo "Despiking Subject ${s} Run ${r}"
            3dDespike -NEW -nomask -prefix "${main}/DAYS_${s}/${r}/d" "${main}/DAYS_${s}/${r}/${r}.nii.gz"
        else 
            echo "${s} ${r} already despiked"
        fi
    done
done

echo "+++++++++++++++++++++++++++++++++++++++++++++"
echo "All files Despiked"
echo "+++++++++++++++++++++++++++++++++++++++++++++"
echo ""
echo "Converting BRIK files to NIFTI"

# Second loop: Convert all despiked files to unzipped NIFTI
for s in "${subjects[@]}"; do
    for r in "${runs[@]}"; do
        if [ ! -f "${main}/DAYS_${s}/${r}/d${r}.nii" ]; then
            echo "Converting AFNItoNIFTI: ${s} ${r}"
            3dAFNItoNIFTI -prefix "${main}/DAYS_${s}/${r}/d${r}.nii.gz" "${main}/DAYS_${s}/${r}/d+orig.BRIK"
            #gunzip "${main}/DAYS_${s}/${r}/d${r}.nii.gz"
            # Check if the file was successfully created
            if [ ! -f "${main}/DAYS_${s}/${r}/d${r}.nii.gz" ]; then
                echo "Error: Conversion failed for Subject ${s} Run ${r}"
                all_files_exist=false
            fi
        fi
    done
done

if [ ${all_files_exist} = true ]; then
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "All files successfully despiked and converted to NIFTI!"
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
else 
    echo "Error: Some files were not converted successfully."
fi
