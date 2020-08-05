#!/bin/bash

# this script can be run in an interactive job; set nprocs to the number of processors the interactive job is using
# salloc --x11=first -q debug -t 0:30:00 --nodes=1 -A marine-cpu
rgcmd="srun --ntasks=4"
# in a serial job
#rgcmd=""

set -x

module use -a /scratch1/NCEPDEV/nems/emc.nemspara/soft/modulefiles
ESMF_BINDIR="/scratch1/NCEPDEV/nems/emc.nemspara/soft/esmf/8.0.1-intel18.0.5.274-impi2018.0.4-netcdf4.7.4_parallel.release/bin"
SCRIP_DIR="/scratch2/NCEPDEV/climate/Denise.Worthen/TTout"
FIX_DIR="/scratch1/NCEPDEV/global/glopara/fix/fix_fv3_gmted2010"
OUT_DIR="/scratch2/NCEPDEV/stmp1/Denise.Worthen/ForShan/mapped_omask"
meth="conserve"


declare -a sorcList=("Ct.mx025" "Ct.mx100" "Ct.mx050" "Ct.mx100" "Ct.mx050" "Ct.mx025" "Ct.mx025")
declare -a destList=(     "C96"      "C96"     "C192"     "C192"     "C384"     "C384"     "C768")
#declare -a sorcList=("Ct.mx100" "Ct.mx050" "Ct.mx025" "Ct.mx025")
#declare -a destList=("C96" "C192" "C384" "C96")
#declare -a sorcList=("Ct.mx100")
#declare -a destList=("C96")


i=0
for sorc in "${sorcList[@]}" ; do
   dest="${destList[$i]}"
   wgtfile=${OUT_DIR}/${sorc}".to."${dest}".nc"
   echo $wgtfile
   $rgcmd ${ESMF_BINDIR}/ESMF_RegridWeightGen -s $SCRIP_DIR/${sorc}"_SCRIP_land.nc" -d ${FIX_DIR}/${dest}/${dest}_mosaic.nc -m ${meth} --tilefile_path ${FIX_DIR}/${dest} --ignore_unmapped -w $wgtfile
   i=$((i+1))
done