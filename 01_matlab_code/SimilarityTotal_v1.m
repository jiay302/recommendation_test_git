clear%清除变量
%设置参数
vecinputfile = '/home/xuyue/record/temprecord/vec_1st_16.txt';
usernum = 59176;%用户数
itemnum = 14427;%商品数
dimension = 17;%矩阵维度
K = 100;%前K项item
outputfile = '/home/xuyue/record/temprecord/score_1st_16.txt';

UserItemSimilarity( vecinputfile, usernum, itemnum, dimension, K, outputfile );


clear;%清除变量
%设置参数
vecinputfile = '/home/xuyue/record/temprecord/vec_1st_32.txt';
usernum = 59176;%用户数
itemnum = 14427;%商品数
dimension = 33;%矩阵维度
K = 100;%前K项item
outputfile = '/home/xuyue/record/temprecord/score_1st_32.txt';

UserItemSimilarity( vecinputfile, usernum, itemnum, dimension, K, outputfile );


clear;%清除变量
%设置参数
vecinputfile = '/home/xuyue/record/temprecord/vec_1st_64.txt';
usernum = 59176;%用户数
itemnum = 14427;%商品数
dimension = 65;%矩阵维度
K = 100;%前K项item
outputfile = '/home/xuyue/record/temprecord/score_1st_64.txt';

UserItemSimilarity( vecinputfile, usernum, itemnum, dimension, K, outputfile );


clear;%清除变量
%设置参数
vecinputfile = '/home/xuyue/record/temprecord/vec_1st_128.txt';
usernum = 59176;%用户数
itemnum = 14427;%商品数
dimension = 129;%矩阵维度
K = 100;%前K项item
outputfile = '/home/xuyue/record/temprecord/score_1st_128.txt';

UserItemSimilarity( vecinputfile, usernum, itemnum, dimension, K, outputfile );