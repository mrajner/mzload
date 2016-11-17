function [ Area, H_hydro, dist ] = trapezoid( fi0, la0, Az1, Az2, s1, s2, a, e2, Hydro_model )
%
% trapezoid function is used to calculate properties of one spherical trapezoid
% that influences hydrosphere loading
%
% fi0, la0      latitude and longitude of point for which deformation are calculated,
%               input as decimal degrees
%
% Az1, Az2      azimuths to left and right edges of spherical trapezoid,
%               input as decimal degrees
%
% s1, s2        distances to closer and further trapezoid bases,
%               (integration distances), input as metres
%
% a             radius of reference surface,
%               input as metres
% 
% e2            eccentricity of reference surface
%
% Hydro_model   one epoch of hydrological data
%
% Area          area of spherical trapezoid, expressed as square metres
%
% H_hydro       average height of water column at spherical trapezoid,
%               expressed as millimetres
%
% dist          distance to centre of spherical figure
%

%% calculation of figure's area

% width of spherical trapezoid
A = Az2-Az1;

% calculate coordinates of spherical trapezoid's vertices
[fi1, la1] = directVincenty(fi0, la0, Az1, s1, a, e2);
[fi2, la2] = directVincenty(fi0, la0, Az2, s1, a, e2);
[fi3, la3] = directVincenty(fi0, la0, Az1, s2, a, e2);
[fi4, la4] = directVincenty(fi0, la0, Az2, s2, a, e2);

% calculate spherical zone (spherical segment) height between
% parallel planes, containing spherical trapezoid vertices,
% perpendicular to sphere's rotation axis

[fi5, la5] = directVincenty(90, 0, 0, s1, a, e2);
[fi6, la6] = directVincenty(90, 0, 0, s2, a, e2);
[~, ~, Z1] = blh2xyz(fi5, la5, 0, a, e2);
[~, ~, Z2] = blh2xyz(fi6, la6, 0, a, e2);
h = abs(Z2-Z1);

Area = 2*pi*a*h*A/360;

%% calculate average water column in spherical figure

[H1] = hydro(Hydro_model,fi1,la1);
[H2] = hydro(Hydro_model,fi2,la2);
[H3] = hydro(Hydro_model,fi3,la3);
[H4] = hydro(Hydro_model,fi4,la4);

[x] = [H1; H2; H3; H4];

% calculate average water column, skipping Not-a-Number (NaN)

H_hydro = nanmean(x);

%% distance to centre of spherical figure

dist = (s1+s2)/2;

end
