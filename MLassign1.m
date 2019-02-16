clc
close All 
%% Import data from text file.
% Script for importing data from the following text file:
%
%    /Users/nadaehab/Desktop/ML/house_data_complete.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2019/02/12 21:35:19
%% Initialize variables.
filename = '/Users/nadaehab/Desktop/ML/house_data_complete.csv';
delimiter = ',';
startRow = 2;
%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';
%% Open the text file.
fileID = fopen(filename,'r');
%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
%% Close the text file.
fclose(fileID);
%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end
%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]);
rawCellColumns = raw(:, 2);
%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells
%% Allocate imported array to column variable names
id1 = cell2mat(rawNumericColumns(:, 1));
date2 = rawCellColumns(:, 1);
price1 = cell2mat(rawNumericColumns(:, 2));
bedrooms1 = cell2mat(rawNumericColumns(:, 3));
bathrooms1 = cell2mat(rawNumericColumns(:, 4));
sqft_living1 = cell2mat(rawNumericColumns(:, 5));
sqft_lot1 = cell2mat(rawNumericColumns(:, 6));
floors1 = cell2mat(rawNumericColumns(:, 7));
waterfront1 = cell2mat(rawNumericColumns(:, 8));
view2 = cell2mat(rawNumericColumns(:, 9));
condition1 = cell2mat(rawNumericColumns(:, 10));
grade1 = cell2mat(rawNumericColumns(:, 11));
sqft_above1 = cell2mat(rawNumericColumns(:, 12));
sqft_basement1 = cell2mat(rawNumericColumns(:, 13));
yr_built1 = cell2mat(rawNumericColumns(:, 14));
yr_renovated1 = cell2mat(rawNumericColumns(:, 15));
zipcode1 = cell2mat(rawNumericColumns(:, 16));
lat1 = cell2mat(rawNumericColumns(:, 17));
long1 = cell2mat(rawNumericColumns(:, 18));
sqft_living2 = cell2mat(rawNumericColumns(:, 19));
sqft_lot2 = cell2mat(rawNumericColumns(:, 20));
%Variables
bedrooms1(1,:)=[];
price1(1,:)=[];
AllData=cell2mat(rawNumericColumns(1:21613,3:20));
AllPrice=cell2mat(rawNumericColumns(1:21613,2));
Pricenormalized=AllPrice/mean(AllPrice);
TrainingSet=AllData(1:12968,:);
CVSet=AllData(12969:17291,:);
TestSet=AllData(17292:21613,:);
PriceTraining=Pricenormalized(1:12968,:);
PriceCV=Pricenormalized(12969:17291,:);
PriceTest=Pricenormalized(17292:21613,:);
m=length(TrainingSet(:,1));
mCV=length(CVSet(:,1));
mT=length(TestSet(:,1));
result=AllPrice(1:12968,:);
alphaH1 = 0.01; %learning rate
alphaH2 = 0.01;
alphaH3=0.01;
[X1]=TrainingSet;
[XNCV]=CVSet;
[XNT]=TestSet;
Y=PriceTraining;
YCV=PriceCV;
YT=PriceTest;
feature=[ones(m,1),TrainingSet];
%% HYPOTHESIS1 Polynomial > floors veiw conditon grade wf 
V3=X1(:,5:9);
V4C=XNCV(:,5:9);
V4T=XNT(:,5:9);
hypothesis11=featureNormalize([X1,V3.^2]);
hypothesis11C=featureNormalize([XNCV,V4C.^2]);
hypothesis12=featureNormalize([hypothesis11,V3.^3,V3.^4]);
hypothesis12C=featureNormalize([hypothesis11C,V4C.^3,V4C.^4]);
hypothesis13=featureNormalize([hypothesis12,V3.^5,V3.^6]);
hypothesis13C=featureNormalize([hypothesis12C,V4C.^5,V4C.^6]);
hypothesis14=featureNormalize([hypothesis13,V3.^7,V3.^8]);
hypothesis14C=featureNormalize([hypothesis13C,V4C.^7,V4C.^8]);
hypothesis14T=featureNormalize([XNT,V4T.^2,V4T.^3,V4T.^4]);
hypothesis11=[ones(m,1),hypothesis11];
hypothesis11C=[ones(mCV,1),hypothesis11C];
hypothesis12=[ones(m,1),hypothesis12];
hypothesis12C=[ones(mCV,1),hypothesis12C];
hypothesis13=[ones(m,1),hypothesis13];
hypothesis13C=[ones(mCV,1),hypothesis13C];
hypothesis14=[ones(m,1),hypothesis14];
hypothesis14C=[ones(mCV,1),hypothesis14C];
hypothesis14T=[ones(mT,1),hypothesis14T];
theta11=zeros(size(hypothesis11,2),1);
theta12=zeros(size(hypothesis12,2),1);
theta13=zeros(size(hypothesis13,2),1);
theta14=zeros(size(hypothesis14,2),1);
initialCostH1=ComputeCost(hypothesis11,Y,theta11)
%gradientDescent
[thetaH11, J_historyH11]=GradientDescentMulti(hypothesis11,Y,theta11,alphaH1,initialCostH1);
[thetaH12, J_historyH12]=GradientDescentMulti(hypothesis12,Y,theta12,alphaH1,initialCostH1);
[thetaH13, J_historyH13]=GradientDescentMulti(hypothesis13,Y,theta13,alphaH1,initialCostH1);
[thetaH14, J_historyH14]=GradientDescentMulti(hypothesis14,Y,theta14,alphaH1,initialCostH1);
%Cost Cross Validation
finalCostH11=ComputeCost(hypothesis11C,YCV,thetaH11)
finalCostH12=ComputeCost(hypothesis12C,YCV,thetaH12)
finalCostH13=ComputeCost(hypothesis13C,YCV,thetaH13)
finalCostH14=ComputeCost(hypothesis14C,YCV,thetaH14)
%Choosedegree from CV 
figure(1);
plot(2:2:8,[finalCostH11,finalCostH12,finalCostH13,finalCostH14]);
xlabel('Polynomial degree');
ylabel('Error');
title('Hypothesis1');
%Chosen Degree 4 
TestCostH14=ComputeCost(hypothesis14T,YT,thetaH12)
%error vs no_iterarions
figure(2);
plot(1:length(J_historyH12), J_historyH12, '-b');
xlabel('Number of iterations');
ylabel('Cost J');
title('Hypothesis1');
%normaleq
thetanormalH1=NormalFunc([ones(m,1),X1],result)
%% HYPOTHESIS 2 All values linear except
%(bedrooms,floor,waterfront,grade,view)
P1=X1(:,1);
P2=X1(:,2:4);
P3=X1(:,5:9);
P4=X1(:,10:18);
P1C=XNCV(:,1);
P2C=XNCV(:,2:4);
P3C=XNCV(:,5:9);
P4C=XNCV(:,10:18);
P1T=XNT(:,1);
P2T=XNT(:,2:4);
P3T=XNT(:,5:9);
P4T=XNT(:,10:18);
hypothesis21=featureNormalize([P1,P2,P3,P4,P1.^2,P3.^2]);  
hypothesis22=featureNormalize([hypothesis21,P1.^3,P3.^3,P1.^4,P3.^4]); 
hypothesis23=featureNormalize([hypothesis22,P1.^5,P3.^5,P1.^6,P3.^6]);
hypothesis21C=featureNormalize([P1C,P2C,P3C,P4C,P1C.^2,P3C.^2]);  
hypothesis22C=featureNormalize([hypothesis21C,P1C.^3,P3C.^3,P1C.^4,P3C.^4]);  
hypothesis23C=featureNormalize([hypothesis22C,P1C.^5,P3C.^5,P1C.^6,P3C.^6]);
hypothesis23T=featureNormalize([P1T,P2T,P3T,P4T,P1T.^2,P3T.^2,P1T.^3,P3T.^3,P1T.^4,P3T.^4]);
hypothesis21=[ones(m,1),hypothesis21];
hypothesis21C=[ones(mCV,1),hypothesis21C];
hypothesis22=[ones(m,1),hypothesis22];
hypothesis22C=[ones(mCV,1),hypothesis22C];
hypothesis23=[ones(m,1),hypothesis23];
hypothesis23C=[ones(mCV,1),hypothesis23C];
hypothesis23T=[ones(mT,1),hypothesis23T];
theta21=zeros(size(hypothesis21,2),1);
theta22=zeros(size(hypothesis22,2),1);
theta23=zeros(size(hypothesis23,2),1);
%initialcost
initialCostH2=ComputeCost(hypothesis22,Y,theta22)
%gradientDescent
[thetaH21, J_historyH21]=GradientDescentMulti(hypothesis21,Y,theta21,alphaH2,initialCostH2);
[thetaH22, J_historyH22]=GradientDescentMulti(hypothesis22,Y,theta22,alphaH2,initialCostH2);
[thetaH23, J_historyH23]=GradientDescentMulti(hypothesis23,Y,theta23,alphaH2,initialCostH2);
%Cost Cross Validation
finalCostH21=ComputeCost(hypothesis21C,YCV,thetaH21)
finalCostH22=ComputeCost(hypothesis22C,YCV,thetaH22)
finalCostH23=ComputeCost(hypothesis23C,YCV,thetaH23)
%Choosedegree from CV 
figure(3);
plot(2:2:6,[finalCostH21,finalCostH22,finalCostH23]);
xlabel('Polynomial degree');
ylabel('Error');
title('Hypothesis2');
% %Chosen Degree 2 
TestCostH21=ComputeCost(hypothesis23T,YT,thetaH22)
%error vs no_iterarions
figure(4);
plot(1:length(J_historyH22), J_historyH22, '-b');
xlabel('Number of iterations');
ylabel('Cost J');
title('Hypothesis2');
%normaleq
thetanormalH2=NormalFunc([ones(m,1),P1,P2,P3,P4,P1.^2,P3.^2,P1.^3,P3.^3],result)
%% HYPOTHESIS 3 bathroom,bedrooms,living,condition,living2
F1=[X1(:,1:3),X1(:,8),X1(:,17)];
F1C=[XNCV(:,1:3),XNCV(:,8),XNCV(:,17)];
F1T=[XNT(:,1:3),XNT(:,8),XNT(:,17)];
F2=[X1(:,1:2),X1(:,4),X1(:,10:18)];
F2C=[XNCV(:,1:2),XNCV(:,4),XNCV(:,10:18)];
F2T=[XNT(:,1:2),XNT(:,4),XNT(:,10:18)];
hypothesis31=featureNormalize([F1,F2,F1.^2]);
hypothesis32=featureNormalize([hypothesis31,F1.^3,F1.^4]);
hypothesis33=featureNormalize([hypothesis32,F1.^5,F1.^6]);
hypothesis34=featureNormalize([hypothesis33,F1.^7,F1.^8]);
hypothesis31C=featureNormalize([F1C,F2C,F1C.^2]);
hypothesis32C=featureNormalize([hypothesis31C,F1C.^3,F1C.^4]);
hypothesis33C=featureNormalize([hypothesis32C,F1C.^5,F1C.^6]);
hypothesis34C=featureNormalize([hypothesis33C,F1C.^7,F1C.^8]);
hypothesis31=[ones(m,1),hypothesis31];
hypothesis32=[ones(m,1),hypothesis32];
hypothesis33=[ones(m,1),hypothesis33];
hypothesis34=[ones(m,1),hypothesis34];
hypothesis31C=[ones(mCV,1),hypothesis31C];
hypothesis32C=[ones(mCV,1),hypothesis32C];
hypothesis33C=[ones(mCV,1),hypothesis33C];
hypothesis34C=[ones(mCV,1),hypothesis34C];
hypothesis34T=featureNormalize([F1T,F2T,F1T.^2]);
hypothesis34T=[ones(mT,1),hypothesis34T];
theta31=zeros(size(hypothesis31,2),1);
theta32=zeros(size(hypothesis32,2),1);
theta33=zeros(size(hypothesis33,2),1);
theta34=zeros(size(hypothesis34,2),1);
% %initialcost
 initialCostH31=ComputeCost(hypothesis31,Y,theta31)
% %gradientDescent
[thetaH31, J_historyH31]=GradientDescentMulti(hypothesis31,Y,theta31,alphaH3,initialCostH31);
[thetaH32, J_historyH32]=GradientDescentMulti(hypothesis32,Y,theta32,alphaH3,initialCostH31);
[thetaH33, J_historyH33]=GradientDescentMulti(hypothesis33,Y,theta33,alphaH3,initialCostH31);
[thetaH34, J_historyH34]=GradientDescentMulti(hypothesis34,Y,theta34,alphaH3,initialCostH31);
% thetaH31
% %increasing the degree leads to an increase in the error 
finalCostH31=ComputeCost(hypothesis31C,YCV,thetaH31)
finalCostH32=ComputeCost(hypothesis32C,YCV,thetaH32)
finalCostH33=ComputeCost(hypothesis33C,YCV,thetaH33)
finalCostH34=ComputeCost(hypothesis34C,YCV,thetaH34)
% Choosedegree from CV 
figure(5);
plot(2:2:8,[finalCostH31,finalCostH32,finalCostH33,finalCostH34]);
xlabel('Polynomial degree');
ylabel('Error');
title('Hypothesis3');
% % Degree Chosen > Degree 1 
TestCostH31=ComputeCost(hypothesis34T,YT,thetaH31)
% error vs no_iterarions
figure(6);
plot(1:length(J_historyH34), J_historyH34, '-b');
xlabel('Number of iterations');
ylabel('Cost J');
title('Hypothesis3');
% normaleq
thetanormalH3=NormalFunc([ones(m,1),F1,F1.^2,F1.^3,F1.^4],result)
%% HYPOTHESIS 4  Poly degree 2 sqft_living
hypothesis41=featureNormalize([X1,X1(:,3).^2]);
hypothesis42=featureNormalize([hypothesis41,X1(:,3).^3,X1(:,3).^4]);
hypothesis43=featureNormalize([hypothesis42,X1(:,3).^5,X1(:,3).^6]);
hypothesis44=featureNormalize([hypothesis43,X1(:,3).^7,X1(:,3).^8]);
hypothesis41C=featureNormalize([XNCV,XNCV(:,3).^2]);
hypothesis42C=featureNormalize([hypothesis41C,XNCV(:,3).^3,XNCV(:,3).^4]);
hypothesis43C=featureNormalize([hypothesis42C,XNCV(:,3).^5,XNCV(:,3).^6]);
hypothesis44C=featureNormalize([hypothesis43C,XNCV(:,3).^7,XNCV(:,3).^8]);

hypothesis45T=featureNormalize([XNT,XNT(:,3).^2]);
hypothesis41=[ones(m,1),hypothesis41];
hypothesis42=[ones(m,1),hypothesis42];
hypothesis43=[ones(m,1),hypothesis43];
hypothesis44=[ones(m,1),hypothesis44];
hypothesis41C=[ones(mCV,1),hypothesis41C];
hypothesis42C=[ones(mCV,1),hypothesis42C];
hypothesis43C=[ones(mCV,1),hypothesis43C];
hypothesis44C=[ones(mCV,1),hypothesis44C];
hypothesis45T=[ones(mT,1),hypothesis45T];
theta41=zeros(size(hypothesis41,2),1);
theta42=zeros(size(hypothesis42,2),1);
theta43=zeros(size(hypothesis43,2),1);
theta44=zeros(size(hypothesis44,2),1);
%initialcost
initialCostH41=ComputeCost(hypothesis41,Y,theta41)
%gradientDescent
[thetaH41, J_historyH41]=GradientDescentMulti(hypothesis41,Y,theta41,alphaH3,initialCostH41);
[thetaH42, J_historyH42]=GradientDescentMulti(hypothesis42,Y,theta42,alphaH3,initialCostH41);
[thetaH43, J_historyH43]=GradientDescentMulti(hypothesis43,Y,theta43,alphaH3,initialCostH41);
[thetaH44, J_historyH44]=GradientDescentMulti(hypothesis44,Y,theta44,alphaH3,initialCostH41);
%increasing the degree leads to an increase in the error 
finalCostH41=ComputeCost(hypothesis41C,YCV,thetaH41)
finalCostH42=ComputeCost(hypothesis42C,YCV,thetaH42)
finalCostH43=ComputeCost(hypothesis43C,YCV,thetaH43)
finalCostH44=ComputeCost(hypothesis44C,YCV,thetaH44)
%Choosedegree from CV 
figure(7);
plot(2:2:8,[finalCostH41,finalCostH42,finalCostH43,finalCostH44]);
xlabel('Polynomial degree');
ylabel('Error');
title('Hypothesis4');
%Degree Chosen > Degree 2
TestCostH41=ComputeCost(hypothesis45T,YT,thetaH41)
%error vs no_iterarions
figure(8);
plot(1:length(J_historyH42), J_historyH42, '-b');
xlabel('Number of iterations');
ylabel('Cost J');
title('Hypothesis4');
%normaleq
 thetanormalH4=NormalFunc([X1,X1(:,3).^2,X1(:,3).^3,X1(:,3).^4],result)
 %% TEST errors of all hypothesis 
figure(9);
stem(1:4,[TestCostH14,TestCostH21,TestCostH31,TestCostH41]);
xlabel('4 Hypothesis');
ylabel('TestError');
%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me rawNumericColumns rawCellColumns R;