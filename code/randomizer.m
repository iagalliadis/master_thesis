%% remove evaluation

%here evaluation set is created (evaluation set is 20% of the total number of recordings)
removeEval = false;
if removeEval
    total = 207;
    evaluationSize = 41;
    
    takeout = zeros(total);
    takeout(1:evaluationSize) = 1;
    permutation = randperm(total);
    target = takeout(permutation);
    for i=1:total
        if target(i)
            filename = ['flexion_' num2str(i) '.csv'];
            movefile(filename,'evaluation');
        end
    end
end

%% create randomization
% here the train and test sets are created (the data from train set are exclusive and not inclusive to test set and vice versa)
number = 166;
randArr = zeros(number);
randArr(1:floor(number/5)) = 1;
randArr(floor(number/5)+1:2*floor(number/5)) = 2;
randArr(2*floor(number/5)+1:3*floor(number/5)) = 3;
randArr(3*floor(number/5)+1:4*floor(number/5)) = 4;
randArr(4*floor(number/5)+1:end) = 5;

permutation = randperm(number);

target = randArr(permutation);
%% copy files to test
filenames = dir('.');
for i=numel(filenames):-1:1
    if isdir(filenames(i).name)
        filenames(i) = [];
    end
end

for i=1:number
    filename = filenames(i).name;
    if ~isdir(fullfile('test',num2str(target(i))))
        mkdir(fullfile('test',num2str(target(i))))
    end
    copyfile(filename,fullfile('test',num2str(target(i))))
end

%% copy files to train
for test=1:5
    if ~isdir(fullfile('train',num2str(target(i))))
        mkdir(fullfile('train',num2str(target(i))))
    end
    for train=1:5
        if train~=test
            copyfile(fullfile('test',num2str(train),'*.csv'),fullfile('train',num2str(test)))
        end
    end
end