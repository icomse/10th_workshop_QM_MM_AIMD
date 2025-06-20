## 1. CHARMM INSTALLATION
```
module load gcc/13.2.0  # adjust per your system
module load openmpi/5.0.5 # adjust per your system
module load cmake3/3.30.5 # newer 3. version 

cd /scratch/axa5186/icomse_knam_session #set your directory
# Download CHARMM c49b2 from https://brooks.chem.lsa.umich.edu/register/ and copy it to the session directory
tar -xvzf c49b2.tar.gz
cd charmm
mkdir build_charmm
cd build_charmm


# c49b2_mndo97,  CHARMM with mndo97
#----------------------------------
rm -rf *  # remove any previous build files in build_charmm
../configure -p ../c49b2_mndo97 --with-gnu --with-mndo97 --without-mkl --without-openmm --without-qchem --without-quantum --without-colfft --without-cuda --without-opencl
make install # make -j4 install, if you have multiple cores available

# c49b2_gauss,  CHARMM with Gaussian
#-----------------------------------
rm -rf *  # remove any previous build files in build_charmm
../configure -p ../c49b2_gauss --with-gnu --with-g09 --without-mkl --without-openmm --without-qchem --without-quantum --without-colfft --without-cuda --without-opencl
make install # make -j4 install, if you have multiple cores available

# c49b2_dftb,  CHARMM with dftb
#-----------------------------------
rm -rf *  # remove any previous build files in build_charmm
sed -i '380s/ || KEY_SCCDFTB==1//' ../source/nbonds/pme.F90 # this is to fix a reported bug, but not yet reflected in the current charmm release version
../configure -p ../c49b2_dftb --with-gnu --with-sccdftb --without-mkl --without-openmm --without-qchem --without-quantum --without-colfft --without-cuda --without-opencl
make install # make -j4 install, if you have multiple cores available
```
