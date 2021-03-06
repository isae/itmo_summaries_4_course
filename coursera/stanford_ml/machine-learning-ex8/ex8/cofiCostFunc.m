function [J, grad] = cofiCostFunc(params, Y, R, num_users, num_movies, ...
                                  num_features, lambda)
%COFICOSTFUNC Collaborative filtering cost function
%   [J, grad] = COFICOSTFUNC(params, Y, R, num_users, num_movies, ...
%   num_features, lambda) returns the cost and gradient for the
%   collaborative filtering problem.
%

% Unfold the U and W matrices from params
X = reshape(params(1:num_movies*num_features), num_movies, num_features);
Theta = reshape(params(num_movies*num_features+1:end), ...
                num_users, num_features);

            
% You need to return the following values correctly
lTheta = lambda*sum((Theta.^2)(:))/2;
lX = lambda*sum((X.^2)(:))/2;
J = sum(sum(R.*(X * Theta' - Y).^2))/2 + lTheta + lX;
X_grad = zeros(size(X));
Theta_grad = zeros(size(Theta));

%%num_users
%num_movies
%num_features
for i = 1:size(X_grad,1)
  idx = find(R(i,:) == 1);
  y_temp = Y(i,idx);
  Theta_temp = Theta(idx, :);
  X_grad(i,:) = (X(i,:)*Theta_temp' -y_temp) * Theta_temp + lambda*X(i,:);
end
for i = 1:size(Theta_grad,1)
  idx = find(R(:,i) == 1);
  y_temp = Y(idx,i);
  Theta_temp = Theta(i,:);
  Theta_grad(i,:) = X(idx,:)' * (X(idx,:)*Theta_temp' -y_temp) + lambda*Theta_temp'; 
end
%
%X_grad
%pause;

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost function and gradient for collaborative
%               filtering. Concretely, you should first implement the cost
%               function (without regularization) and make sure it is
%               matches our costs. After that, you should implement the 
%               gradient and use the checkCostFunction routine to check
%               that the gradient is correct. Finally, you should implement
%               regularization.
%
% Notes: X - num_movies  x num_features matrix of movie features
%        Theta - num_users  x num_features matrix of user features
%        Y - num_movies x num_users matrix of user ratings of movies
%        R - num_movies x num_users matrix, where R(i, j) = 1 if the 
%            i-th movie was rated by the j-th user
%
% You should set the following variables correctly:
%
%        X_grad - num_movies x num_features matrix, containing the 
%                 partial derivatives w.r.t. to each element of X
%        Theta_grad - num_users x num_features matrix, containing the 
%                     partial derivatives w.r.t. to each element of Theta
%
















% =============================================================

grad = [X_grad(:); Theta_grad(:)];

end
