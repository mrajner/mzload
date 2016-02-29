function [ fi2, la2, a12, a21 ] = directVincenty( fi1, la1, alpha12, s12, a, e2)
%
% directVincenty function calculates coordinates of the geodesics end point
% (fi2, la2) based on start point (fi1, la1), geodesic distance (s12) and 
% initial azimuth (alpha12)
%
%   fi1         start point's latitude, input as decimal degrees
%   la1         start point's longitude, input as decimal degrees
%   alpha12     initial azimuth from start point to end point 
%               (determined in start point), input as decimal degrees
%   s12         geodesic length, input as metres
%
%   fi2         end point's latitude, output as decimal degrees
%   la2         end point's longitude, output as decimal degrees
%   alpha12     azimuth from start to end point, determined at the location 
%               of end point, output as decimal degrees
%   alpha21     azimuth from end point to start point, determined at the location
%               of end point, output as decimal degrees 
%
% Presented algorithm is based on direct Vincenty's formulae, to calculate 
% geodesics end point for reference surface and was altered to
% improve calculation speed for spherical Earth

%% convert decimal degrees input to radians

fi1 = deg2rad(fi1);
la1 = deg2rad(la1);
a12 = deg2rad(alpha12);

%% direct Vinceny's formulae

% azimuth of geodesics intersecting the equator

alpha = asin(cos(fi1)*sin(a12));
sigma = s12./a;

fi2 = rad2deg(atan((sin(fi1).*cos(sigma)+cos(fi1).*sin(sigma).*cos(a12))./(((((sin(alpha)).^2)+(sin(fi1).*sin(sigma)-cos(fi1).*cos(sigma).*cos(a12)).^2).^(1/2)))));
la = atan2(sin(sigma).*sin(a12),(cos(fi1).*cos(sigma)-sin(fi1).*sin(sigma).*cos(a12)));

la2 = rad2deg(la1 + la);

a12 = rad2deg(atan2(sin(alpha),(-sin(fi1).*sin(sigma)+cos(fi1).*cos(sigma).*cos(a12))));

if (a12 > -180 & a12 < 180)
    a21 = a12 + 180;
else
    a21 = a12 - 180;
end

%fprintf('End point's coordinates:\nfi2 = %3.8f\nla2 = %3.8f\nazimuth12 = %3.8f\nazimuth21 = %3.8f\n',fi2, la2, a12, a21)

end