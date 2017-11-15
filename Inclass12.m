% Darlan Conterno Minussi
%Inclass 12. 

%GB comments
1) 100
2) 100
3) 100
4) 100
Overall 100

% Continue with the set of images you used for inclass 11, the same time 
% point (t = 30)

reader = bfGetReader('011917-wntDose-esi017-RI_f0016.tif');

zplane = 1;
chan_c1 = 1;
chan_c2 = 2;
time = 30;

iplane_c1 = reader.getIndex(zplane-1, chan_c1-1, time-1)+1;
iplane_c2 = reader.getIndex(zplane-1, chan_c2-1, time-1)+1;


img1 = bfGetPlane(reader,iplane_c1);
img2 = bfGetPlane(reader,iplane_c2);

imshow(img2, []);

% 1. Use the channel that marks the cell nuclei. Produce an appropriately
% smoothed image with the background subtracted. 

img2_sm = imfilter(img2, fspecial('gaussian',4,2));
img2_bg = imopen(img2_sm, strel('disk',100));

img2_sm_bgsub = imsubtract(img2_sm, img2_bg);
imshow(img2_sm_bgsub, []);

% 2. threshold this image to get a mask that marks the cell nuclei. 

img2_sm_bgsub_bw = img2_sm_bgsub > 100;
imshow(img2_sm_bgsub_bw);

% 3. Use any morphological operations you like to improve this mask (i.e.
% no holes in nuclei, no tiny fragments etc.)

img_open = imopen(img2_sm_bgsub_bw, strel('disk', 6));
imshow(img_open,[]);

imshow(cat(3, img2_sm_bgsub_bw, img_open, zeros(size(img2_sm_bgsub_bw))));

% 4. Use the mask together with the images to find the mean intensity for
% each cell nucleus in each of the two channels. Make a plot where each data point 
% represents one nucleus and these two values are plotted against each other


mask_ch1 = regionprops(img_open, img1, 'MeanIntensity');
mask_ch2 = regionprops(img_open, img2, 'MeanIntensity');

mask_ch1_values = extractfield(mask_ch1,'MeanIntensity'); 
mask_ch2_values = extractfield(mask_ch2,'MeanIntensity'); 

scatter(mask_ch1_values, mask_ch2_values);
xlabel('Mean Intensity Mask + Ch1');
ylabel('Mean Intensity Mask + Ch2');

