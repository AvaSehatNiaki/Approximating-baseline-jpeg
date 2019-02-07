
function g = blockDCT(f, blockSize, q) 
T = dctmtx(blockSize); % dct matrix
%perform dct on block of 8 by 8
dct = @(block_struct) T  block_struct.data  T';
B = blockproc(f,[blockSize blockSize],dct);
%performing quantization
c = @(block_struct)(block_struct.data) ./ q;
B2 = blockproc(B,[blockSize blockSize],c);
B2 = round(B2);
imagesc(f); colormap gray; figure, imagesc(B2), colormap gray;
end


function h=blockIDCT(g, blockSize,q) 
T = dctmtx(blockSize); % dct matrix
%perform dct on block of 8 by 8
dct = @(block_struct) T  block_struct.data  T';
B = blockproc(g,[blockSize blockSize],dct);

%performing quantization
c = @(block_struct)(block_struct.data) ./ q;
B2 = blockproc(B,[blockSize blockSize],c);
B2 = round(B2);

%performing inverse quantization
B3 = blockproc(B2,[blockSize blockSize],@(block_struct) q .* block_struct.data);

%performing inverse DCT on block of 8 by 8
invdct = @(block_struct) round(T'  block_struct.data  T);
I2 = blockproc(B3,[blockSize blockSize],invdct);
imagesc(g); colormap gray; figure, imagesc(I2), colormap gray;
end

function blockEntropy(g, blockSize) 
ind = reshape(1:numel(g), size(g));         %# indices of elements
ind = fliplr( spdiags( fliplr(ind) ) );     %# get the anti-diagonals
ind(:,1:2:end) = flipud( ind(:,1:2:end) );  %# reverse order of odd columns
ind(ind==0) = []; 

z = g(ind)
x = z(:);
E_total(ind) = entropy(x);
E = mean(E_total)
end

function c=compressionRatio(f, q)
g = blockDCT(f, 8, q)
blockEntropy(g, 8) 
compression_ratio= (8/E)
end
