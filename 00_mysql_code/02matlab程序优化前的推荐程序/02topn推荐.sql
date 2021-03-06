-- 1、导入测试集训练集

-- 用户数：59176
-- 节目数：15544
-- 打分记录数：736583

-- 创建表格，添加索引(index_user_item)是为了加快后面删除推荐集中包含的训练集数据
CREATE TABLE `00training` (
  `id` varchar(20) NOT NULL DEFAULT '',
  `userID` int(2) DEFAULT '0',
  `itemID` int(2) DEFAULT NULL,
  `weight` double(7,6) DEFAULT NULL,
  KEY `index_user_item` (`userID`,`itemID`)
);
CREATE TABLE `00testing` (
  `id` varchar(20) NOT NULL DEFAULT '',
  `userID` int(2) DEFAULT '0',
  `itemID` int(2) DEFAULT NULL,
  `weight` double(7,6) DEFAULT NULL,
  KEY `index_user_item` (`userID`,`itemID`)
);

-- 训练集和测试集7:3，按用户分组随机划分
-- 导入训练集（542682）
LOAD DATA LOCAL INFILE 'E:\\record\\03userbehavior\\02datahandle\\training.txt'-- 数据位置
INTO TABLE 00training-- 要导入的表
FIELDS TERMINATED BY ' '-- 数据以什么分隔
LINES TERMINATED BY '\r\n'-- 行间用什么分隔
(userID,itemID,weight);-- 表中的字段

-- 将id设置成userID_itemID的格式，并设置成主键
UPDATE 00training SET id = CONCAT(userID,'_',itemID);
ALTER TABLE 00training ADD PRIMARY KEY(id);

SELECT DISTINCT(userID) FROM 00training;-- 所有用户都在训练集里
SELECT DISTINCT(itemID) FROM 00training;-- 14427个item，有1117个Item不在训练集中

-- 导入测试集（193901）
LOAD DATA LOCAL INFILE 'E:\\record\\03userbehavior\\02datahandle\\testing.txt'-- 数据位置
INTO TABLE 00testing-- 要导入的表
FIELDS TERMINATED BY ' '-- 数据以什么分隔
LINES TERMINATED BY '\r\n'-- 行间用什么分隔
(userID,itemID,weight);-- 表中的字段

-- 将id设置成userID_itemID的格式，并设置成主键
UPDATE 00testing SET id = CONCAT(userID,'_',itemID);
ALTER TABLE 00testing ADD PRIMARY KEY(id);

SELECT DISTINCT(userID) FROM 00testing;-- 所有用户都在测试集里
SELECT DISTINCT(itemID) FROM 00testing;-- 10925个item，有1117个Item不在训练集中

-- 计算测试集里有多少个item不在训练集里(1023个item)
CREATE TABLE item1 SELECT DISTINCT(itemID) FROM 00testing;
CREATE TABLE item2 SELECT DISTINCT(itemID) FROM 00training;
SELECT * FROM item1 WHERE itemID NOT IN (SELECT itemID FROM item2);

-- 构建NE网络数据并导出
CREATE TABLE `t1_network` (
  `node1` int(2) NOT NULL,
  `node2` int(2) NOT NULL,
  `weight` tinyint(1) NOT NULL
);
INSERT INTO t1_network SELECT userID,itemID,weight FROM 00training;
INSERT INTO t1_network SELECT itemID,userID,weight FROM 00training;
SELECT * FROM t1_network INTO OUTFILE '/var/lib/mysql-files/ne_network.txt'


-- 2、导入matlab计算后的打分数据
-- 创建score_dimension_attribute表格,添加索引(index_user_item)是为了加快后面删除推荐集中包含的训练集数据
-- create_score_table_attri('max_dimension','attribute')
CALL create_score_table_attri('128','0');

LOAD DATA LOCAL INFILE 'E:\\record\\temprecord\\score_1st_16.txt'-- 数据位置
INTO TABLE score_16_0-- 要导入的表
FIELDS TERMINATED BY '\t'-- 数据以什么分隔
LINES TERMINATED BY '\n'-- 行间用什么分隔
(userID,itemID,score);-- 表中的字段*/

LOAD DATA LOCAL INFILE 'E:\\record\\temprecord\\score_1st_32.txt'-- 数据位置
INTO TABLE score_32_0-- 要导入的表
FIELDS TERMINATED BY '\t'-- 数据以什么分隔
LINES TERMINATED BY '\n'-- 行间用什么分隔
(userID,itemID,score);-- 表中的字段*/

LOAD DATA LOCAL INFILE 'E:\\record\\temprecord\\score_1st_64.txt'-- 数据位置
INTO TABLE score_64_0-- 要导入的表
FIELDS TERMINATED BY '\t'-- 数据以什么分隔
LINES TERMINATED BY '\n'-- 行间用什么分隔
(userID,itemID,score);-- 表中的字段*/

LOAD DATA LOCAL INFILE 'E:\\record\\temprecord\\score_1st_128.txt'-- 数据位置
INTO TABLE score_128_0-- 要导入的表
FIELDS TERMINATED BY '\t'-- 数据以什么分隔
LINES TERMINATED BY '\n'-- 行间用什么分隔
(userID,itemID,score);-- 表中的字段*/

-- 删除前的推荐集数据量
SELECT COUNT(*) FROM score_16_0;
SELECT COUNT(*) FROM score_32_0;
SELECT COUNT(*) FROM score_64_0;
SELECT COUNT(*) FROM score_128_0;

-- 删除打分集中包含的测试集数据
DELETE score_16_0 FROM score_16_0, 00training WHERE score_16_0.userID=00training.userID AND score_16_0.itemID=00training.itemID;
DELETE score_32_0 FROM score_32_0, 00training WHERE score_32_0.userID=00training.userID AND score_32_0.itemID=00training.itemID;
DELETE score_64_0 FROM score_64_0, 00training WHERE score_64_0.userID=00training.userID AND score_64_0.itemID=00training.itemID;
DELETE score_128_0 FROM score_128_0, 00training WHERE score_128_0.userID=00training.userID AND score_128_0.itemID=00training.itemID;

-- 删除后的推荐集数据量
SELECT COUNT(*) FROM score_16_0;
SELECT COUNT(*) FROM score_32_0;
SELECT COUNT(*) FROM score_64_0;
SELECT COUNT(*) FROM score_128_0;

-- 统计每个用户的推荐节目数
SELECT COUNT(*) FROM score_16_0 GROUP BY userID; -- 最少532
SELECT COUNT(*) FROM score_32_0 GROUP BY userID; -- 最少463
SELECT COUNT(*) FROM score_64_0 GROUP BY userID; -- 最少271
SELECT COUNT(*) FROM score_128_0 GROUP BY userID; -- 最少47

-- 为了加快后面的推荐速度，先选出每个用户的前num项
-- 创建添加主键和userID, score聚合索引的表格保存前30项，topnum_attribute_dimension
-- create_topk_table_attri('max_dimension','num','attribute')
CALL create_topk_table_attri('128','30','0');

-- 获取前num项
-- get_score_limit_num('max_userid','dimension','attribute','num')
CALL get_score_limit_num('107086','16','0','30');
CALL get_score_limit_num('107086','32','0','30');
CALL get_score_limit_num('107086','64','0','30');
CALL get_score_limit_num('107086','128','0','30');


-- 开始做topn推荐
-- 创建保存top1-top20的表格：topi_attribute_dimension
-- create_topn_table_attribute('dimension','i','attribute')
CALL create_topn_table_attribute('16','20','0');
CALL create_topn_table_attribute('32','20','0');
CALL create_topn_table_attribute('64','20','0');
CALL create_topn_table_attribute('128','20','0');

-- 选择前N项
-- get_topn_attribute('k','dimension','num','attribute')
CALL get_topn_attribute('30','16','20','0');
CALL get_topn_attribute('30','32','20','0');
CALL get_topn_attribute('30','64','20','0');
CALL get_topn_attribute('30','128','20','0');


-- 统计实验结果
-- 创建保存实验结果的表格topn_result_dimension
-- create_result_table_dimension(max_dimension)
CALL create_result_table_dimension('128');

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


