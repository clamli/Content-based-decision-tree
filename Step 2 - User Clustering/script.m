algorithm = 'overlap'
load(['data/', algorithm, '_1.mat'])
load('data/UI_matrix_1_train.mat')

%% eliminate users with zero ratings within training set
zero_users = find(sum(UI_matrix, 2)==0);

clusters = k_medoid(distance, 1);
for i = 1:length(clusters)
    for j = 1:length(clusters{i})
        if ismember(clusters{i}(j), zero_users)
        	clusters{i}...
                (clusters{i}==clusters{i}(j))...
                =[0];
        end
    end
end

for i = 1:length(clusters)
    clusters{i}...
    (clusters{i}==0)=[];
end

%% Save to file
save(['data/clusters_', algorithm, '.mat'], 'clusters');