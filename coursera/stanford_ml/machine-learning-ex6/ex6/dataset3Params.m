function [C, sigma] = dataset3Params(X, y, Xval, yval)
%EX6PARAMS returns your choice of C and sigma for Part 3 of the exercise
%where you select the optimal (C, sigma) learning parameters to use for SVM
%with RBF kernel
%   [C, sigma] = EX6PARAMS(X, y, Xval, yval) returns your choice of C and 
%   sigma. You should complete this function to return the optimal C and 
%   sigma based on a cross-validation set.
%

% You need to return the following variables correctly.
poss_values = [ 0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30];
min_err = realmax();
C = 1;
sigma = 0.1;

%for curC = poss_values 
  %for curSigma = poss_values 
    %model = svmTrain(X, y, curC, @(x1, x2) gaussianKernel(x1, x2, curSigma), 1e-3, 20);
    %predictions = svmPredict(model, Xval);
    %err = mean(double(predictions ~= yval));
    %curC
    %curSigma
    %%pause;
    %err
    %%min_err
    %if (err < min_err)
      %min_err = err;
      %C = curC;
      %sigma = curSigma;
    %endif
  %end
%end

%C
%sigma


% ====================== YOUR CODE HERE ======================
% Instructions: Fill in this function to return the optimal C and sigma
%               learning parameters found using the cross validation set.
%               You can use svmPredict to predict the labels on the cross
%               validation set. For example, 
%                   predictions = svmPredict(model, Xval);
%               will return the predictions on the cross validation set.
%
%  Note: You can compute the prediction error using 
%        mean(double(predictions ~= yval))
%







% =========================================================================

end
