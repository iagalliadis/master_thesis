function [perfs] = train_ANN_pair()

perfs=zeros(10,11,5);
feature_combs = combnk(1:11,2);%create all the possible combinations between 1 and 11 (55 in total)

for i = 1:10
    %feature = feature_combs(feat_comb,:);% take each pair
    for j = i+1:11
        for bin = 1:5
            % calculate the errors for each fold of each feature
            perfs(i,j,bin) = train_me_feature_pairs(i,j,bin);
        end
    end
end
% calculate averages of the errors
ave_perfs = mean(reshape(permute(nonzeros(perfs), [1,3,2]), [], 5)');
final_ave_perfs = vertcat(ave_perfs,feature_combs');
save('/home/iagalliadis/ma_ioannis_agalliadis/thesis/figures/HL1_NN5_accuracy/step64/all_feature_comb/perfs_step64.mat','perfs');
save('/home/iagalliadis/ma_ioannis_agalliadis/thesis/figures/HL1_NN5_accuracy/step64/all_feature_comb/ave_perfs_step64.mat','final_ave_perfs');
end