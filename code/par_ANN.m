function [perfs]= par_ANN()

perfs=zeros(1,55);

parfor i=1:55
    d = i/5;
    feature = floor(d + 1);
    if(rem(i,5)==0)
        feature = feature - 1;
    end
    bin = rem(i,5);
    if bin == 0
        bin = 5;
    end
    feature
    bin
    % calculate the errors for each fold of each feature
    perfs(i) = train_me_ANN(feature,bin)
end

    % calculate averages of the errors
    ave_perfs = mean(reshape(perfs, 5, []));
    save('/home/iagalliadis/ma_ioannis_agalliadis/thesis/figures/HL1_NN5_accuracy/step64/perfs_step64.mat','perfs');
    save('/home/iagalliadis/ma_ioannis_agalliadis/thesis/figures/HL1_NN5_accuracy/step64/ave_perfs_step64.mat','ave_perfs');
end