% script months is used to calculate deformations from hydrosphere
% loading for desired coordinates for all hydrosphere data

% approach uses spherical Earth as reference surface

% fi0, la0                coordinates to calculate deformations,
%                         input as decimal degrees
%
% green_function.mat      Green's function coefficients, three columns:
%                         1st - spherical distances in decimal degrees
%                         2nd - coefficients for vertical direction
%                         3rd - coefficients for tangent direction
%
% WGHM.mat                hydrosphere data with spatial resolution
%                         of 0.5 x 0.5 degrees, expressed as height
%                         (in millimetres) of water column in each cell
%
% Calculated deformation are expressed in millimetres and stored
% in Earth_def_fi_la_neu.txt file.


%warning ("off", "Octave:possible-matlab-short-circuit-operator")

% Uncomment below line if Octave don't flush output to to console
more off

% load statistics package into Octave
pkg load statistics

clear
delete Earth_def_fi_la_neu.txt

% load Green's function coefficients and WGHM data to memory
load grn1.mat
load WGHM.mat

% coordinates to calculate deformations
fi0 = 52.1;
la0 = 21.0;

% loop divide hydrosphere data stored in WGHM.mat file to use in calculation
for k = 1:length(WGHM)/360;
    fprintf('Month: %3i/%3i\n', k, length(WGHM)/360)
    month_model = WGHM(k*360-359:k*360,:);
    
    [ n, e, u ] = Earth_deformation(fi0, la0, grn1, month_model);
    
end
