%%
rho = 998; % kg/m^3
nmol = 4; % number of molecules, nat = 4*3

mol_mass = 0.0180153; % kg/mol

rho = rho/mol_mass; % mol/m^3
Na = 6.023e23; % Avogadro number

rho = rho*Na; % number/m^3

Vol = nmol/rho; % m^3

m2b = 18897259885.789; % meter to bohr

Vol = Vol*m2b^3; % Volume in bohr^3

L = Vol^(1/3); % side length in bohr

fprintf("For nmol = %d, L = %6.8f\n.",nmol,L);