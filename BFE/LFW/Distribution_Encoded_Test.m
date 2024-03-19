%% this experiment aims to compared the inter and intra class distance score distribution before and after applied the encoding in terms of their cosine distance for comparison


%increas n to see the asymtotic effect of the scheme
load('index.mat');
load("lfwfeature.mat");


n=50;
k=20;   %key length
% generator matrix size will be n*k;
t=500;  % in this experiment, we are intersted in the smallest codeword distance d(y,y'), so t less important





emb_idx1=1:2:12000;
emb_idx2=2:2:12000;

lfwfeature1=lfwfeature(emb_idx1,:);
lfwfeature2=lfwfeature(emb_idx2,:);


score=[];
for i=1:6000
    i
    u=lfwfeature1(i,:);
    v=lfwfeature2(i,:);

    %key is column vector
    key=generate_random_binary_vector_wt_t(1, k)';% the key is of weight 1 in our consideration

    % Encoding and decoding
    [y,F]=encoding(key,u,n,k);
    [key_rec,mindistance]=decoding(v,n,k,t,F,y); % here we also return the min dist between the codewords (y,y')

    normalized_dist=mindistance/n; % this implies smallest value of t/n used in recover the key 
     




    score=[score;normalized_dist];%one means succes key recovery, 0 mean fail

end


gen_scheme=score(find(index==1));
imp_scheme=score(find(index==0));




%get EER performance
% computeperformance(gen, imp, 0.001)


%compare distribution
plothis(gen,imp,'bit',1,gen_scheme,imp_scheme)

















function read_and_save_csv_first_column(filename)
% Read the file into a table
T = readtable(filename, 'ReadVariableNames', false);

% Extract the first column
T_without_first_column = T(:, 1);

% Convert the table to a numeric matrix
index = table2array(T_without_first_column);

% Save data in .mat format
[~, index, ~] = fileparts(index);
save([index, 'index.mat'], 'index');
end







function [mat]=generate_m(n)
mat=randn(n,512);

end

function [ww] = LSH(w,mat)

v=mat*w';
ww=sign(v);
ww(ww==-1)=0;
ww=ww';
end



function [frr, far] = getfarfrr(gen,imp,mine,maxe,dec)
gar=[];
for t=mine:dec:maxe



    gencal=gen(gen(:)<=t);
    if isempty(gencal)
        genrate=0;
    else
        genrate=length(gencal)/length(gen);
    end
    gar=[gar;genrate];


end
frr=1-gar;



far=[];

for t=mine:dec:maxe
    impcal=imp(imp(:)<=t);
    if isempty(impcal)
        imprate=0;
    else
        imprate=length(impcal)/length(imp);
    end

    far=[far;imprate];

end




end

































function [G,F]=generate_G(x,n,k)
ell=length(x);
F=randn(n*k,ell);
G_real=F*x';
G_real=sign(G_real);
G=(G_real+1)/2; % binarize to 0 and 1 for Greal to get G
G=reshape(G,n,k); % since each element in G is i.i.d, we simply reshape to n x k
end

function [y,F]=encoding(key,x,n,k)
[G,F]=generate_G(x,n,k);
y=G*key;
end

function [key_rec,mindistance]=decoding(x,n,k,t,F,y)
%below 4 line is just G generation
G_real=F*x';
G_real=sign(G_real);
G=(G_real+1)/2; % binarize to 0 and 1 for Greal to get G
G=reshape(G,n,k); % since each element in G is i.i.d, we simply reshape to n x k


%% Bruteforce deode start here: for efficiency, we only use weight wt=1

% wt=1; key_rec=[];
% while wt<=k
%     x_gues=zeros(1,k);
%     x_gues(wt)=1; %for simplicity each weight value represent the index of a zero vector to be 1
%     y_est=G*x_gues';
%     H_distance = sum(y ~= y_est);
%     if H_distance<=t % stopig criteria
%         wt=k;
%         key_rec=x_gues';
%         wt=wt+1;
%     else
%         wt=wt+1;
%     end
%
%     if wt>=k  && isempty(key_rec)
%         key_rec='no solution';
%         disp('no solution')
%     end
% end

% however above bruteforce method is slow implementation-wise. Since wt=1, we will direct deduct
% the matrix with the codeword y and choose the column in G as y'
% corresponding to smallest d(y,y')

%% Revised bruteforce deode: it simply output the position of y' corresponds to lowest distance with y
difG_y=sum(mod(G-y,2)); % this output all hamming distance between each column of G with y
[mindistance,index]=min(difG_y); % this return the minimum distance and its corresponding index, this index wil be the key
key_guess=zeros(1,k)';
key_guess(index)=1;


if mindistance<=t

    key_rec=key_guess;
else
    key_rec='no solution';
end








end




function random_binary_vector = generate_random_binary_vector_wt_t(wt, k)
% Check if t is greater than n
if wt > k
    error('t should be less than or equal to n.');
end

% Generate a random permutation of indices
permuted_indices = randperm(k);

% Set the first t indices to 1 and the rest to 0
random_binary_vector = zeros(1, k);
random_binary_vector(permuted_indices(1:wt)) = 1;
end
















