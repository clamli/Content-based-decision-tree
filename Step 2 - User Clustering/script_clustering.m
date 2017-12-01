%% load 
% distance matrix
% UI_matrix 
UI_matrix = UI_matrix_train;
%% eliminate users with zero ratings within training set
zero_users = find(sum(UI_matrix, 2)==0);

% designate cluster number below
clusters = k_medoid(distance, 300);
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
save(['data/clusters.mat'], 'clusters');