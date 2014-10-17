clear all
close all
load('D:\grating2p8orient2sf.mat');

cycLength=10;
cycLength = input('cycle length (secs) :');
[f p] = uigetfile('*.tif','tif file');
fname = fullfile(p,f)

[img, framerate] = readAlign2p(fname,1,1,0.25);

display('doing prctile')
tic
m = prctile(img(:,:,10:10:end),10,3);
toc
figure
imagesc(m);
title('10th prctile')
colormap(gray)

dfof=zeros(size(img));
for f = 1:nframes
    dfof(:,:,f)=(img(:,:,f)-m)./m;
end



im_dt = 1/framerate;
dt = 0.25;
dfofInterp = interp1(0:im_dt:(nframes-1)*im_dt,shiftdim(dfof,2),0:dt:(nframes-1)*im_dt);
dfofInterp = shiftdim(dfofInterp,1);
imgInterp = interp1(0:im_dt:(nframes-1)*im_dt,shiftdim(img,2),0:dt:(nframes-1)*im_dt);
imgInterp = shiftdim(imgInterp,1);

cycFrames =cycLength/dt; 
map=0; clear cycAvg mov

range = [prctile(mn(:),2) prctile(mn(:),98)];
figure
for f = 1:cycFrames;
    cycAvg(:,:,f) = mean(imgInterp(:,:,f:cycFrames:end),3);   
    imagesc(cycAvg(:,:,f),range); colormap gray
    mov(f)=getframe(gcf);
end
title('raw img frames')
vid = VideoWriter(sprintf('%sCycleMov.avi',fname(1:end-4)));
vid.FrameRate=10;
open(vid);
writeVideo(vid,mov(1:end));
close(vid)

fullMov= mat2im(img(:,:,100:700),gray,[prctile(mn(:),2) 1.5*prctile(mn(:),98)]);
mov = immovie(permute(fullMov,[1 2 4 3]));
vid = VideoWriter(sprintf('%sfullMov.avi',fname(1:end-4)));
vid.FrameRate=20;
open(vid);
writeVideo(vid,mov(1:end));
close(vid)

figure
timecourse = squeeze(mean(mean(dfofInterp(:,:,1:60/dt),2),1));
plot(timecourse);

cycTimecourse = squeeze(mean(mean(cycAvg,2),1));
figure
plot(cycTimecourse);



figure
plot(squeeze(mean(mean(dfofInterp(:,:,end-360/dt:end),2),1)))

figure
imagesc(abs(map))
title('map amp');

figure
imagesc(angle(map))
title('map phase');
colormap(hsv)

figure
imshow(polarMap(map))
title('polarMap')

pmap = polarMap(map);

figure
imshow(m/(prctile(m(:),98)));
hold on
h=imshow(pmap);
transp = abs(map)>1;
set(h,'AlphaData',transp)
title('mean img overlaid with masked map');


 filt = fspecial('gaussian',5,1)
mapfilt = imfilter(map,filt);
figure
imshow(polarMap(mapfilt))
title('filtered map');

figure
imshow(m/(prctile(m(:),99)));
hold on
h=imshow(polarMap(mapfilt))
transp = abs(mapfilt)>1.5;
set(h,'AlphaData',transp)
title('mean image with filtered and masked map');

figure
h=imshow(pmap)
transp = abs(map)>2;
set(h,'AlphaData',transp)
title('maked with higher thresh')

absfig = figure
%imshow(zeros(size(m)));
imshow(m/max(m(:))*1.5);
hold on
capdf = mean(dfof,3);
capdf(capdf>0.4)=0.4;
%h= imagesc(capdf,[0.1 0.4]); colormap jet
im = mat2im(capdf, jet,[0.1 0.4]);
h=imshow(im)
transp = capdf>0.2;
set(h,'AlphaData',transp)
title('mean elicited response')


nstim = length(xpos);
baseRange = (2:dt:3.5)/dt;
evokeRange = (0:dt:3.5)/dt
startTime=124;
for s = 1:nstim;
    base(:,:,s) = mean(dfofInterp(:,:,startTime + (s-1)*(duration+isi)/dt +baseRange),3);
    evoked(:,:,s) = mean(dfofInterp(:,:,startTime + isi/dt +(s-1)*(duration+isi)/dt +evokeRange),3);
end

figure
imagesc(squeeze(mean(evoked-base,3)),[-0.5 0.5]);
resp = evoked-base;

angles = unique(theta);
sfs = unique(sf);

for th = 1:length(angles);
    for sp = 1:length(sfs);
    
    orientation(:,:,th,sp) = median(resp(:,:,theta ==angles(th) & sf==sfs(sp)),3);
    figure
    
    imagesc(squeeze(orientation(:,:,th)),[-0.5 0.5]);
    
    end
end


R = max(max(orientation,[],4),[],3);

figure
imagesc(R,[0 2]);


keyboard

absmap = figure
imagesc(R,[0 2])
range=-1:1;
%for i = 1:25;
done=0;

i=0;
while ~done
   i=i+1;
   figure(absmap)
    [y x b]= (ginput(1));
   if b==3
       done=1;
   else
       x = round(x); y=round(y);
    figure
    full = squeeze(mean(mean(dfofInterp(x+range,y+range,:),2),1));
    plot(full)
    title('full timecourse');
    figure
   avg = squeeze(mean(mean(cycAvg(x+range,y+range,:),2),1));
   plot(avg)
    title('cyc avg timecourse');
    
       figure
   ori = squeeze(mean(mean(orientation(x+range,y+range,:,:),2),1));
   plot(ori)
    title('orientation');
    legend('lo','hi')
    
    
    trace(:,i) = full;
    avgTrace(:,i) = avg;
    %oriTuning(:,i)=ori;
   end
%     figure
%     plot(0:45:315,avgTrace(4:10:end,i))
end
    
figure
plot(trace);
figure
plot(avgTrace);

c = 'rgbcmk'
figure
hold on
for i = 1:25;
    plot(trace(50:1250,i)/max(trace(:,i)) + i/2,c(mod(i,6)+1));
end

thresh=0.8;
cor = corr(trace);
np =0; clear mergetrace mergeAvgTrace
for i = 1:size(cor,1);
    merge = find(cor(:,i)>thresh);
    if ~isempty(merge);
        np=np+1;
        mergetrace(:,np) = mean(trace(:,merge),2);
        mergeAvgTrace(:,np) = mean(avgTrace(:,merge),2);
        normAvgTrace(:,np) = mergeAvgTrace(:,np)/max(mergeAvgTrace(:,np));
        cor(merge,:)=0;
        cor(:,merge)=0;
    end
end

figure
plot(mergeAvgTrace);

c = 'rgbcmk'
nc = 3;
idx=kmeans(normAvgTrace',nc);
figure
hold on
for i = 1:np;
    plot(0.25:0.25:10,mergeAvgTrace(:,i),c(idx(i)));
end
%figure
hold on
for i = 1:nc;
    plot(0.25:0.25:10,mean(mergeAvgTrace(:,idx==i),2),c(i),'LineWidth',3);
end

c = 'rgbcmk'
figure
hold on
for i = 1:np;
    plot(0.25*(1:length(50:1250)),mergetrace(50:1250,i)/max(trace(:,i)) + i,c(mod(i,6)+1));
end
xlabel('secs')
ylim([0 np+2]);





