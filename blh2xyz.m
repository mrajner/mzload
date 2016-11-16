function [X, Y, Z] = blh2xyz(fi, la, h, a, e2)
%
% function blh2xyz calculate geocentric coordinates based on geodetic
% coordinates and parameters of reference ellipsoid
%
% fi        point's latitude, input as decimal degrees
%
% la        point's longitude, input as decimal degrees
%
% a         semi major axis of reference ellipsoid, input in metres
%
% e2        eccentricity of reference ellipsoid
%
% X, Y, Z   geocentric coordinates of input point, output in metres

%% Algorithm

fi = deg2rad(fi);
la = deg2rad(la);

N = Np(fi, a, e2);
X = ((N+h).*cos(fi).*cos(la));
Y = ((N+h).*cos(fi).*sin(la));
Z = (((N.*(1-e2))+h).*sin(fi));

end

