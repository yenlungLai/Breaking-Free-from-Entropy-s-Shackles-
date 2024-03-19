

n=1000;
k=100;   %key length
% generator matrix size will be n*k;
t=50;


%key is column vector
key=generate_random_binary_vector_wt_t(1, k)';% the key is of weight 1 in our consideration

%input is row vector
x=randn(1,512);
x2=randn(1,512);


% Encoding and decoding
[y,F]=encoding(key,x,n,k);
[key_rec]=decoding(x,n,k,t,F,y);

%verify recovered key
isequal(key_rec,key)










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

function [key_rec]=decoding(x,n,k,t,F,y)
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
key_rec=zeros(1,k)';
key_rec(index)=1;









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
















