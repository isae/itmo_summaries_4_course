function [J, grad] = costFunctionReg(theta, X, y, lambda)

%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

  function res = computeH(X, theta)
    res = sigmoid(X*theta);
  end
m = length(y); % number of training examples
h = computeH(X,theta);
lambdaSum = lambda/(2*m)*sum(theta(2:end).^2);
J =  1/m*((-y')*log(h) - (1-y')*log(1-h)) + lambdaSum;
lambdas = lambda/m*theta;
lambdas(1,1) = 0
% grad = zeros(size(theta));
grad = 1/m.*(h-y)'*X;
disp('size of grad'), disp(size(grad));
disp('size of lambdas'), disp(size(lambdas));
grad = grad + lambdas';

%% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta






% =============================================================

end
