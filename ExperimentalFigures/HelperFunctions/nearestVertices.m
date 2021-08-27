function [nearest, vect] = nearestVertices(vertices,electrodes)
%finds the nearest vertices on the surface for each electrode
vect = zeros(size(electrodes));

for i = 1:size(electrodes,1)
    
    dists = sum((vertices - (repmat(electrodes(i,:),[size(vertices,1) 1]))).^2,2);
    [~,nearest(i)] = min(dists);
    
    vect(i,:) = electrodes(i,:) - vertices(nearest(i),:);
    rms = (sum(vect(i,:).^2)).^0.5;
    vect(i,:) = vect(i,:) / rms;
end
end