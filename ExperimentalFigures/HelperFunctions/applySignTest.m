function [pvalue,z] = applySignTest(numType1, numType2, numType0)
%% Applies signtest given counts of +ve,-ve and zeros
if nargin < 3
    numType0 = 0;
end
total = ones(numType1 + numType2 + numType0, 1);
total(1:numType1) = -1;
total(numType1 + numType2 + 1:end) = 0; 
[pvalue,~,stats] = signtest(total,0,'method','approximate');

z = stats.zval;