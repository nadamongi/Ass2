function [ theta, J_history ] = GradientDescentMulti( X,y,theta,alpha,initialCost )

m = length(y); % number of training examples
%J_history = zeros(iterations, 1);
k=1;
J_history(k)=initialCost;
r=1;

while r==1 ,
   theta=theta-(alpha/m)*X'*(X*theta-y);
    k=k+1;
    J_history(k)=ComputeCost(X,y,theta);
    if J_history(k-1)-J_history(k)<0
    break
    end
q=(J_history(k-1)-J_history(k))./J_history(k-1);
if q <.000001;
   r=0;
end
end    
end


