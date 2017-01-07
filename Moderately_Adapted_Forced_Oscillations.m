clf
clear all

engineSpeed = 4800; % currently set as this value, need to accept a different input to change up the 

rangeLow = input('Enter the lower bounds of data to be observed = ');
rangeHigh = input('Enter the higher bounds of the data to be observed = ');
checkRange = input('Enter the range of data in which shall be observed = ');
mspring = input('Enter the mass of the spring = ');
msys = input('Enter the mass of the system = ');
RocketData = input('Enter the name of the file = ');
springcon = input('Enter the spring constant for the system = ');
filename = load(RocketData);

% currently assumes that the data is provided in a specific format, will
% need to recode in order to account for a different format
temp = load([num2str(engineSpeed),filename]);
AllData(:,1) = temp(:,2);  

    xData = linspace(0,720,2048)/engineSpeed/360*60;
    yData = AllData(:,1);
    % change data in order to account for relative forces on the smaller
    % load within the cubesat, as the current calculation appears to only
    % account 
    yData = yData - mean(yData(100:500));
    

    % If we are only interested in a certain data range
    rangeLow  = 101;
    rangeHigh = 1200;
    checkRange = checkRange/2;

    maxIndices = [];
 
    for jj = 1:length(yData)
        if (jj > rangeLow) && (jj < rangeHigh)
            for kk = -checkRange:checkRange
                if (yData(jj) >= yData(jj+kk))
                    if kk == checkRange
                        maxIndices = [maxIndices jj];
                    end
                else
                    break
                end
            end
        end
    end

    xCoords = xData(maxIndices);
    yCoords = yData(maxIndices);

    % Calculate the optimal values of a and b
    A = ones(length(xCoords),2);
    Y = ones(length(xCoords),1);

    % We take the log of the actual data (yCoords)
    for jj = 1:length(xCoords)
        A(jj,2) = xCoords(jj);
        Y(jj,1) = log(yCoords(jj));
    end

    % After finding A and B, we know that a = exp(A) and b = B
    p = A\Y;
    a(1) = exp(p(1));
    sigma = p(2);

    % We plug them into their function and plot away. Note that b < 0
    curvePlot = a*exp(sigma*xData);
    plot(xData,yData,'-b',xCoords,yCoords,'or',xData,curvePlot,'--g');
    xlabel('Time (s)','FontSize',20);
    ylabel('Spring Force (N)','FontSize',20);
    legend('Experimental Data','Analyzed Points','Fitted Curve');
    pause
    print -r300 -djpeg80 SpringOscillations

meff = mspring*.33 + msys;

w_natural = sqrt(springcon./meff)
w_damped = sqrt(w_natural.^2-sigma.^2)