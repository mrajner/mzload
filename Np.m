function [ N ] = Np( fi, a, e2)
%
% Np function is used to calculate radius of first vertical
% at the latitude fi of given reference surface
%
% fi    latitude for calculation of first vertical radius,
%       input as decimal degrees
%
% a     radius of reference surface, input in metres
%
% e2    eccentricity of reference surface
%
% N     radius of first vertical,
%       output as metres

N = a./((1-e2.*((sin(deg2rad(fi))).^2)).^(1/2));

end

