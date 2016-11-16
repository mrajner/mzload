function [ n, e, u ] = Earth_deformation( fi0, la0, green_fun, Hydrology_model )
%
% function Earth_deformation is used to calculate crustal deformations
% as a response to hydrosphere loading
%
% fi0, la0          latitude and longitude of calculated deformations,
%                   input as decimal degrees
%
% green_fun         Green's function coefficients defining load response
%                   of Earth's crust.
%                   The data structure: 3 columns containing spherical distances
%                   to loading mass and Green's function coefficients describing
%                   deformations in radial and tangential direction.
%                   Values in 2nd and 3rd columns should contain normalized
%                   values (their de-normalization, depending on spherical
%                   earth's radius is done at runtime).
%                   Green's function coefficients for distances between the
%                   distances in the first column of the table are calculated
%                   with third degree spline.
%                   
% Hydrology_model   hydrological data with spatial resolution of
%                   0.5 degree (one month includes 360 rows and 720 columns)
%                   that assign the amount of fresh water for each cell.
%                   Data should express height of water column for each cell
%                   in millimetres. Cells without determined water quantity
%                   should be marked as NaN (Not a Number)

%% additional variable
format long;

% load Green's function coefficients
grn = green_fun;

% load hydrology data to memory
Hydro_model = Hydrology_model;

% fresh water density
ro = 1000; % kg/m^3

% name of file to store calculation results
filename = 'Earth_def_fi_la_neu.txt';

%% parameters of reference surface
% GRS80/WGS84
% a = 6378137;
% e2 = 0.00669438002290;

% spherical Earth
a = 6371000;
e2 = 0.0;

%% Algorithm

% fresh water column height at the point of calculated deformations
H0 = hydro(Hydro_model, fi0, la0);

% function calculates deformations only for land area and is skipping
% any area that is missing WGHM data
if isnan(H0) == 1
    fprintf('Offshore location or WGHM data missing.\n')
    % if creating grid data for whole earth, 
	% commend "end" below and 
	% uncomment code between exclamation marks
end

%---!!!---
%{
    n = 0; e = 0; u = 0;
    
    fileID = fopen(filename, 'at');
    fprintf(fileID, '%2.1f %3.1f %2.8f %2.8f %2.8f\n', fi0, la0, n, e, u);
    fclose(fileID);
    
else
%}
%---!!!---
    dAz = 3; % degree(s) - width of spherical figures
    ds = 500; % basic integration distance [metres]
    
    R = a;
    r = ((pi*R)); % maximum integration distance - antipode of fi0, la0
    nds = floor(r/ds); % amount of integration steps
    
    % coordinates of fi0, la0 antipode and fresh water column height a that location
    [fi5, la5] = directVincenty(fi0, la0, 0, pi*R, a, e2);
    H5 = hydro(Hydro_model, fi5, la5);

    % creation of empty tables in memory to store calculation results - improves execution time
    fig_area = zeros(nds+1,(360/dAz));
    fig_hydro = zeros(nds+1,(360/dAz));
    fig_mdistance = zeros(nds+1,(360/dAz));
    fig_mazymut = zeros(nds+1, (360/dAz));
        
    s = 1:nds;
    
    for Az = 0:(360/dAz)-1;
        Azymut = Az*dAz; %azimuth (bisector line) of spherical figure
        Az1 = Azymut-(dAz/2);
        Az2 = Azymut+(dAz/2);         
        fig_mazymut(:,Az+1) = Azymut;
    
        % influence of one spherical triangle in neighbourhood of fi0, la0
        s1 = s(1)*ds;
        [Area, H_hydro, dist] = triangle( fi0, la0, Az1, Az2, s1, a, e2, Hydro_model);
        fig_area(1,Az+1) = Area;
        fig_hydro(1,Az+1) = H_hydro;
        fig_mdistance(1,Az+1) = dist;
                
        % influence of one spherical trapezoid in zone
        s2 = (s(1,1:nds-1)*ds);
        s3 = (s(1,2:nds)*ds);
        [ Area, H_hydro, dist ] = trapezoid(fi0, la0, Az1, Az2, s2, s3, a, e2, Hydro_model);
        fig_area(2:end-1,Az+1) = Area';
        fig_hydro(2:end-1,Az+1) = H_hydro';
        fig_mdistance(2:end-1,Az+1) = dist';

        % influence of one spherical triangle in neighbourhood of fi0, la0 antipode
        s4 = r - nds*ds;
        [Area, H_hydro, dist] = triangle( fi5, la5, Az1, Az2, s4, a, e2, Hydro_model);
        dist = pi*R - dist;
        fig_area(end,:) = Area;
        fig_hydro(end,:) = H_hydro;
        fig_mdistance(end,:) = dist;
                
    end

% loading calculation, depending on spherical distance
s = (grn(:,1));
L1_radial(:,1) = grn(:,2);
L2_tangent(:,1) = grn(:,3);

theta = deg2rad(s);

%de-normalization of loading
L1_radial = L1_radial ./ (a.*theta.*(10^12));
L2_tangent = L2_tangent ./ (a.*theta.*(10^12));

dist = fig_mdistance.*(180/(pi*a));

% interpolation of Green's function coefficients to match mean spherical distance
% of spherical segment - 3rd degree spline
G_radial = interp1(s,L1_radial,dist,'spline');
G_tangent = interp1(s,L2_tangent,dist,'spline');

% sum of individual segments on vertical deformations
D_radial = G_radial.*fig_hydro.*fig_area;
nany = isnan(D_radial);
D_radial(nany) = 0;
u = ro*sum(sum(D_radial));

% sum of individual segments on deformations
% in direction of meridian and first vertical
D_tangent = G_tangent.*fig_hydro.*fig_area;
nany = isnan(D_tangent);
D_tangent(nany) = 0;
N = D_tangent.*(-cos(deg2rad(fig_mazymut)));
E = D_tangent.*(-sin(deg2rad(fig_mazymut)));
n = ro*sum(sum(N));
e = ro*sum(sum(E));

% saving calculated deformations to file
fileID = fopen(filename, 'at');
fprintf(fileID, '%2.1f %3.1f %2.8f %2.8f %2.8f\n', fi0, la0, n, e, u);
fclose(fileID);

end
