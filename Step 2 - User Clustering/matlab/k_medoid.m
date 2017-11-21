%---------------------------------------------------------------
userNum = size(distance, 1);
K = 1000;
max_iterations = 20;
% centroids : [center1, center2, ... centerK] 
random_index = randperm(userNum);
centroids = sort(random_index(1 : K));
init = centroids;
clear random_index
for time = 1 : max_iterations
    % get Closest Centroids
    user_centroids_dist = distance(:, centroids);
    [~, indices] = min(user_centroids_dist, [], 2);
    indices = centroids(indices)';
    indices(centroids) = centroids;
    % compute Centroids
    centroids_update = zeros(1, K);
    for i = 1 : K
        cluster_list = indices==centroids(i);
        cluster = distance(cluster_list, cluster_list);
        cluster_list_ = find(cluster_list);
        [~, new_center] = min(sum(cluster, 2), [], 1);
        centroids_update(i) = int32(cluster_list_(new_center));
    end
    centroids_update = sort(centroids_update);
    if centroids_update == centroids
        disp(['Stop iteration:', num2str(time)])
        break
    else
        centroids = centroids_update;
    end
end
cluster_cell = cell(1, K);
for i = 1 : K
    cluster = find(indices==centroids(i));
    cluster_cell{i} = cluster;
end
