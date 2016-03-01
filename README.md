# Application
Application was created to determine the deformation of the Earth’s crust, as 
a response to the surface loading caused by continental waters.
Presented algorithm uses spherical Earth as a reference surface to 
calculate deformations.

# Preparation
Presented algorithm heavily use NaN values for hydrosphere data cells that
has no determined water quantity and `nanmean` function that is part of 
`statistics package` from Octave Forge.
It may be also necessary to install `io package` from Octave Forge.

To install package, execute following command in Octave prompt:

    pkg install statistics

To load package into `Octave`, execute following command in application prompt:

    pkg load statistics 

Presented algorithm requires creating two files with necessary data:

- containing Greens functions coefficient, that are stored in file `grn1.txt`.
For purpose of this study, Greens functions coefficient were taken for
the Earth model ’A’, developed jointly by Gutenberg and Bullen 
(Farrell, 1972. Deformation of the earth by surface loads).

It is important to name that file `grn1.mat`. Octave users can create such
file with following commands executed from application's command prompt:

    load grn1.txt;
    save(-mat7-binary,grn1.mat,grn1);

- containing hydrosphere data, stored in e.g. file `WGHM.txt`.

This file should contain hydrosphere data in a grid with spacing of 0.5 degrees.
Octave users can create such file with following command executed from
application's command prompt, given that source data is stored in `WGHM.txt` 
file.

    load WGHM.txt; WGHM(WGHM==-9999) = NaN;
    save(-mat7-binary, WGHM.mat, WGHM);


# Calculations
File `months.m` is a script that starts calculation of deformations
for all epochs in WGHM.mat file for specified coordinates.

Results are stored in txt file as:
`fi` `la` `n` `e` `u`
where:

| symbol | meaning
| ----   | ----
| `fi`   | point's latitude (decimal degrees)
| `la`   | point's longitude (decimal degrees)
| `n`    | deformations in direction of meridian (millimetres)
| `e`    | deformations in direction of prime vertical (millimetres)
| `u`    | deformations in direction of plumb line (millimetres)


# Contact author
In case of any questions related to used algorithm or obtained results, 
please send message to <mailto:m.zygmunt87@wp.pl>.
