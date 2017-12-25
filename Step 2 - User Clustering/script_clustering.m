%% load 
% UI_matrix_train 

%% Pre-calculate distance matrix
name = '20m';
distance = dist_overlap(UI_matrix_train);

%% eliminate users with zero ratings within training set
userNum = size(UI_matrix_train, 1);
zero_users = find(sum(UI_matrix_train, 2)==0);

%% generate cluster
clusters = k_medoid(distance, round(userNum/20));
for i = 1:length(clusters)
    for j = 1:length(clusters{i})
        if ismember(clusters{i}(j), zero_users)
        	clusters{i}(clusters{i}==clusters{i}(j))=0;
        end
    end
end
for i = 1:length(clusters)
    clusters{i}...
    (clusters{i}==0)=[];
end

%% Save to file
save('clusters.mat', 'clusters');