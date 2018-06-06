%% 此程序用于计算向量维度为32的节点间的相似度，并将相似度大于0的记录输出到指定文件
clear;%清除变量
%% 导入文本文件中的数据。
% 初始化变量。
filename = 'E:\record\temprecord\vec_1st_32.txt';
delimiter = ' ';

% 每个文本行的格式:
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

% 打开文本文件。
fileID = fopen(filename,'r');

% 根据格式读取数据列。
% 该调用基于生成此代码所用的文件的结构。如果其他文件出现错误，请尝试通过导入工具重新生成代码。
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);

% 关闭文本文件。
fclose(fileID);

% 创建输出变量
nodevec = [dataArray{1:end-1}];
% 清除临时变量
clearvars filename delimiter formatSpec fileID dataArray ans;

%% 计算相似度并将符合条件的数据输出
%% 01movielens-2k
%usernum = 393;%用户数
%itemnum = 3261;%商品数
%% 02lastfm
%usernum = 1829;%用户数
%itemnum = 13875;%商品数
%% 01movielens-2k1
%usernum = 1867;%用户数
%itemnum = 5775;%商品数
%itemnum = 5762;%商品数
%itemnum = 5774;%商品数
%% 03userbehavior
usernum = 107086;%用户数
itemnum = 14749;%商品数

dimension = 33;%矩阵维度
% 将得到的向量矩阵按照第一列的元素（即顶点ID）进行排列，从而获得Vu和Vi各自的矩阵
UserItemVec = sortrows(nodevec,1);
% 本次的userID最大为usernum（对应矩阵的前usernum行） itemID从usernum+1行开始
Vu = UserItemVec(1:usernum,:);
Vi = UserItemVec(usernum+1:usernum+itemnum,:);
outputfile = 'E:\record\temprecord\score_1st_32.txt';
fp = fopen(outputfile,'w');%将计算出的得分和相应的userID itemID写入文件中
for i=1:usernum
    userID = Vu(i,1);
    for j=1:itemnum
        itemID = Vi(j,1);
        score = dot(Vu(i,2:dimension),Vi(j,2:dimension));
        if score>0.2
            fprintf(fp, '%d\t%d\t%f\n', userID,itemID,score);
        end
    end
end
fclose(fp);

