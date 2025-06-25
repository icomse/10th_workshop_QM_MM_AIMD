These two files are the start for performing a calculation of the energy threshold needed to create a defect.

The first file to use is the input file (*.inpt). We want to start a re-start file. All atoms here are located in the location given by the cif file.
We want a very low temperature for the ions to stay in their place. We then perform a run for 1 MD step.
After that runs, the restart file is modified and the ion we want to see move is given a bost in that direction by modifying the velocity entry.
We then modify the inpt file to make a long MD run. 
