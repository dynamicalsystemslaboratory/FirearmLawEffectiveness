%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function computes the transfer entropy from time series x to time  
% series y. It returns the amount of observed transfer entropy (TE), a 
% surrogate distribution (SD), and a p-value of hypothesis that the 
% observed transfer entropy is greater than the 95th percentile of the 
% surrogate distribution (P).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [TE,SD,P,PV] = compute_transfer_entropy(x,y,n_iter)

% TE = H(Y_t+1|Y_t) - H(Y_t+1|Y_t,X_t) = H(Y_t+1,Y_t) - H(Y_t) - H(Y_t+1,Y_t,X_t) + H(Y_t,X_t)
TE = compute_entropy([y(2:end) y(1:end-1)]) - compute_entropy(y(1:end-1)) - compute_entropy([y(2:end) y(1:end-1) x(1:end-1)]) + compute_entropy([y(1:end-1) x(1:end-1)]);

SD = []; % empty array to be filled with TE values
for it = 1:n_iter
    
    x_p = x(randperm(length(x)));
%     y_p = y(randperm(length(y)));
    SD = [SD; compute_entropy([y(2:end) y(1:end-1)]) - compute_entropy(y(1:end-1)) - compute_entropy([y(2:end) y(1:end-1) x_p(1:end-1)]) + compute_entropy([y(1:end-1) x_p(1:end-1)])];
    
end

P = prctile(SD,95);
PV = 1-find(abs(prctile(SD,[1:0.0001:100],'all')-TE)==min(abs(prctile(SD,[1:0.0001:100],'all')-TE)),1,'first')/length([1:0.0001:100]);


end