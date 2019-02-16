function J = ComputeCost( X,Y,theta )

m=length(Y);
h=X*theta;
L=length(theta);
%cost

J=(1/(2*m))*sum((h-Y).^2)+((0.00000001/(2*m)* sum((theta(2:L,1)).^2)));


end

