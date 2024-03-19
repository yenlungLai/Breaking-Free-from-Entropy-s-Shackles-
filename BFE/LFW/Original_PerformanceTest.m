
load('index.mat');
load("lfwfeature.mat");


emb_idx1=1:2:12000;
emb_idx2=2:2:12000;

lfwfeature1=lfwfeature(emb_idx1,:);
lfwfeature2=lfwfeature(emb_idx2,:);


score=[];
for i=1:6000

    u=lfwfeature1(i,:);
    v=lfwfeature2(i,:);
    dis=acos(dot(u, v) / (norm(u) * norm(v))) / pi;
    score=[score;dis];

end


gen=score(find(index==1));
imp=score(find(index==0));





 %computeperformance(gen, imp, 0.001)% this code get EER, performance

run('Distribution_Encoded_Test.m');

















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






 
