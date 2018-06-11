%优化前的matlab代码
clear;% 清除变量
tic;% 程序计时开始
filename = '/home/xuyue/record/temprecord/vec_1st_16.txt';%初始化变量
usernum = 59176;% 用户数
itemnum = 14427;% 商品数
dimension = 17;% 矩阵维度
outputfile = '/home/xuyue/record/temprecord/score_1st_16.txt';

nodevec = load(filename);% 根据文件的路径获得所有节点的对应的向量[ nodeID vec_1 ... vec_dimension ]
UserItemVec = sortrows(nodevec,1);%将得到的向量矩阵按照第一列的元素（即顶点ID）进行排列，从而获得Vu和Vi各自的矩阵
Vu = UserItemVec(1:usernum,:);%本次的userID最大为usernum（对应矩阵的前usernum行）itemID从usernum+1行开始
Vi = UserItemVec(usernum+1:usernum+itemnum,:);

fp = fopen(outputfile,'w');%将计算出的得分和相应的userID itemID写入文件中
for i=1:usernum
    userID = Vu(i,1);
    for j=1:itemnum
        itemID = Vi(j,1);
        score = dot(Vu(i,2:dimension),Vi(j,2:dimension));
        if score>0.1
            fprintf(fp, '%d\t%d\t%f\n', userID,itemID,score);
        end
    end
end
fclose(fp);
t = toc;%程序计时结束
disp(['优化前16维度的节点相似度计算时间为：',num2str(t), 's']);

%优化后的matlab代码
clear;% 清除变量
tic;% 程序计时开始
trainfile = '/home/xuyue/record/temprecord/training_items_index.txt';
vecinputfile = '/home/xuyue/record/temprecord/vec_1st_16.txt';
usernum = 59176;% 用户数
itemnum = 14427;% 商品数
dimension = 17;% 矩阵维度
K = 50;% 前K项item
outputfile = '/home/xuyue/record/temprecord/score_1st_16.txt';
trainscore = '/home/xuyue/record/temprecord/trainscore_1st_16.txt';

%% 导入文件中的数据
% 导入向量数据，获得用户节点的向量矩阵、项目节点的向量矩阵
nodevec = load(vecinputfile);% 根据文件的路径获得所有节点的对应的向量[ nodeID vec_1 ... vec_dimension ]
% 将得到的向量矩阵按照第一列的元素（即顶点ID）进行排列，从而获得Vu和Vi各自的矩阵
UserItemVec = sortrows(nodevec,1);
clear nodevec;% 清除变量，减少内存消耗
% 本次的userID最大为usernum（对应矩阵的前usernum行） itemID从usernum+1行开始
userID =  UserItemVec(1:usernum, 1)';% user节点的编号
userVec = UserItemVec(1:usernum, 2:end);% user节点的向量
itemID =  UserItemVec(usernum+1:end, 1)';% item节点的编号
itemVec = UserItemVec(usernum+1:end, 2:end);% item节点的向量
clear UserItemVec;% 清除变量，减少内存消耗

% 导入训练集中的数据，第一列代表userID，第二列是用户正向评价的item在itemID中的下标集合，用','分隔
fp = fopen(trainfile);
train = textscan(fp, '%d%s','delimiter', '\t');
fclose(fp);
trainitems = [train{2}];% 得到每个用户的训练集中的item集合字符串矩阵
clear train;% 清除变量，减少内存消耗

%% 余弦相似度计算
simmatrix(usernum, itemnum) = 0;% 存放所有user与所有item计算的相似度结果
trainsimcell = cell(usernum, 1);% 存放user与其训练集中的item相似度计算结果
for i=1:usernum % 遍历所有user，计算每个user与item的相似度
    user_current = repmat(userVec(i,:), itemnum, 1);% Vu(i, :)：当前用户节点的向量，将其复制itemnum次组成矩阵，直接与itemVec中的所有节点向量做点乘
    simcurrent = dot(user_current, itemVec, 2)';% 两个矩阵每行做点积，由于NE模型已经对节点向量进行归一化了，所以点积结果即时余弦相似度
    everyitems = str2double(split(trainitems(i),',',2));% 将每个字符串转换成数字数组
    % 将训练集中包含的item的计算结果提取出来，再将simcurrent中的对应结果设置成-2，这样后续取前K项就可以自动将训练集中的item排除了
    trainsimcell{i,1} = simcurrent(:, everyitems);
    simcurrent(:, everyitems) = -2;
    simmatrix(i,:) = simcurrent;% 将计算结果存放
end

% 将相似度大矩阵的行向量按照降序排列(sortmatrix：排好序的相似度矩阵，index：排序矩阵中的元素在原始矩阵中的下标)
[sortmatrix, index] = sort(simmatrix, 2, 'descend');
topK = sortmatrix(:, 1:K);
itemK = index(:, 1:K);
clear sortmatrix;% 清除变量，减少内存消耗
clear index;% 清除变量，减少内存消耗

% 将前K项的结果写入文件
fp = fopen(outputfile,'w');% 将计算出的得分和相应的userID itemID写入文件中
for i=1:usernum
    topitemID = itemID(:, itemK(i, :));
    for j=1:K
        fprintf(fp, '%d\t%d\t%f\n', userID(i), topitemID(j), topK(i,j));
    end
end
fclose(fp);
t = toc;% 程序计时结束
disp(['优化后16维度的节点相似度计算时间为：',num2str(t), 's']);

% 将训练集中的得分结果写入文件
tic % 程序计时开始
fp = fopen(trainscore,'w');% 将计算出的得分和相应的userID itemID写入文件中
for i=1:usernum
    everyitems = str2double(split(trainitems(i),',',2));% 将每个字符串转换成数字数组
    topitemID = itemID(:, everyitems);
    J = length(everyitems);
    for j=1:J
        fprintf(fp, '%d\t%d\t%f\n', userID(i), topitemID(j), trainsimcell{i}(j));
    end
end
fclose(fp);
t = toc;% 程序计时结束
disp(['训练集相似度写入文件时间为:',num2str(t), 's']);
