%% load 
% UI_matrix 
name = '1m';
UI_matrix = UI_matrix_train;

%% randomly generate clusters
[userNum, itemNum] = size(UI_matrix);
clusterSzie = 1;
K = round(userNum/clusterSzie);
clusters = cell(1, K);
random_index = single(randperm(userNum));
startPos = 1;
endPos = clusterSzie;
for i = 1 : K
    disp([num2str(i), 'th:'])
    disp(['startPos: ', num2str(startPos)])
    disp(['endPos: ', num2str(endPos)])
    cluster = random_index(startPos:endPos);
    clusters{i} = cluster;     
    startPos = endPos + 1;
    if i == K - 1        
        endPos = userNum;
    else
        endPos = endPos + clusterSzie;
    end
end
%% eliminate users with zero ratings within training set
zero_users = find(sum(UI_matrix, 2)==0);
% designate cluster number below
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
save(['../', name, ' tree/clusters_random.mat'], 'clusters');