clear;%清除变量
%设置参数
trainfile = '/home/xuyue/record/temprecord/training_items_index.txt';
vecinputfile = '/home/xuyue/record/temprecord/vec_1st_16.txt';
usernum = 59176;% 用户数
itemnum = 14427;% 商品数
dimension = 17;% 矩阵维度
K = 30;% 前K项item
outputfile = '/home/xuyue/record/temprecord/score_1st_16.txt';
trainscore = '/home/xuyue/record/temprecord/trainscore_1st_16.txt';

UserItemSimilarityTopK( trainfile, vecinputfile, usernum, itemnum, dimension, K, outputfile, trainscore );


clear;%清除变量
%设置参数
trainfile = '/home/xuyue/record/temprecord/training_items_index.txt';
vecinputfile = '/home/xuyue/record/temprecord/vec_1st_32.txt';
usernum = 59176;%用户数
itemnum = 14427;%商品数
dimension = 33;%矩阵维度
K = 30;%前K项item
outputfile = '/home/xuyue/record/temprecord/score_1st_32.txt';
trainscore = '/home/xuyue/record/temprecord/trainscore_1st_32.txt';

UserItemSimilarityTopK( trainfile, vecinputfile, usernum, itemnum, dimension, K, outputfile, trainscore );


clear;%清除变量
%设置参数
trainfile = '/home/xuyue/record/temprecord/training_items_index.txt';
vecinputfile = '/home/xuyue/record/temprecord/vec_1st_64.txt';
usernum = 59176;%用户数
itemnum = 14427;%商品数
dimension = 65;%矩阵维度
K = 30;%前K项item
outputfile = '/home/xuyue/record/temprecord/score_1st_64.txt';
trainscore = '/home/xuyue/record/temprecord/trainscore_1st_64.txt';

UserItemSimilarityTopK( trainfile, vecinputfile, usernum, itemnum, dimension, K, outputfile, trainscore );


clear;%清除变量
%设置参数
trainfile = '/home/xuyue/record/temprecord/training_items_index.txt';
vecinputfile = '/home/xuyue/record/temprecord/vec_1st_128.txt';
usernum = 59176;%用户数
itemnum = 14427;%商品数
dimension = 129;%矩阵维度
K = 30;%前K项item
outputfile = '/home/xuyue/record/temprecord/score_1st_128.txt';
trainscore = '/home/xuyue/record/temprecord/trainscore_1st_128.txt';

UserItemSimilarityTopK( trainfile, vecinputfile, usernum, itemnum, dimension, K, outputfile, trainscore );


clear;%清除变量
%设置参数
trainfile = '/home/xuyue/record/temprecord/training_items_index.txt';
vecinputfile = '/home/xuyue/record/temprecord/vec_1st_256.txt';
usernum = 59176;%用户数
itemnum = 14427;%商品数
dimension = 257;%矩阵维度
K = 30;%前K项item
outputfile = '/home/xuyue/record/temprecord/score_1st_256.txt';
trainscore = '/home/xuyue/record/temprecord/trainscore_1st_256.txt';

UserItemSimilarityTopK( trainfile, vecinputfile, usernum, itemnum, dimension, K, outputfile, trainscore );


clear;%清除变量
%设置参数
trainfile = '/home/xuyue/record/temprecord/training_items_index.txt';
vecinputfile = '/home/xuyue/record/temprecord/vec_1st_512.txt';
usernum = 59176;%用户数
itemnum = 14427;%商品数
dimension = 513;%矩阵维度
K = 30;%前K项item
outputfile = '/home/xuyue/record/temprecord/score_1st_512.txt';
trainscore = '/home/xuyue/record/temprecord/trainscore_1st_512.txt';

UserItemSimilarityTopK( trainfile, vecinputfile, usernum, itemnum, dimension, K, outputfile, trainscore );


clear;%清除变量
%设置参数
trainfile = '/home/xuyue/record/temprecord/training_items_index.txt';
vecinputfile = '/home/xuyue/record/temprecord/vec_1st_1024.txt';
usernum = 59176;%用户数
itemnum = 14427;%商品数
dimension = 1025;%矩阵维度
K = 30;%前K项item
outputfile = '/home/xuyue/record/temprecord/score_1st_1024.txt';
trainscore = '/home/xuyue/record/temprecord/trainscore_1st_1024.txt';

UserItemSimilarityTopK( trainfile, vecinputfile, usernum, itemnum, dimension, K, outputfile, trainscore );
