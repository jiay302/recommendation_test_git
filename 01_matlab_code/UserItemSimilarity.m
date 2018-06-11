function [ simmatrix, topK, itemK ] = UserItemSimilarity( vecinputfile, usernum, itemnum, dimension, K, outputfile )
%% UserItemSimilarity：根据网络表示学习模型训练得到的节点的向量文件，计算user节点和item节点间的相似度，输出每个用户的最相似的前K项Item，没有剔除每个用户观看过的items
% 参数说明：
%     输入参数：
%          inputfile:节点向量文件路径，节点向量文件的第一列是节点的ID，后面有对应维度的列数，对应每个节点向量的分量
%          usercount:用户数目
%          itemcount:项目数目
%          dimension:节点向量的维度(这里输入参数时代表的是向量文件的列数，即dimension+1)
%          K:相似度最大的K项
%          outputfile:输出文件路径
%     输出参数：
%          simmatrix:相似度矩阵
%          topK:用户最相似的K的item的相似度结果
%          itemK:topK中每个元素对应的itemID

tic; % 程序计时开始

%% 测试数据
%vecinputfile = 'E:\record\temprecord\vec_1st_16.txt';
%usernum = 59176;% 用户数
%itemnum = 14427;% 商品数
%dimension = 17;% 矩阵维度
%K = 10;% 前K项item
%outputfile = 'E:\record\temprecord\score_1st_16.txt';

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

%% 余弦相似度计算
simmatrix(usernum, itemnum) = 0;% 存放所有user与所有item计算的相似度结果
for i=1:usernum % 遍历所有user，计算每个user与item的相似度
    user_current = repmat(userVec(i,:), itemnum, 1);% Vu(i, :)：当前用户节点的向量，将其复制itemnum次组成矩阵，直接与itemVec中的所有节点向量做点乘
    simcurrent = dot(user_current, itemVec, 2);% 两个矩阵每行做点积，由于NE模型已经对节点向量进行归一化了，所以点积结果即时余弦相似度
    simmatrix(i,:) = simcurrent;% 将计算结果存放
end

% 将相似度大矩阵的行向量按照降序排列(sortmatrix：排好序的相似度矩阵，index：排序矩阵中的元素在原始矩阵中的下标)
[sortmatrix, index] = sort(simmatrix, 2, 'descend');
topK = sortmatrix(:, 1:K);
itemK = index(:, 1:K);
clear sortmatrix;% 清除变量，减少内存消耗
clear index;% 清除变量，减少内存消耗

% 将前K项的结果写入文件
fp = fopen(outputfile,'w');%将计算出的得分和相应的userID itemID写入文件中
for i=1:usernum
    topitemID = itemID(:, itemK(i, :));
    for j=1:K
        fprintf(fp, '%d\t%d\t%f\n', userID(i), topitemID(j), topK(i,j));
    end
end
fclose(fp);
t = toc;% 程序计时结束
disp([num2str(dimension-1),'维度相似度计算时间为:',num2str(t), 's']);

end