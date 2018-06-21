function UserItemSimilarityCF( vecinputfile, usernum, itemnum, dimension, K, user_sim_file, item_sim_file )
%% UserItemSimilarityCF：根据网络表示学习模型训练得到的节点的向量文件，计算user-user节点之间的相似度、item-item节点之间的相似度，将每个user-user节点、item-item节点的topK输出
% 参数说明：
%     输入参数：
%          vecinputfile:节点向量文件路径，节点向量文件的第一列是节点的ID，后面有对应维度的列数，对应每个节点向量的分量
%          usercount:用户数目
%          itemcount:项目数目
%          dimension:节点向量的维度(这里输入参数时代表的是向量文件的列数，即dimension+1)
%          K:相似度最大的K项
%          user_sim_file:user-user节点的topK结果
%          item_sim_file:item-item节点的topK结果

%% 导入文件中的数据( 2nd-LINE 训练出来的节点向量)
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

%% user余弦相似度计算及topK项结果计算
tic; % 计时开始
simmatrix = userVec * userVec';
simmatrix(logical(eye([usernum, usernum]))) = -2;% 将对角线上的元素排除

% 将相似度大矩阵的行向量按照降序排列(sortmatrix：排好序的相似度矩阵，index：排序矩阵中的元素在原始矩阵中的下标)
[sortmatrix, index] = sort(simmatrix, 2, 'descend');
topK = sortmatrix(:, 1:K);
indexK = index(:, 1:K);
clear simmatrix;% 清除变量，减少内存消耗
clear sortmatrix;% 清除变量，减少内存消耗
clear index;% 清除变量，减少内存消耗

% 将前K项的结果写入文件
fp = fopen(user_sim_file,'w');%将计算出的得分和相应的userID userID写入文件中
for i=1:usernum
    topID = userID(:, indexK(i, :));
    for j=1:K
        fprintf(fp, '%d\t%d\t%f\n', userID(i), topID(j), topK(i,j));
    end
end
fclose(fp);
t = toc;% 计时结束
disp([num2str(dimension-1),'维度user相似度计算时间为:',num2str(t), 's']);

%% item余弦相似度计算
tic; % 计时开始
simmatrix = itemVec * itemVec';
simmatrix(logical(eye([itemnum, itemnum]))) = -2;% 将对角线上的元素排除

% 将相似度大矩阵的行向量按照降序排列(sortmatrix：排好序的相似度矩阵，index：排序矩阵中的元素在原始矩阵中的下标)
[sortmatrix, index] = sort(simmatrix, 2, 'descend');
topK = sortmatrix(:, 1:K);
indexK = index(:, 1:K);
clear simmatrix;% 清除变量，减少内存消耗
clear sortmatrix;% 清除变量，减少内存消耗
clear index;% 清除变量，减少内存消耗

% 将前K项的结果写入文件
fp = fopen(item_sim_file,'w');%将计算出的得分和相应的itemID itemID写入文件中
for i=1:itemnum
    topID = itemID(:, indexK(i, :));
    for j=1:K
        fprintf(fp, '%d\t%d\t%f\n', itemID(i), topID(j), topK(i,j));
    end
end
fclose(fp);
t = toc;% 计时结束
disp([num2str(dimension-1),'维度item相似度计算时间为:',num2str(t), 's']);
end