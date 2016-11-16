function [ H ] = hydro( Hydro_model, fi, la )
%
% function hydro is used to calculate water column height
% at desired coordinates
%
% Hydro_model   hydrological data with spatial resolution of 0.5 degree
%               (one month consists of 360 rows and 720 columns), with
%               information of water quantity as equivalent of fresh
%               water column with basis of 0.5 x 0.5 degrees and height
%               expressed in millimetres.
%               Data is expressed in millimetres.
%               No data is marked as NaN (Not a Number).
%
% fi, la        coordinates for water column height determination,
%               input as decimal degrees
%
% water column height is determined by average sum of information 
% stored in four adjacent hydrosphere data cells

%% Algorithm

% Series of logical tests that returns numbers of columns and rows adjacent
% to coordinates fi and la [vectorized]
Urow = ceil(fi/0.5)+180';
Lrow = Urow;
Rcol = ceil(la/0.5)';
zero = (Rcol == 0)*720;
znak = sign(Rcol);
znak(znak == 1) = 0;
znak = znak.*-720;
Rcol = Rcol+zero;
Rcol = Rcol+znak;
Lcol = Rcol;
grid_fi = mod(fi,0.5) == 0;
Urow = Urow + grid_fi;
grid_la = mod(la,0.5) == 0;
Rcol = Rcol + grid_la';
Urow = Urow';
Lrow = Lrow';

% returns index of elements adjacent to calculated deformations
H_NE_idx = sub2ind(size(Hydro_model), Urow, Rcol);
H_SE_idx = sub2ind(size(Hydro_model), Lrow, Rcol);
H_SW_idx = sub2ind(size(Hydro_model), Lrow, Lcol);
H_NW_idx = sub2ind(size(Hydro_model), Urow, Lcol);

% returns water column height for every adjacent element
H_NE = Hydro_model(H_NE_idx);
H_SE = Hydro_model(H_SE_idx);
H_SW = Hydro_model(H_SW_idx);
H_NW = Hydro_model(H_NW_idx);

[x] = [H_NE, H_SE, H_SW, H_NW]';

% calculate average height of water column,
% sum and division skip Not a Number (NaN)
%[H] = nansum(x)./(4-sum(isnan(x)));
[H] = nanmean(x);

end