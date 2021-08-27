function c = plotConnectedElectrodes(coords,vals,chanSize,clims,cmapElecs,adjMatrix)
%Plots connections on Cortex with color indicating direction

%% Plot Cortex
surfaceMat = load('FreesurferAverageVerticesFaces.mat');
t.faces = [surfaceMat.lhfaces+1 ; surfaceMat.rhfaces+1+length(surfaceMat.lhvtx)];
t.vertices = [surfaceMat.lhvtx ; surfaceMat.rhvtx];
t.EdgeColor = 'none';
t.faceColor = 'interp';
t.facevertexCData = 0.9*ones(length(t.vertices),3);

rt.faces = surfaceMat.rhfaces+1;
rt.vertices = surfaceMat.rhvtx;
rt.EdgeColor = 'none';
rt.faceColor = 'interp';
rt.facevertexCData = 0.5*ones(length(rt.vertices),3);
rt.facealpha = 0.5;


patch(rt);
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

%% plot channels
nearestVertex = nearestVertices(t.vertices,coords);
[xs,ys,zs] = sphere;
temp = surf2patch(xs,ys,zs,ones(size(zs)));
electrodePatch = struct;
numChans = length(vals);

electrodePatch.faces = zeros(numChans * size(temp.faces,1),4);
electrodePatch.vertices = zeros(numChans * size(temp.vertices,1),3);
electrodePatch.facevertexcdata = zeros(numChans * size(temp.facevertexcdata,1),1);
electrodePatch.edgecolor = 'none';
electrodePatch.facecolor = 'interp';
%% colormap
colormap(cmapElecs)
set(gca,'clim',clims);

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

[toInd,fromInd] = ind2sub([numChans numChans], find(adjMatrix));
sphericalMap = twilight(256);

dist = zeros(length(fromInd),1);
for i_link = 1:length(fromInd)
    fromCoords = t.vertices(nearestVertex(fromInd(i_link)),:);
    toCoords = t.vertices(nearestVertex(toInd(i_link)),:);
    a = toCoords - fromCoords;
    dist(i_link) = sum(a.^2);
end

[~,linkOrder] = sort(dist);
for i_link = 1:length(fromInd)
    fromCoords = t.vertices(nearestVertex(fromInd(linkOrder(i_link))),:);
    toCoords = t.vertices(nearestVertex(toInd(linkOrder(i_link))),:);
    tempThis = fromCoords;
    tempThat = toCoords;
    if fromCoords(2) > toCoords(2)
        tempThis(3) = tempThis(3) + 1;
        tempThat(3) = tempThat(3) + 1;
    else
        tempThis(3) = tempThis(3) - 1;
        tempThat(3) = tempThat(3) - 1;
    end
    a = toCoords - fromCoords;
    ang = atan2(a(2),a(3)) + pi;
    ang = floor((255 * (ang / (2*pi))) + 1);
    plot3([100-(i_link/1000) 100-(i_link/1000)],[tempThis(2) tempThat(2)],[tempThis(3) tempThat(3)],'color',sphericalMap(ang,:),'linewidth',0.7);
end


    function RotationCallback(~,~)
        c = camlight(c,'headlight');
    end
end

