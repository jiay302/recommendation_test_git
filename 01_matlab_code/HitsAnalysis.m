%% 此脚本文件主要用于分析推荐中了的项目与用户观看过的节目的关联关系
% 设置一下编码
slCharacterEncoding('UTF-8')

%% 相关数据文件
hitsfile = 'E:\record\temprecord\items_hits.txt';% 每个用户推荐中了的item集合
topnfile = 'E:\record\temprecord\items_top3.txt';% 给每个用户推荐的top3 item集合
trainfile = 'E:\record\temprecord\items_trains.txt';% 每个用户训练集中的item集合
outputfile = 'E:\record\temprecord\hits_trains.txt';% 比较结果输出文件

%% 读入数据
fp = fopen(hitsfile);
hits = textscan(fp, '%d%s','delimiter', '\t');
fclose(fp);
hits_items = [hits{2}];% 得到每个用户的推荐集中的item集合字符串矩阵

fp = fopen(topnfile);
topn = textscan(fp, '%d%s','delimiter', '\t');
fclose(fp);
topn_items = [topn{2}];% 得到每个用户的topn推荐集的item集合字符串矩阵

fp = fopen(trainfile);
trains = textscan(fp, '%d%s','delimiter', '\t');
fclose(fp);
trains_items = [trains{2}];% 得到每个用户的训练集中的item集合字符串矩阵

userID = hits{1};% 用户的ID

%% 将对比结果写入输出文件
fp = fopen(outputfile,'w');
usernum = length(userID);
for i=1:usernum
    trains_str = strrep(trains_items{i},',',' | ');
    topn_str = strrep(topn_items{i},',',' | ');
    hits_str = strrep(hits_items{i},',',' | ');
    fprintf(fp, '用户ID：%d\n', userID(i));
    fprintf(fp, '观看过的节目：%s\n', trains_str);
    fprintf(fp, 'top 3 推荐集：%s\n', topn_str);
    fprintf(fp, '推荐中的节目：%s\n\n', hits_str);
end
fclose(fp);

