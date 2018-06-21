-- 将一阶相似度的训练集相似度作为用户对其观看过的节目的偏好，增加itemID索引，不然查询速度太慢
DROP TABLE IF EXISTS `user_pref_16`;
CREATE TABLE `user_pref_16` (
  `userID` int(2) DEFAULT NULL,
  `itemID` int(2) DEFAULT NULL,
  `score` double(7,6) DEFAULT NULL,
  KEY `index_item` (`itemID`)
);
LOAD DATA LOCAL INFILE 'E:\\record\\temprecord\\trainscore_1st_16.txt'-- 数据位置
INTO TABLE user_pref_16-- 要导入的表
FIELDS TERMINATED BY '\t'-- 数据以什么分隔
LINES TERMINATED BY '\n'-- 行间用什么分隔
(userID,itemID,score);-- 表中的字段

LOAD DATA LOCAL INFILE 'E:\\record\\temprecord\\trainscore_1st_32.txt'-- 数据位置
INTO TABLE user_pref_32-- 要导入的表
FIELDS TERMINATED BY '\t'-- 数据以什么分隔
LINES TERMINATED BY '\n'-- 行间用什么分隔
(userID,itemID,score);-- 表中的字段

LOAD DATA LOCAL INFILE 'E:\\record\\temprecord\\trainscore_1st_64.txt'-- 数据位置
INTO TABLE user_pref_64-- 要导入的表
FIELDS TERMINATED BY '\t'-- 数据以什么分隔
LINES TERMINATED BY '\n'-- 行间用什么分隔
(userID,itemID,score);-- 表中的字段

LOAD DATA LOCAL INFILE 'E:\\record\\temprecord\\trainscore_1st_128.txt'-- 数据位置
INTO TABLE user_pref_128-- 要导入的表
FIELDS TERMINATED BY '\t'-- 数据以什么分隔
LINES TERMINATED BY '\n'-- 行间用什么分隔
(userID,itemID,score);-- 表中的字段

LOAD DATA LOCAL INFILE 'E:\\record\\temprecord\\trainscore_1st_256.txt'-- 数据位置
INTO TABLE user_pref_256-- 要导入的表
FIELDS TERMINATED BY '\t'-- 数据以什么分隔
LINES TERMINATED BY '\n'-- 行间用什么分隔
(userID,itemID,score);-- 表中的字段

LOAD DATA LOCAL INFILE 'E:\\record\\temprecord\\trainscore_1st_512.txt'-- 数据位置
INTO TABLE user_pref_512-- 要导入的表
FIELDS TERMINATED BY '\t'-- 数据以什么分隔
LINES TERMINATED BY '\n'-- 行间用什么分隔
(userID,itemID,score);-- 表中的字段

LOAD DATA LOCAL INFILE 'E:\\record\\temprecord\\trainscore_1st_1024.txt'-- 数据位置
INTO TABLE user_pref_1024-- 要导入的表
FIELDS TERMINATED BY '\t'-- 数据以什么分隔
LINES TERMINATED BY '\n'-- 行间用什么分隔
(userID,itemID,score);-- 表中的字段


-- 将matlab计算的每个item的topK个相似结果导入数据表
DROP TABLE IF EXISTS `item_item_16`;
CREATE TABLE `item_item_16` (
  `itemID` int(2) DEFAULT NULL,
  `simItemID` int(2) DEFAULT NULL,
  `score` double(7,6) DEFAULT NULL,
  KEY `index_item` (`itemID`)
);
LOAD DATA LOCAL INFILE 'E:\\record\\temprecord\\itemsim_2nd_16.txt'-- 数据位置
INTO TABLE item_item_16-- 要导入的表
FIELDS TERMINATED BY '\t'-- 数据以什么分隔
LINES TERMINATED BY '\n'-- 行间用什么分隔
(itemID,simItemID,score);-- 表中的字段

LOAD DATA LOCAL INFILE 'E:\\record\\temprecord\\itemsim_2nd_32.txt'-- 数据位置
INTO TABLE item_item_32-- 要导入的表
FIELDS TERMINATED BY '\t'-- 数据以什么分隔
LINES TERMINATED BY '\n'-- 行间用什么分隔
(itemID,simItemID,score);-- 表中的字段

LOAD DATA LOCAL INFILE 'E:\\record\\temprecord\\itemsim_2nd_64.txt'-- 数据位置
INTO TABLE item_item_64-- 要导入的表
FIELDS TERMINATED BY '\t'-- 数据以什么分隔
LINES TERMINATED BY '\n'-- 行间用什么分隔
(itemID,simItemID,score);-- 表中的字段

LOAD DATA LOCAL INFILE 'E:\\record\\temprecord\\itemsim_2nd_128.txt'-- 数据位置
INTO TABLE item_item_128-- 要导入的表
FIELDS TERMINATED BY '\t'-- 数据以什么分隔
LINES TERMINATED BY '\n'-- 行间用什么分隔
(itemID,simItemID,score);-- 表中的字段

LOAD DATA LOCAL INFILE 'E:\\record\\temprecord\\itemsim_2nd_256.txt'-- 数据位置
INTO TABLE item_item_256-- 要导入的表
FIELDS TERMINATED BY '\t'-- 数据以什么分隔
LINES TERMINATED BY '\n'-- 行间用什么分隔
(itemID,simItemID,score);-- 表中的字段

LOAD DATA LOCAL INFILE 'E:\\record\\temprecord\\itemsim_2nd_512.txt'-- 数据位置
INTO TABLE item_item_512-- 要导入的表
FIELDS TERMINATED BY '\t'-- 数据以什么分隔
LINES TERMINATED BY '\n'-- 行间用什么分隔
(itemID,simItemID,score);-- 表中的字段

LOAD DATA LOCAL INFILE 'E:\\record\\temprecord\\itemsim_2nd_1024.txt'-- 数据位置
INTO TABLE item_item_1024-- 要导入的表
FIELDS TERMINATED BY '\t'-- 数据以什么分隔
LINES TERMINATED BY '\n'-- 行间用什么分隔
(itemID,simItemID,score);-- 表中的字段

-- 根据用户看过的item以及这些item的topK相似item构建推荐集
DROP TABLE IF EXISTS `itemcf_16`;
CREATE TABLE `itemcf_16` (
  `userID` int(2) DEFAULT NULL,
  `itemID` int(2) DEFAULT NULL,
  `weight` double(7,6) DEFAULT NULL,
  `simItemID` int(2) DEFAULT NULL,
  `score` double(7,6) DEFAULT NULL
);
INSERT INTO itemcf_16 SELECT A.userID,A.itemID,A.score,B.simItemID,B.score FROM user_pref_16 A,item_item_16 B WHERE A.itemID=B.itemID ORDER BY userID,itemID;
INSERT INTO itemcf_32 SELECT A.userID,A.itemID,A.score,B.simItemID,B.score FROM user_pref_32 A,item_item_32 B WHERE A.itemID=B.itemID ORDER BY userID,itemID;
INSERT INTO itemcf_64 SELECT A.userID,A.itemID,A.score,B.simItemID,B.score FROM user_pref_64 A,item_item_64 B WHERE A.itemID=B.itemID ORDER BY userID,itemID;
INSERT INTO itemcf_128 SELECT A.userID,A.itemID,A.score,B.simItemID,B.score FROM user_pref_128 A,item_item_128 B WHERE A.itemID=B.itemID ORDER BY userID,itemID;
INSERT INTO itemcf_256 SELECT A.userID,A.itemID,A.score,B.simItemID,B.score FROM user_pref_256 A,item_item_256 B WHERE A.itemID=B.itemID ORDER BY userID,itemID;
INSERT INTO itemcf_512 SELECT A.userID,A.itemID,A.score,B.simItemID,B.score FROM user_pref_512 A,item_item_512 B WHERE A.itemID=B.itemID ORDER BY userID,itemID;
INSERT INTO itemcf_1024 SELECT A.userID,A.itemID,A.score,B.simItemID,B.score FROM user_pref_1024 A,item_item_1024 B WHERE A.itemID=B.itemID ORDER BY userID,itemID;



-- 保存itemCF的原始记录
CALL create_score_table_attri_v3('0','1024','item');

-- 实验一：不考虑用户对看过节目的偏好
INSERT INTO score_16_item SELECT userID,simItemID,score FROM itemcf_16;
INSERT INTO score_32_item SELECT userID,simItemID,score FROM itemcf_32;
INSERT INTO score_64_item SELECT userID,simItemID,score FROM itemcf_64;
INSERT INTO score_128_item SELECT userID,simItemID,score FROM itemcf_128;
INSERT INTO score_256_item SELECT userID,simItemID,score FROM itemcf_256;
INSERT INTO score_512_item SELECT userID,simItemID,score FROM itemcf_512;
INSERT INTO score_1024_item SELECT userID,simItemID,score FROM itemcf_1024;

-- 实验二：考虑用户对看过节目的偏好
INSERT INTO score_16_item SELECT userID,simItemID,weight*score FROM itemcf_16;
INSERT INTO score_32_item SELECT userID,simItemID,weight*score FROM itemcf_32;
INSERT INTO score_64_item SELECT userID,simItemID,weight*score FROM itemcf_64;
INSERT INTO score_128_item SELECT userID,simItemID,weight*score FROM itemcf_128;
INSERT INTO score_256_item SELECT userID,simItemID,weight*score FROM itemcf_256;
INSERT INTO score_512_item SELECT userID,simItemID,weight*score FROM itemcf_512;
INSERT INTO score_1024_item SELECT userID,simItemID,weight*score FROM itemcf_1024;


-- 去重：重复记录取score最大的记录
-- 保存itemCF去重后的结果记录
CALL create_score_table_attri_v3('1','1024','0');
INSERT INTO score_16_0 SELECT CONCAT(userID,'_',itemID),userID,itemID,MAX(score) FROM score_16_item GROUP BY userID,itemID;
INSERT INTO score_32_0 SELECT CONCAT(userID,'_',itemID),userID,itemID,MAX(score) FROM score_32_item GROUP BY userID,itemID;
INSERT INTO score_64_0 SELECT CONCAT(userID,'_',itemID),userID,itemID,MAX(score) FROM score_64_item GROUP BY userID,itemID;
INSERT INTO score_128_0 SELECT CONCAT(userID,'_',itemID),userID,itemID,MAX(score) FROM score_128_item GROUP BY userID,itemID;
INSERT INTO score_256_0 SELECT CONCAT(userID,'_',itemID),userID,itemID,MAX(score) FROM score_256_item GROUP BY userID,itemID;
INSERT INTO score_512_0 SELECT CONCAT(userID,'_',itemID),userID,itemID,MAX(score) FROM score_512_item GROUP BY userID,itemID;
INSERT INTO score_1024_0 SELECT CONCAT(userID,'_',itemID),userID,itemID,MAX(score) FROM score_1024_item GROUP BY userID,itemID;

-- 删除与训练集相同的记录
DELETE score_16_0 FROM score_16_0,00training WHERE score_16_0.id=00training.id;
DELETE score_32_0 FROM score_32_0,00training WHERE score_32_0.id=00training.id;
DELETE score_64_0 FROM score_64_0,00training WHERE score_64_0.id=00training.id;
DELETE score_128_0 FROM score_128_0,00training WHERE score_128_0.id=00training.id;
DELETE score_256_0 FROM score_256_0,00training WHERE score_256_0.id=00training.id;
DELETE score_512_0 FROM score_512_0,00training WHERE score_512_0.id=00training.id;
DELETE score_1024_0 FROM score_1024_0,00training WHERE score_1024_0.id=00training.id;



-- 为了加快后面的推荐速度，先选出每个用户的前num项
-- 创建添加主键和userID, score聚合索引的表格保存前30项，topnum_attribute_dimension
-- create_topk_table_attri('max_dimension','num','attribute')
CALL create_topk_table_attri('1024','30','0');

-- 获取前num项
-- get_score_limit_num('max_userid','dimension','attribute','num')
CALL get_score_limit_num_v3('59176','16','0','30');
CALL get_score_limit_num_v3('59176','32','0','30');
CALL get_score_limit_num_v3('59176','64','0','30');
CALL get_score_limit_num_v3('59176','128','0','30');
CALL get_score_limit_num_v3('59176','256','0','30');
CALL get_score_limit_num_v3('59176','512','0','30');
CALL get_score_limit_num_v3('59176','1024','0','30');

-- 开始做topn推荐
-- 创建保存top1-top20的表格：topi_attribute_dimension
-- create_topn_table_attribute('dimension','i','attribute')
CALL create_topn_table_attribute('16','20','0');
CALL create_topn_table_attribute('32','20','0');
CALL create_topn_table_attribute('64','20','0');
CALL create_topn_table_attribute('128','20','0');
CALL create_topn_table_attribute('256','20','0');
CALL create_topn_table_attribute('512','20','0');
CALL create_topn_table_attribute('1024','20','0');

-- 选择前N项
-- get_topn_attribute('k','dimension','num','attribute')
CALL get_topn_attribute('30','16','20','0');
CALL get_topn_attribute('30','32','20','0');
CALL get_topn_attribute('30','64','20','0');
CALL get_topn_attribute('30','128','20','0');
CALL get_topn_attribute('30','256','20','0');
CALL get_topn_attribute('30','512','20','0');
CALL get_topn_attribute('30','1024','20','0');


-- 统计实验结果
-- 创建保存实验结果的表格topn_result_dimension
-- create_result_table_dimension(max_dimension)
CALL create_result_table_dimension('1024');

-- 16维度
-- 统计推荐集的数量
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top01_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top02_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top03_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top04_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top05_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top06_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top07_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top08_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top09_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top10_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top11_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top12_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top13_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top14_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top15_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top16_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top17_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top18_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top19_0_16;
INSERT INTO topn_result_16(totalNum) SELECT COUNT(*) FROM top20_0_16;

-- 统计结果正确数量
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top01_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=1;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top02_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=2;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top03_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=3;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top04_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=4;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top05_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=5;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top06_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=6;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top07_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=7;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top08_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=8;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top09_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=9;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top10_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=10;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top11_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=11;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top12_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=12;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top13_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=13;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top14_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=14;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top15_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=15;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top16_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=16;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top17_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=17;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top18_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=18;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top19_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=19;
UPDATE topn_result_16 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top20_0_16 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=20;


-- 32维度
-- 统计推荐集的数量
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top01_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top02_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top03_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top04_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top05_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top06_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top07_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top08_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top09_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top10_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top11_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top12_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top13_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top14_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top15_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top16_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top17_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top18_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top19_0_32;
INSERT INTO topn_result_32(totalNum) SELECT COUNT(*) FROM top20_0_32;

-- 统计结果正确数量
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top01_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=1;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top02_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=2;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top03_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=3;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top04_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=4;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top05_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=5;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top06_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=6;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top07_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=7;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top08_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=8;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top09_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=9;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top10_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=10;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top11_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=11;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top12_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=12;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top13_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=13;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top14_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=14;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top15_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=15;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top16_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=16;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top17_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=17;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top18_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=18;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top19_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=19;
UPDATE topn_result_32 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top20_0_32 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=20;


-- 64维度
-- 统计推荐集的数量
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top01_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top02_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top03_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top04_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top05_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top06_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top07_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top08_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top09_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top10_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top11_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top12_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top13_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top14_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top15_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top16_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top17_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top18_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top19_0_64;
INSERT INTO topn_result_64(totalNum) SELECT COUNT(*) FROM top20_0_64;

-- 统计结果正确数量
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top01_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=1;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top02_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=2;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top03_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=3;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top04_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=4;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top05_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=5;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top06_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=6;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top07_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=7;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top08_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=8;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top09_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=9;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top10_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=10;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top11_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=11;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top12_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=12;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top13_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=13;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top14_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=14;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top15_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=15;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top16_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=16;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top17_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=17;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top18_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=18;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top19_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=19;
UPDATE topn_result_64 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top20_0_64 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=20;

-- 128维度
-- 统计推荐集的数量
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top01_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top02_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top03_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top04_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top05_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top06_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top07_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top08_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top09_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top10_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top11_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top12_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top13_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top14_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top15_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top16_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top17_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top18_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top19_0_128;
INSERT INTO topn_result_128(totalNum) SELECT COUNT(*) FROM top20_0_128;

-- 统计结果正确数量
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top01_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=1;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top02_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=2;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top03_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=3;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top04_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=4;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top05_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=5;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top06_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=6;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top07_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=7;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top08_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=8;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top09_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=9;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top10_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=10;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top11_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=11;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top12_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=12;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top13_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=13;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top14_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=14;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top15_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=15;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top16_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=16;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top17_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=17;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top18_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=18;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top19_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=19;
UPDATE topn_result_128 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top20_0_128 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=20;


-- 256维度
-- 统计推荐集的数量
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top01_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top02_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top03_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top04_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top05_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top06_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top07_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top08_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top09_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top10_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top11_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top12_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top13_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top14_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top15_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top16_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top17_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top18_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top19_0_256;
INSERT INTO topn_result_256(totalNum) SELECT COUNT(*) FROM top20_0_256;

-- 统计结果正确数量
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top01_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=1;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top02_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=2;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top03_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=3;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top04_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=4;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top05_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=5;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top06_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=6;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top07_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=7;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top08_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=8;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top09_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=9;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top10_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=10;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top11_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=11;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top12_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=12;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top13_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=13;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top14_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=14;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top15_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=15;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top16_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=16;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top17_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=17;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top18_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=18;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top19_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=19;
UPDATE topn_result_256 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top20_0_256 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=20;


-- 512维度
-- 统计推荐集的数量
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top01_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top02_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top03_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top04_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top05_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top06_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top07_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top08_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top09_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top10_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top11_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top12_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top13_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top14_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top15_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top16_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top17_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top18_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top19_0_512;
INSERT INTO topn_result_512(totalNum) SELECT COUNT(*) FROM top20_0_512;

-- 统计结果正确数量
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top01_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=1;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top02_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=2;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top03_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=3;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top04_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=4;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top05_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=5;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top06_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=6;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top07_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=7;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top08_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=8;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top09_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=9;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top10_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=10;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top11_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=11;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top12_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=12;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top13_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=13;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top14_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=14;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top15_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=15;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top16_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=16;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top17_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=17;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top18_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=18;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top19_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=19;
UPDATE topn_result_512 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top20_0_512 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=20;


-- 1024维度
-- 统计推荐集的数量
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top01_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top02_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top03_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top04_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top05_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top06_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top07_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top08_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top09_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top10_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top11_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top12_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top13_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top14_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top15_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top16_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top17_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top18_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top19_0_1024;
INSERT INTO topn_result_1024(totalNum) SELECT COUNT(*) FROM top20_0_1024;

-- 统计结果正确数量
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top01_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=1;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top02_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=2;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top03_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=3;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top04_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=4;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top05_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=5;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top06_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=6;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top07_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=7;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top08_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=8;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top09_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=9;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top10_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=10;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top11_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=11;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top12_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=12;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top13_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=13;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top14_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=14;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top15_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=15;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top16_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=16;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top17_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=17;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top18_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=18;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top19_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=19;
UPDATE topn_result_1024 SET correctNum=(SELECT COUNT(*) FROM (SELECT recommendation.* FROM top20_0_1024 recommendation, 00testing testing WHERE recommendation.id=testing.id) AS result_temp) WHERE topk=20;



