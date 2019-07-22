# Instructions to run a year long global WW3 simulation

1. Clone this repository

>git clone https://github.com/breichl/JRA55_WW3.git

2. Initialize and update the submodules for WAVEWATCH III and GridGen.

>git submodule update --init --recursive

3. Install the WW3 source code, which is located in src/WW3, to src/WW3/model/exe (ww3_grid, ww3_prnc, ww3_shel, and ww3_ounf).

4. Create the bathymetry file using GridGen

- Change into the 4 degree example Grid folder

>cd 4_deg/Grid

- Load matlab environment (if necessary)

>On Gaea: module load matlab/R2017a  
         matlab -nodesktop

- Update the root_dir line in create_4_deg_global.m and ModMask.m to reflect the location of your gridgen folder.

- Run the bathymetry script

>run create_4_deg_global.m  
Note: This will create figures near the end unless you comment them out in the matlab script.

- Run the mask mod script (This assumes you are running a global lat-lon grid, which has a singularity at the North Pole. The existing grid masks out all points north of 85N to eliminate the singularity.)

>run ModMask.m

5. Run the ww3_grid preprocessor (this should be the relative path of the executable if it is installed with this repository)

>../../src/WW3/model/exe/ww3_grid

6. Prepare the wind input files. 

- Note 1: The Datasets folder must be added to the root directory of the repository.  These files are too big too include via github.  Other wind products could easily be substituted in at this point.
- Note 2: On Gaea this needs to be done from an interactive session.

>cd ../Input  
cp ww3_prnc_wnd.inp ww3_prnc.inp  
../../src/WW3/model/exe/ww3_prnc  
(Or, on Gaea) srun -n1 ../../src/WW3/model/exe/ww3_prnc  
rm ww3_prnc.inp  

7. Prepare the ice input files.

- comment the 4 wind related lines out in ww3_prnc.inp
- uncomment the 4 ice related lines

>cp ww3_prnc_ice.inp ww3_prnc.inp  
../../src/WW3/model/exe/ww3_prnc  
(Or, on Gaea) srun -n1 ../../src/WW3/model/exe/ww3_prnc  
rm ww3_prnc.inp  

8. Run the model

>cd ../2004  
../../src/WW3/model/exe/ww3_shel  
(Or, on Gaea) srun -n32 ../../src/WW3/model/exe/ww3_shel  

9. Postprocessing

>../../src/WW3/model/exe/ww3_ounf  
(Or, on Gaea) srun -n1 ../../src/WW3/model/exe/ww3_ounf  

On 32 processors this takes under 10 minutes to run a full year.
