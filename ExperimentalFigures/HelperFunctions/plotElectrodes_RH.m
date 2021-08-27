function c = plotElectrodes_RH(coords,vals,chanSize,clims,cmap)
%Plots electrodes onto the right hemisphere.

%% Plot Cortex
surfaceMat = load('FreesurferAverageVerticesFaces.mat');
t.faces = [surfaceMat.rhfaces+1];
t.vertices = [surfaceMat.rhvtx];
t.EdgeColor = 'none';
t.faceColor = 'interp';
t.facevertexCData = ones(length(t.vertices),3);
t.facealpha = 1;
patch(t);
hold on
h = rotate3d;
h.ActionPostCallback = @RotationCallback;
h.Enable = 'on';

axis square;
axis equal;

c = camlight('headlight','infinite');
lighting gouraud
material dull;
axis off

%% colormap
colormap(cmap)
set(gca,'clim',clims);

%% plot channels
nearestVertex = nearestVertices(t.vertices,coords);
[xs,ys,zs] = sphere;
%[xs,ys,zs] = spikeySphere;
%[xs,ys,zs] = cylinder([1 0],4);
temp = surf2patch(xs,ys,zs,ones(size(zs)));
counter = 0;
electrodePatch = struct;
numChans = length(vals);

electrodePatch.faces = zeros(numChans * size(temp.faces,1),4);
electrodePatch.vertices = zeros(numChans * size(temp.vertices,1),3);
electrodePatch.facevertexcdata = zeros(numChans * size(temp.facevertexcdata,1),1);
electrodePatch.edgecolor = 'none';
electrodePatch.facecolor = 'interp';

for cn = 1:numChans
    x = (chanSize(cn)*xs) + t.vertices(nearestVertex(cn),1);
    y = (chanSize(cn)*ys) + t.vertices(nearestVertex(cn),2);
    z = (chanSize(cn)*zs) + t.vertices(nearestVertex(cn),3);
    temp = surf2patch(x,y,z,vals(cn) * ones(size(z)));
    faceInds = 1 + (cn-1) * size(temp.faces,1):cn * size(temp.faces,1);
    verticesInds =  1 + (cn-1) * size(temp.vertices,1):cn * size(temp.vertices,1);
    electrodePatch.faces(faceInds,:) = temp.faces + verticesInds(1) - 1;
    electrodePatch.vertices(verticesInds,:) = temp.vertices;
    electrodePatch.facevertexcdata(verticesInds,:) = temp.facevertexcdata;
end
p = patch(electrodePatch);
set(p,'AmbientStrength',0.3);
    set(p,'DiffuseStrength',0.6);
    set(p,'SpecularStrength',0.9);
    set(p,'SpecularExponent',20);
    set(p,'SpecularColorReflectance',1.0);
    
lighting gouraud

axis([-100 100 -115 85 -100 100]);




    function RotationCallback(~,~)
        c = camlight(c,'headlight');
    end
end