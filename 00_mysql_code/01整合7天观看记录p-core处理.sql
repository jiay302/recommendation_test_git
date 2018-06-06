-- 创建表watch_records来存储7天的所有观看记录
CREATE TABLE `watch_records` (
  `keystr` varchar(255) DEFAULT NULL,
  `userlocation` varchar(255) DEFAULT NULL,
  `provinceid` int(11) DEFAULT NULL,
  `cityid` int(11) DEFAULT NULL,
  `createTime` varchar(255) DEFAULT NULL,
  `codestr` varchar(255) DEFAULT NULL,
  `videoName` varchar(255) DEFAULT NULL,
  `videoSource` varchar(255) DEFAULT NULL,
  `firstLevel` varchar(255) DEFAULT NULL,
  `firstLevelCount` varchar(255) DEFAULT NULL,
  `secondLevel` varchar(255) DEFAULT NULL,
  `secondLevelCount` varchar(255) DEFAULT NULL,
  `threeLevel` varchar(255) DEFAULT NULL,
  `threeLevelCount` varchar(255) DEFAULT NULL,
  `openPostCount` varchar(255) DEFAULT NULL,
  `videoStartTime` varchar(255) DEFAULT NULL,
  `videoEndTime` varchar(255) DEFAULT NULL,
  `videoErrorTime` varchar(255) DEFAULT NULL,
  `watchTime` varchar(255) DEFAULT NULL,
  `searchValue` varchar(255) DEFAULT NULL,
  `contentSource` varchar(255) DEFAULT NULL,
  `directName` varchar(255) DEFAULT NULL,
  `actorName` varchar(255) DEFAULT NULL,
  `videoType` varchar(255) DEFAULT NULL,
  `videoPlot` varchar(255) DEFAULT NULL,
  `videoScore` varchar(255) DEFAULT NULL,
  `videoRegion` varchar(255) DEFAULT NULL,
  `videoTimeLength` varchar(255) DEFAULT NULL,
  `dt` varchar(255) DEFAULT NULL,
  `ht` varchar(255) DEFAULT NULL
);

-- 将7天的数据导入
INSERT INTO watch_records SELECT * FROM 20180301_merge;
INSERT INTO watch_records SELECT * FROM 20180302_merge;
INSERT INTO watch_records SELECT * FROM 20180303_merge;
INSERT INTO watch_records SELECT * FROM 20180304_merge;
INSERT INTO watch_records SELECT * FROM 20180305_merge;
INSERT INTO watch_records SELECT * FROM 20180306_merge;
INSERT INTO watch_records SELECT * FROM 20180307_merge;

-- 将watch_records里keystr、videoName为NULL或''的记录删除
DELETE FROM watch_records WHERE keystr IS NULL OR keystr='';-- 610条数据
DELETE FROM watch_records WHERE videoName IS NULL OR videoName='';-- 没有此类数据，因为前期数据清洗已经过滤过这种情况

-- 将watch_records里的videoName字段的首尾空格去除
UPDATE watch_records SET videoName=TRIM(videoName);-- 213条数据

-- 创建表watch_counts统计每个用户观看每个节目的次数
CREATE TABLE `watch_counts` (
  `keystr` varchar(255) DEFAULT NULL,
  `videoName` varchar(255) DEFAULT NULL,
  `counts` int(2) DEFAULT NULL
);

INSERT INTO watch_counts SELECT keystr,videoName,COUNT(*) FROM watch_records GROUP BY keystr,videoName ORDER BY keystr,videoName;

-- 查询一个用户总共看的节目数，将结果保存到user_videos表中
CREATE TABLE `user_videos` (
  `keystr` varchar(255) PRIMARY KEY NOT NULL,
  `videocounts` int(2) DEFAULT NULL
);
INSERT INTO user_videos SELECT keystr,COUNT(*)FROM watch_counts GROUP BY keystr ORDER BY keystr;

-- 选出观看节目数大于4次的用户，作为本次推荐的用户集，保存到t1_users表中
CREATE TABLE `t1_users` (
  `userID` int(2) PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `keystr` varchar(255) DEFAULT NULL,
  INDEX(keystr)
);
INSERT INTO t1_users(keystr) SELECT keystr FROM user_videos WHERE videocounts > 4;-- 59176个用户

-- 根据用户集选出对应的观看记录
CREATE TABLE `t1_watch` (
  `keystr` varchar(255) DEFAULT NULL,
  `videoName` varchar(255) DEFAULT NULL,
  `counts` int(2) DEFAULT NULL
);
INSERT INTO t1_watch SELECT * FROM watch_counts WHERE keystr IN (SELECT keystr FROM t1_users);-- 736583观看记录

-- 根据选出的观看记录获得本次推荐的节目表，保存到t1_videos表中
CREATE TABLE `t1_videos` (
  `itemID` int(2) PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `videoName` varchar(255) DEFAULT NULL,
  INDEX(videoName)
);
INSERT INTO t1_videos(videoName) SELECT DISTINCT(videoName) FROM t1_watch ORDER BY videoName;-- 15544个节目
UPDATE t1_videos SET itemID=itemID+59176;-- 接着用户编号开始编号

-- 根据观看记录以及用户、节目编号，构建打分表t1_score_1
CREATE TABLE `t1_score_1` (
  `userID` int(2) DEFAULT NULL,
  `keystr` varchar(255) DEFAULT NULL,
  `itemID` int(2) DEFAULT NULL,
  `videoName` varchar(255) DEFAULT NULL,
  `score` tinyint(1) NOT NULL DEFAULT '1'
);
INSERT INTO t1_score_1(keystr,videoName) SELECT keystr,videoName FROM t1_watch GROUP BY keystr,videoName; -- 共736583条记录
UPDATE t1_score_1,t1_users SET t1_score_1.userID=t1_users.userID WHERE t1_score_1.keystr=t1_users.keystr;
UPDATE t1_score_1,t1_videos SET t1_score_1.itemID=t1_videos.itemID WHERE t1_score_1.videoName=t1_videos.videoName;

-- 导出数据
SELECT userID,itemID,score FROM t1_score_1 ORDER BY userID,itemID INTO OUTFILE '/var/lib/mysql-files/dataInit.txt';


