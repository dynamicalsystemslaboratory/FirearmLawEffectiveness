function [results] = correct_pvals(results)

% get p-value for significance
p_sig_temp = (0.05/size(results,1):0.05/size(results,1):0.05); % an array containing gradients of Bonferroni's correction
p_sig = max(p_sig_temp((p_sig_temp-sort(results.p_value)')>0)); % the corrected p-value for significance
if isempty(p_sig)
    p_sig = 0;
end

% get p-value for trend
p_trd_temp = (0.1/size(results,1):0.1/size(results,1):0.1); % an array containing gradients of Bonferroni's correction
p_trd = max(p_trd_temp((p_trd_temp-sort(results.p_value)')>0)); % the corrected p-value
if isempty(p_trd)
    p_trd = 0;
end

for d = 0:size(results,1)-1
    results.FDR_sig(d+1) = results.p_value(d+1)<p_sig;
    results.FDR_trd(d+1) = (results.p_value(d+1)>p_sig)&(results.p_value(d+1)<p_trd);
end


end