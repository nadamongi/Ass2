function [X_norm] = featureNormalize(X)
for w=2:length(X(1,:));
 if max(abs(X(:,w)))~=0
    X_norm(:,w)=(X(:,w)-mean((X(:,w))))./std(X(:,w));
 
       %uy X_norm(:,w)=X(:,w)/mean((X(:,w)));
 end

end


