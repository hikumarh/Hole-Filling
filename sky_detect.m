function sky_mask = sky_detect(I)

%I = rgb2gray(I1);

H  = fspecial('gaussian', 21, 1);
I2 = imfilter(double(I), H);

I = (I2 - I);
[h, w, c] = size(I);
Nerr = 100*ones(h, w);

%S = [0 -1 0; -1 4 -1; 0 -1 0];
%Is = conv2(I, S, 'same');


win = 5;

%E = ones(10,10);
%Nerr1 = conv2(Is, E, 'same');
for i=1:h
    for j=1:w
        
%         if (~((I1(i,j,3)> (210/255))&&(I1(i,j,3) > I1(i,j,2)) && (I1(i,j,2) > I1(i,j,1)) && (I1(i,j,3)< (180/255))))
%             continue;
%         end;
        
        x1 = max(1, i-win);
        x2 = min(h, i+win);
        y1 = max(1, j-win);
        y2 = min(w, j+win);
        
        window = I(x1:x2, y1:y2);
        num = sum(sum(window == I(i,j)));
        window = window(:);
        Nerr(i,j) = mean((window-mean(window)).^2)/(10^num);
    end;
end;



%Nmin = min(Nerr(:));
%thres = Nmin + 0.1; 

sky_mask = Nerr;







