# 1. We need to create gromacs friendly files from the structure we get from PDB.
# Preprocessing -- I removed all the chains except one chain in the PDB file. Then I run it through pdb2gmx
gmx pdb2gmx -f 1uaoinput.pdb -ignh
# Selected amber99SB-ildn and tip3p
# I changed the output file names to chignolin.gro and chignolin.top.

# 2. Solvate chignolin. Here you have to consider how big is your protein, how big you want the box to be. 
# A good thumb rule is to have at least 1 nm buffer, so a few solvation shells + 1 nm.
# I selected 6 nm (arbitrary) here, only for demonstration purposes.
gmx solvate -cp chignolin.gro -cs -box 6.0  -p chignolin.top -o chignolin-water.gro

# 3. Neutralize the system (requires a tpr file so I run the first command)
gmx grompp -f em.mdp -c chignolin-water.gro -p chignolin-water.top -o chigwatem.tpr -maxwarn 1
# I will use this tpr file to neutralize the system with genion
gmx genion -s chigwatem.tpr -np 2 -o chignolin-wation.gro -p chignolin-water.top
# the command above will overwrite the chignolin-water.top -- so I rename it as chignolin-wation.top and restore the chignolin-water.top to keep both files.

# 4. We minimize the system
gmx grompp -f em.mdp -c chignolin-wation.gro -p chignolin-wation.top -o chigwatem.tpr
gmx mdrun -s chigwatem.tpr
mv confout.gro chigwat-min.gro

# 5. Generally we should now run a short NVT run, then a short equilibration NPT run.
# I am taking a  short cut to do a short NPT run (but how would you run an NVT simulation?)
gmx grompp -f runmdshort.mdp -c chigwat-min.gro -p chignolin-wation.top -o chigwatshortmd.tpr
gmx mdrun -s chigwatshortmd.tpr

# I am tempted to go ahead and run the long simulation here BUT -- in reality this could take days. So let's first visualize our system. Does it make sense?
# When I saw the trajectory the protein wasn't centered in the box. So, I decided to do so now.
gmx trjconv -f chigwat-shortmd.gro -o chigwat-shortmd-center.gro -pbc mol -center -s chigwatshortmd.tpr
# options selected for centering = Protein, for output = System.
# 6. Now I can run the long simulation
 gmx grompp -f runmd.mdp -c chigwat-shortmd-center.gro -p chignolin-wation.top -o chigwatlongmd.tpr
 gmx mdrun -s chigwatlongmd.tpr -deffnm chigwatlong -c chigwatlongmd.gro

# Technically, you should run it for much longer -- but we run it for 200 ps to get a feel of it! 
