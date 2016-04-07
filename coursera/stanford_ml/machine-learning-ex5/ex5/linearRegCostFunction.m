function [J, grad] = linearRegCostFunction(X, y, theta, lambda)
%LINEARREGCOSTFUNCTION Compute cost and gradient for regularized linear 
%regression with multiple variables
%   [J, grad] = LINEARREGCOSTFUNCTION(X, y, theta, lambda) computes the 
%   cost of using theta as the parameter for linear regression to fit the 
%   data points in X and y. Returns the cost in J and the gradient in grad

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 

grad = zeros(size(theta));
  function res = computeH(X, theta)
    res = X*theta;
  end
h = X*theta;
lambdaSum = lambda/(2*m)*sum(theta(2:end).^2);
J =  sum((h - y).^2)/(2*m) + lambdaSum;
lambdas = lambda/m*theta;
lambdas(1,1) = 0;
% grad = zeros(size(theta));
grad = 1/m.*(h-y)'*X;
grad = grad + lambdas';
%

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost and gradient of regularized linear 
%               regression for a particular choice of theta.
%
%               You should set J to the cost and grad to the gradient.
%












% =========================================================================

grad = grad(:);

end
