function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
function res = computeH(X, theta)
  res = sigmoid(X*theta);
end

function res = demx(n,siz)
  res = 1:siz == n;
end

% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
%size(Theta1_grad)
bigDelta1 = zeros(size(Theta1));
%size(bigDelta1)
Theta2_grad = zeros(size(Theta2));
%size(Theta2_grad)
bigDelta2 = zeros(size(Theta2));
%size(bigDelta2)

function [z2, a2, z3, a3] = frontProp(t)
  curX = X(t,:);
  curY = y(t);
  a1 = [1 curX];
  z2 = a1*Theta1';
  a2 = [1 sigmoid(z2)];
  z3 = a2*Theta2';
  a3 = sigmoid(z3);
  decY = demx(curY, columns(a3));
  tempJ = 1/m*((-decY).*log(a3) - (1-decY).*log(1-a3));
  J += sum(tempJ);
end

function backProp(z2, a2, z3, a3, t)
  curX = X(t,:);
  curY = demx(y(t), columns(a3));
  delta3 = a3 - curY;
  bigDelta2 += (delta3') * a2;
  delta2 = delta3*Theta2 .* [0 sigmoidGradient(z2)];
  delta2 = delta2(2:end);
  bigDelta1 += (delta2') * [1 curX];
end

for t = 1:m
  [z2, a2, z3, a3] = frontProp(t);
  backProp(z2,a2,z3, a3, t);
end

lambdaSum = lambda/(2*m)*(sum(Theta1(:,2:end)(:).^2) + sum(Theta2(:,2:end)(:).^2));
J += lambdaSum;
bigDelta1 = bigDelta1/m;
regSum1 = lambda/m*Theta1;
regSum1(:,1) = zeros(rows(Theta1),1);
Theta1_grad += bigDelta1 + regSum1;
bigDelta2 = bigDelta2/m;
regSum2 = lambda/m*Theta2;
regSum2(:,1) = zeros(rows(Theta2),1);
Theta2_grad += bigDelta2 + regSum2;
        %
% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%



















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
