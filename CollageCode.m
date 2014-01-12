function [FinalImage] = CollageCode(Resolution,Cycle,Ratio,SmallImageSize,Images_Dir,MainImageLoc,Tint,PixelPercentage)  
% tic;
cd(Images_Dir);

D = dir('*.jpg');                           % Find any images in the set directory
MainImage = imread(MainImageLoc);        % Import Main Large Image
[h l RGB] = size(MainImage);                % Give Height Length for Main Image
Resolution = round(Resolution);
sizeBoxH = ceil(SmallImageSize*h);        % Actual Size of SubImage in Y direction (height)
sizeBoxL = ceil(SmallImageSize*Ratio*h);  % Actual Size of SubImage in X direction (length)

tic;
% Finds the mean intensities for subBlocks of Main Image ***
Average = cell(floor(((h-1+sizeBoxH)/sizeBoxH)-1),floor(((l-1+sizeBoxL)/sizeBoxL))-1);
for H = 1:sizeBoxH:h
    for L = 1:sizeBoxL:l
        if ((L+sizeBoxL<l) && (H + sizeBoxH<h)) % This if statement just avoids subBlocks being too small to complete the image and just skips the last edges
            Box = double(MainImage(H:H+sizeBoxH-1,L:L+sizeBoxL-1,:)); % Makes a box containing pixels in the subregion of the Main Image
            
            % Fragments Blocks Into More Blocks %%%%%%%%%%%%%%%%%%%%%%%%%%%% ^^^
            % This averages subregions of the subBlocks and writes them to
            % BoxAverages and then all the Averages' Matrices are stored in
            % Average
            BoxAverages = imresize(Box,[PixelPercentage*sizeBoxH PixelPercentage*sizeBoxL]);
            Average{(H-1+sizeBoxH)/sizeBoxH,(L-1+sizeBoxL)/sizeBoxL} = BoxAverages;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ^^^
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ***
time = toc

% Looks through directory of images and finds their median intensities -----
% by resizing the image, therefore every pixel now represents what     ---
% used to be a larger set of pixels. So this smaller pixel represents  ---
% the most common pixel of the previous set                            ---
tic;
% This for loop puts the average pixels of each subBlock of the small
% images into an array the size of the number of elements in the 
% directory 
[imH imL imRGB] = size(Average{1,1});   % This just gives H and L of matrices contained in Average so the small images match the size of MainImage's subBlocks
Pictures = cell(numel(D),1);                % Create the variable pictures that will later hold the averages for sub images of the small pictures
for i = 1:numel(D)
    FitImage = imresize(imread(D(i).name),[imH,imL]);  % This resizes small images to the size of subBlocks of MainImage
    Pictures{i,1} = imresize(imread(D(i).name),[imH,imL]);               % This array/cell holds the averages of each small image
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -----
time = toc
% tic;

% Compares Averages from MainImage with other images and finds best match
h = waitbar(0,'Please wait...Step 2/2');
Diff = zeros(numel(D),1);
if (Cycle>numel(D)) Cycle = numel(D)-1; end     % Limits the number of images that can cycle to the amount that exist - 1
LastImages = zeros(Cycle,1);                    % Array used for cycling images
[num_images_H num_images_L] = size(Average);    % This tells me the number of subBlocks contained in the image in the X and Y direction
% for H = 1:num_images_H
%     for L = 1:num_images_L
%         step = H*L;
%         waitbar(step/(num_images_H*num_images_L))
for i = 1:numel(D);
    Current_Pic = double(Pictures{i,1});
    for H = 1:num_images_H
        for L = 1:num_images_L
            Av = Average{H,L};
            Diff(H*L,1) = sum(sum(sum(abs(Current_Pic - Av))));
        end
    end
    clc;
    
    
    
    
    
%     Average2 = cell2mat(Average);
%     
%     Av = Average{H,L};
%     Pic = double(cell2mat(Pictures));
%     Av2 = Av; while (size(Av2,1)~=size(Pic,1)) Av2 = vertcat(Av2,Av); end
%     Diff2 = abs(Av2-Pic);
%     Diff3 = sum(Diff2,2);
%     Diff4 = sum(Diff3,3);
%     Diff5 = zeros(numel(D),1);
%     for i = 1:imH
%         Diff5 = Diff4(i:imH:(size(Diff4,1)-imH+i))+Diff5;
%     end
%     Diff(1,:) = Diff5(:,1);
%     
%     
%     
%     CheckRepeat = 1;
%     while (CheckRepeat==1)
%         BestImageLocation = find(Diff == min(min(Diff)));
%         CheckRepeat = max(max(uint8(LastImages == BestImageLocation(1))));
%         if (CheckRepeat == 0)
%             LastImages(1,1) = BestImageLocation(1);
%             LastImages = circshift(LastImages,1);
%         else
%             Diff(BestImageLocation(1))=inf;
%         end
%     end
%     
%     
%     
%     % Shift Color Toward Original Image By Set Percentage ---
%     Pic = double(Pictures{BestImageLocation(1),1});
%     clear Shift;
%     for i = 1:3 Shift(:,:,i) = ceil((Av(:,:,i)-Pic(:,:,i))*Tint); end
%     Shift = imresize(Shift,[sizeBoxH*Resolution,sizeBoxL*Resolution]);
%     
%     BestImage = imread(D(BestImageLocation(1)).name);
%     SmallImage = imresize(BestImage,[sizeBoxH*Resolution,sizeBoxL*Resolution]);
%     
%     SmallImage = uint8(ceil(double(SmallImage)+Shift));   % Shift/Tint colors of small image to be closer to MainImage's pixel values Red Green Blue
%     FinalImage{H,L} = SmallImage(1:sizeBoxH*Resolution,1:sizeBoxL*Resolution,:); % Store one block of Small Image into Collage
end
        %         time = toc
%     end
% end
FinalImage = cell2mat(FinalImage);
close(h)
% time = toc
max(time)



