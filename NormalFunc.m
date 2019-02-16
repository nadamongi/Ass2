function [ theta ] = NormalFunc( X, y)


theta = (((X.')*X)^(-1))*((X.')*y);


end

