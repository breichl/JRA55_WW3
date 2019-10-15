# Instructions to run a year long global WW3 simulation

1. Clone this repository

   >git clone https://github.com/breichl/JRA55_WW3.git

2. Initialize and update the submodules for WAVEWATCH III and GridGen.

   >cd JRA55_WW3
   
   *From here on it is assumed you are starting from the JRA55_WW3 folder for each instruction*
   
   >git submodule update --init --recursive

3. If you have not installed WW3 source code to another location, then install the version which is checked out in the folder JRA55_WW3/src/WW3.  For the rest of this guide it is assumed that your executables are built in this manner, and thus live in JRA55_WW3/src/WW3/model/exe.

   >cd src/WW3/model/bin
   
   *You now need to run the script w3_setup in this folder and select the comp, link, and switch files as appropriate.  
   Since this step is system specific, no further instruction is provided here.  After you complete that set-up, the executables are built as:*
   
   >./w3_make ww3_grid ww3_prnc ww3_shel and ww3_ounf
   
   *If this build step is not successful, then you likely have not accessed the correct compilers, mpi wrappers, and NetCDF libraries (or updated the comp/link files).*
   
   >cd ../../../..
   
4. Create the bathymetry file using GridGen

   - Change into the gridgen folder and download the raw grids:
   
      >cd src/gridgen/reference_data
      
      >wget ftp://polar.ncep.noaa.gov/tempor/ww3ftp/gridgen_addit.tgz
      
      >tar -xvf gridgen_addit.tgz
      
      >cd ../../..
   
   - Change into the 4 degree example Grid folder

      >cd 4_deg/Grid

   - Update the root_dir line in create_4_deg_global.m and ModMask.m to reflect the location of your gridgen folder.

   - Load matlab environment (if necessary) and open matlab with no gui
   
      >(On Gaea) module load matlab/R2017a  
      
      > matlab -nodesktop

   - Run the bathymetry script

      >run create_4_deg_global.m  
      
      Note: This will create figures near the end unless you comment them out in the matlab script.

   - Run the mask mod script (This assumes you are running a global lat-lon grid, which has a singularity at the North Pole. The existing grid masks out all points north of 85N to eliminate the singularity.)

      >run ModMask.m
      
   >cd ../..

5. Run the ww3_grid preprocessor

   >cd 4_deg/Grid
   
   >../../src/WW3/model/exe/ww3_grid
   
   >cd ../..
   
   *May need to run executable in different manner depending on MPI set-up and system.  You could also add the WW3 executables into your path, if you'd like to run without providing the full relative (or absolute) path of the executables.*

6. Prepare the wind input files. 

   - Note 1: The Datasets folder must be downloaded and copied into the root directory of the repository (WW3_JRA55).  These files are too big to include via github.  Other wind products could easily be substituted in at this point.
   - Note 2: On Gaea this needs to be done from an interactive session.

   >cd 4_deg/Input  
   
   >cp ww3_prnc_wnd.inp ww3_prnc.inp  
   
   >../../src/WW3/model/exe/ww3_prnc  
   
   >(Or on interactive slurm session) srun -n1 ../../src/WW3/model/exe/ww3_prnc  
   
   >rm ww3_prnc.inp  
   
   >cd ../..

7. Prepare the ice input files.

   >cd 4_deg/Input  
   
   >cp ww3_prnc_ice.inp ww3_prnc.inp  
   
   >../../src/WW3/model/exe/ww3_prnc  
   
   >(Or on interactive slurm session) srun -n1 ../../src/WW3/model/exe/ww3_prnc  
   
   >rm ww3_prnc.inp 
   
   >cd ../.. 

8. Run the model

   >cd 4_deg/2004 
   
   *At this point you may need a batch script if running via slurm or some other scheduler.  You can also shorten the run (it is setup to run from January 1, 2004 to January 1, 2005 in ww3_shel.inp, you can reduce this to a run length of 1 month or even 1 week to test your setups.)  On 32 processors this should take under 10 minutes to run a full year if MPI set-up is correct.*
   
   >(On an interactive slurm session) srun -n32 ../../src/WW3/model/exe/ww3_shel  

9. Postprocessing

   >../../src/WW3/model/exe/ww3_ounf  
   
   >(Or on an interactive slurm session) srun -n1 ../../src/WW3/model/exe/ww3_ounf  


