
% [dim,numTraining] = size(projectedImageFeatures);
% %sigma = zeros(numLabels, dim, dim);
% %mu = zeros(numLabels, dim);
% sigma_elem = zeros(numLabels, 1);
% mu = wordVectors';
% 
% priors = zeros(numLabels, 1);

% for i=1:numLabels
labelImageFeatures_tot = rand(50)
labelImageFeatures=labelImageFeatures(1,:)

labelImageFeatures=squeeze(labelImageFeatures)
labelMu=labelImageFeatures_tot(2,:)
% priors(i) = size(labelImageFeatures, 2) / numTraining;
labelMu = squeeze(labelMu);
aaa=bsxfun(@minus, labelImageFeatures, labelMu)
sigma_elem = sum(sum(bsxfun(@minus, labelImageFeatures, labelMu).^2))
% sigma(i,:,:) = diag(repmat(sum(sum(bsxfun(@minus, labelImageFeatures, labelMu).^2))/(numTraining*dim), dim, 1));
% end

