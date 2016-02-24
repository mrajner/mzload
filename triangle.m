function [ Area, H_hydro, dist ] = triangle( fi0, la0, Az1, Az2, s, a, e2, Hydro_model )
%
% triangle function is used to calculate properties of one spherical triangle
% that influences hydrospheric loading
%
% fi0, la0      latitude and longitude of point for which defromation are calculated,
%               input as decimal degrees
%
% Az1, Az2      azimuths to left and right edges of spherical triangle,
%               input as decimal degrees
%
% s             distance to verticle at Azimuth 1 and Azimuth 2 (intergation distances),
%               input as metres
%
% a             radius of reference surface,
%               input as metres
% 
% e2            eccentricity of reference surface
%
% Hydro_model   one epoch of hydrological data
%
% Area          area of spherical triangle, expressed as square metres
%
% H_hydro       average height of water column at spherical triangle,
%               expressed as milimetres
%
% dist          distance to centre of spherical figure

%% calculation of figre's area

% width of spherical triangle
A = Az2-Az1;

% calculate coordinates of spherical triangle's verticles
[fi1, la1] = directVincenty(fi0, la0, Az1, s, a, e2);  %[fi1, la1, a01, a10]
[fi2, la2] = directVincenty(fi0, la0, Az2, s, a, e2);  %[fi2, la2, a02, a20]

% use of inverse Vincenty method to calulate distance between aforementioned
% verticles
[s12] = inverseVincenty(fi1, la1, fi2, la2, a, e2);   %[s12, a12, a21]
s12 = round(s12*10000)/10000; %rounds distance to 0.000001m

% convertion metric distance to radians
s01 = deg2rad(s*360/(2*pi*a));
s12 = deg2rad(s12*360/(2*pi*a)); %[rad]

% calculate spherical excess - L'Huilier's Theorem
d = (s12+2*s01)/2;
E = (atan(sqrt(tan(d./2).*tan((d-s12)./2).*tan((d-s01)./2).*tan((d-s01)./2)))).*4;
Area = E*a^2;

%% calculate average water column in spherical figure

[H0] = hydro(Hydro_model,fi0,la0).*ones(size(fi1));
[H1] = hydro(Hydro_model,fi1(:),la1(:));
[H2] = hydro(Hydro_model,fi2(:),la2(:));

[x] = [H0; H1; H2];

% calculate average water column, skipping Not-a-Number (NaN)

H_hydro = nanmean(x);

%% distance to centre of spherical figure

dist = s/2;

end

