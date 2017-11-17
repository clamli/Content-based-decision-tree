function [outputArg1,outputArg2] = k_means(data, k)
%K_MEANS Summary of this function goes here
%   Detailed explanation goes here
sample_num = size(data, 1)
center_index = random.sample(range(sample_num),k)
cluster_cen = data[center_index,:]

is_change=1  
cat=np.zeros(sample_num)    

while is_change: 
    print("is_change")
    is_change=0    
    for i in range(sample_num):  
        if i % 50 == 0:
            print("sample_num: " + str(i))
        min_distance=100000  
        min_index=0  

        for j in range(k):  
            if j % 50 == 0:
                print("find: " + str(j))
            distance = dist(data[i,:], cluster_cen[j,:])
            if distance < min_distance:  
                min_distance = distance  
                min_index = j + 1  

        if cat[i] != min_index:  
            is_change = 1  
            cat[i] = min_index  
    for j in range(k):  
        cluster_cen[j] = np.mean(data[cat == (j + 1)],axis = 0)  

return cat,cluster_cen 
end

