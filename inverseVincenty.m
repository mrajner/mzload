function [ s12, alpha12, alpha21 ] = inverseVincenty( fi1, la1, fi2, la2, a, e2 )
%
% inverseVincenty function is used to calculate geodesic distance s12 between two
% points (fi1, fi1 and fi2, la2) on given reference surface (a, e2) as well
% as azimuth of this geodesic
%
%   fi1         start point's latitude, input as decimal degrees
%   la1         start point's longitude, input as decimal degrees
%   fi2         end point's latitude, input as decimal degrees
%   la2         end point's longitude, input as decimal degrees
%   a           reference surface radius, input as metres
%   e2          reference surface eccentricity
%
%   s12         geodesic length, output as metres
%   alpha12     azimuth from start point to end point, determined at the location 
%               of start point, output as decimal degrees
%   alpha21     azimuth from end point to start point, deermined at the location
%               of end point, output as decimal degrees 
%
%
%% additional calculations

b = a*sqrt(1-e2);
f = 1-sqrt(1-e2);

fi1 = deg2rad(fi1);
la1 = deg2rad(la1);

fi2 = deg2rad(fi2);
la2 = deg2rad(la2);

if fi1 == fi2 && la1 == la2
    fprintf('Start point and end point are the same\n')
else
%% inverse Vincenty algorithm

% latitude reduced to sphere
U1 = atan((1-f)*tan(fi1));
U2 = atan((1-f)*tan(fi2));

la = la2 - la1;
L = la;

for k=1:25
	k
	L
	
    ssigma = sqrt((cos(U2).*sin(la)).^2+(cos(U1).*sin(U2)-sin(U1).*cos(U2).*cos(la)).^2);
    csigma = sin(U1).*sin(U2)+cos(U1).*cos(U2).*cos(la);
    sigma = atan2(ssigma,csigma);

    alpha = asin(cos(U1).*cos(U2).*sin(la)./ssigma);

    dwasigmam = acos(csigma-2.*sin(U1).*sin(U2)./((cos(alpha)).^2));

    C = f./16.*((cos(alpha)).^2).*(4+f.*(4-3.*((cos(alpha)).^2)));
    la = L+(1-C).*f.*sin(alpha).*(sigma+C.*sin(sigma).*(cos(dwasigmam)+C.*cos(sigma).*(-1+2.*((cos(dwasigmam)).^2))))
	
	
	fprintf('dL = %1.16f \n', L-la);
end



u2 = ((cos(alpha)).^2).*(a.^2-b.^2)./(b.^2);
A = 1+(u2./16384).*(4096+u2.*(-768+u2.*(320-175.*u2)));
B = (u2./1024).*(256+u2.*(-128+u2.*(74-47.*u2)));

% 1976b modification
%k1 = (sqrt(1+u2)-1)/(sqrt(1+u2)+1);
%A = (1+(k1^2)/4)/(1-k1);
%B = k1*1-(3/8)*(k1^2);

dsigma = B.*sin(sigma).*(cos(dwasigmam)+B./4.*(cos(sigma).*(-1+2.*((cos(dwasigmam)).^2)-B./6.*cos(dwasigmam).*(-3+4.*((sin(sigma)).^2)).*(-3+4.*((cos(dwasigmam)).^2)))));

s12 = b.*A.*(sigma - dsigma);
alpha12 = rad2deg(atan2(cos(U2).*sin(la),(cos(U1).*sin(U2)-sin(U1).*cos(U2).*cos(la))));
alpha21 = rad2deg(atan2(cos(U1).*sin(la),(-sin(U1).*cos(U2)+cos(U1).*sin(U2).*cos(la))));

%fprintf('Geodesic length s12 = %6.3f\nAzimuth12 = %3.8f \nAzimuth21 = %3.8f\n',s12, alpha12, alpha21);

end