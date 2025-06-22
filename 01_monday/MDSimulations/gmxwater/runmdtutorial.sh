# 1. Ensure you have Gromacs module loaded.

# 2. We have a gro (coordinate) file with 216 water molecules -- check the head and tail of the file.

# 3. What is the box size we want to simulate? Let's say I want to simulate a box of 1000 water molecules. 

# 4. First step -- we have to generate a box of this size. So we will create such a box. In gromacs this is done by solvate.

gmx solvate -cs spce216.gro -cp spce216.gro -maxsol 1024 -o spce1024.gro -p ../spce216.top -box 3.6

# 5. Now you can copy the files over to your laptop and visualize the file via VMD.
# Some useful tips -- if you do pbc box in the terminal window of VMD, you will see the box.

# 6. (optional) if the box look funky (water molecules are outside the box) etc you can fix it. Editconf is one way to do this.
# Read the help documentation for this. I am skipping this step.

# 7. We will energy minimize. In gromacs this includes two steps -- compiling the files into a binary (grompp) and running the MD simulation (mdrun)

gmx grompp -f em.mdp -c spce1024.gro  -p spce1024.top -o spce1024em.tpr

gmx mdrun -s spce1024em.tpr -c spce1024min.gro

# 8. Now we can visualize the spce1024min.gro

# 9. Now we will use this minimized gro file to start a short equilibration run. In equilibration we ensure the system is brought to the desired temperature and pressure.

gmx grompp -f runmdshort.mdp -c spce1024min.gro -p spce1024.top -o spce1024mdshort.tpr

gmx mdrun -s spce1024mdshort.tpr -c spce1024mdshort.gro

# 10. Now we run the long simulations.

gmx grompp -f runmd.mdp -c spce1024mdshort.gro  -p spce1024.top -o spce1024mdlong.tpr

gmx mdrun -s spce1024mdlong.tpr -c spce1024mdlong.gro -deffnm spce1024long

# 11. Success! (if the simulation ran without hiccups!)

# 12. Now we do analysis. We do some preliminary analysis to ensure the system is equilibrated and at the state point we expect. 
# What can we calculate?
# energy, temperature, pressure, density -- what do you expect this behavior to be??

# How can you do it? 
# 13. We will use gmx energy to calculate the quantities above.

gmx energy -f spce1024long.edr -o energy-spce1024long.xvg
