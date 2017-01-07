clf
clear all

% This is just example data
xData = linspace(0,20*pi,1000);
yData = cos(2*xData).*exp(-.05*xData);

% If we are only interested in a certain data range
rangeLow  = 0;
rangeHigh = 10000;

xCoords = [];
yCoords = [];

% Find the x,y coordinates for the oscillation peaks
yData    = yData(:);
upOrDown = sign(diff(yData));
maxFlags = [upOrDown(1)<0 ; diff(upOrDown)<0 ; upOrDown(end)>0];
maxIndices   = find(maxFlags);

for ii = 1:length(maxIndices)
    if (maxIndices(ii) > rangeLow) && (maxIndices(ii) < rangeHigh)
        xCoords = [xCoords xData(maxIndices(ii))];
        yCoords = [yCoords yData(maxIndices(ii))];
    end
end

% Calculate the optimal values of a and b
A = ones(length(xCoords),2);
Y = ones(length(xCoords),1);

% We take the log of the actual data (yCoords)
for ii = 1:length(xCoords)
    A(ii,2) = xCoords(ii);
    Y(ii,1) = log(yCoords(ii));
end

% After finding A and B, we know that a = exp(A) and b = B
p = A\Y;
a = exp(p(1));
b = p(2);

% We plug them into their function and plot away. Note that b < 0
curvePlot = a*exp(b*xData);

figure(1)
plot(xData,yData,'-b',xCoords,yCoords,'or',xData,curvePlot,'--g');
legend('Data','Points','Curve');