%read the image
I = imread('boy.tif');
I = double(I);
T = dctmtx(8); % dct matrix

%perform dct on block of 8 by 8
dct = @(block_struct) T * block_struct.data * T';
B = blockproc(I,[8 8],dct);

% quantization matrix
q_mtx = [16 11 10 16 24 40 51 61; 12 12 14 19 26 58 60 55; 14 13 16 24 40 57 69 56; 14 17 22 29 51 87 80 62; 18 22 37 56 68 109 103 77; 24 35 55 64 81 104 113 92; 49 64 78 87 103 121 120 101; 72 92 95 98 112 100 103 99];

%performing quantization
c = @(block_struct)(block_struct.data) ./ q_mtx;
B2 = blockproc(B,[8 8],c);
B2 = round(B2);

imagesc(I); colormap gray; figure, imagesc(B2), colormap gray;