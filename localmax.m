function [v,ind] = localmax(A,minPeakValue,nbrOfPeaks)
%FINDLOCALMAX - Find local maxima
%
%    This function finds local maxima for each column in the input matrix.
%
%    [v,ind] = LOCALMAX(A,minPeakValue,nbrOfPeaks)
%
%    Input:
%    A            - matrix
%    minPeakValue - minimum value for local maxima
%    nbrOfPeaks   - max number of local maxima to return (for each column)
%
%    Output:
%    v   - value vectors for local maxima
%    ind - index vectors for local maxima

%Finding local maxima:
n = size(A,2);
df = [diff(A); zeros(1,n)];
df = sign(df);
dfdf = [zeros(1,n); diff(df)];

ind = dfdf < 0; %indeces of local maxima
v = -Inf(size(A));
v(ind) = A(ind);

%Sorting local maxima:
[v,ind] = sort(v,'descend');
v = v(1:nbrOfPeaks,:);
ind = ind(1:nbrOfPeaks,:);

%Setting local maxima < minPeakValues to NaN:
badind = v < minPeakValue;
v(badind) = NaN;
ind(badind) = NaN;
end