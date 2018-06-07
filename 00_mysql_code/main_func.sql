-- MySQL dump 10.13  Distrib 5.7.22, for Linux (x86_64)
--
-- Host: localhost    Database: xytemp
-- ------------------------------------------------------
-- Server version	5.7.22

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'xytemp'
--
/*!50003 DROP PROCEDURE IF EXISTS `create_result_table_dimension` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `create_result_table_dimension`(IN `max_dimension` int(2))
BEGIN
/*
作用：创建存储topn推荐实验统计结果的表格（16、32、64、128）
参数：
			max_dimension：最大维度（128）

表格命名格式：topn_result_dimension
*/

	DECLARE i INT;
	DECLARE table_name VARCHAR(20);
	DECLARE sql_create VARCHAR(1000);

	SET i = 16;
	SET table_name = '';
	SET sql_create = '';

	WHILE i <= max_dimension DO

		SET table_name = CONCAT('topn_result_',i);
		SET sql_create = CONCAT('CREATE TABLE ',table_name,' (
	`topk` int(2) NOT NULL AUTO_INCREMENT,
  `totalNum` int(2) DEFAULT NULL,
  `correctNum` int(2) DEFAULT NULL,
	PRIMARY KEY (`topk`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8');
		SELECT sql_create;
		SET @sql_create = sql_create;
		PREPARE stmt FROM @sql_create;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SET i = i*2;
	END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_score_table_attri` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `create_score_table_attri`(IN `max_dimension` int(2),IN `attribute` varchar(10))
BEGIN
/*
作用：创建存储score的表格（16、32、64、128维度），添加索引是为了加快后面删除推荐集中包含的训练集数据
参数：
			max_dimension：最大维度（128）
			attribute：计算同种类型节点间相似度时考虑的节点属性

表格命名格式：score_dimension_attribute
*/

	DECLARE i INT;
	DECLARE table_name VARCHAR(20);
	DECLARE sql_create VARCHAR(1000);
	SET i = 16;
	SET table_name = '';
	SET sql_create = '';
	WHILE i <= max_dimension DO
		SET table_name = CONCAT('score','_',i,'_',attribute);
		SET sql_create = CONCAT('CREATE TABLE ',table_name,' (
  `userID` int(2) NOT NULL,
  `itemID` int(2) NOT NULL,
  `score` double(7,6) NOT NULL,
  KEY `index_user_item` (`userID`,`itemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8');

		SELECT sql_create;
		SET @sql_create = sql_create;
		PREPARE stmt FROM @sql_create;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		SET i = i*2;
	END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_topk_table_attri` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `create_topk_table_attri`(IN `max_dimension` int(2),IN `num` int(2),IN `attribute` varchar(10))
BEGIN
/*
作用：创建存储topn推荐结果的表格（16、32、64、128）
参数：
			max_dimension：最大维度（128）
			num：选择推荐结果的前num项
			attribute：计算同种类型节点间相似度时考虑的节点属性

表格命名格式：topnum_attribute_dimension
*/

	DECLARE i INT;
	DECLARE table_name VARCHAR(20);
	DECLARE sql_create VARCHAR(1000);

	SET i = 16;
	SET table_name = '';
	SET sql_create = '';

	WHILE i <= max_dimension DO

		SET table_name = CONCAT('top',num,'_',attribute,'_',i);
		SET sql_create = CONCAT('CREATE TABLE ',table_name,' (
  `id` varchar(20) NOT NULL,
  `userID` int(2) NOT NULL,
  `itemID` int(2) NOT NULL,
  `score` double(7,6) NOT NULL,
  PRIMARY KEY (`id`),
	KEY `index_union_user_score` (`userID`,`score`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8');
		SELECT sql_create;
		SET @sql_create = sql_create;
		PREPARE stmt FROM @sql_create;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SET i = i*2;
	END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_topn_table_attribute` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `create_topn_table_attribute`(IN `dimension` int(2),IN `num` int(2),IN `attribute` varchar(10))
BEGIN
/*
作用：创建存储topn推荐结果的表格
参数：
			dimension：维度（16、32、64、128）
			num：创建的表格数
			attribute：计算同种类型节点间相似度时考虑的节点属性

表格命名格式：topi_attribute_dimension
*/

	DECLARE i INT;
	DECLARE table_name VARCHAR(20);
	DECLARE sql_create VARCHAR(1000);
	SET i = 1;
	SET table_name = '';
	SET sql_create = '';
	WHILE i <= num DO
		IF i <10 THEN SET table_name = CONCAT('top0',i,'_',attribute,'_',dimension);
		ELSE SET table_name = CONCAT('top',i,'_',attribute,'_',dimension);
		END IF;
		SET sql_create = CONCAT('CREATE TABLE ',table_name,' (
  `id` varchar(20) NOT NULL,
  `userID` int(2) NOT NULL,
  `itemID` int(2) NOT NULL,
  `score` double(7,6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8');
		SELECT sql_create;
		SET @sql_create = sql_create;
		PREPARE stmt FROM @sql_create;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		SET i = i+1;
	END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_score_limit_num` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `get_score_limit_num`(IN `max_userid` int(4),IN `dimension` int(4),IN `attribute` varchar(10),IN `num` int(4))
BEGIN
/*
作用：根据输入的参数从按userID和score排好序的score_dimension_attribute表里选出指定的前num项
参数：
			max_userid：最大用户的ID，即用户个数
			dimension：维度（16、32、64、128）
			attribute：计算同种类型节点间相似度时考虑的节点属性
			num：选择推荐结果的前num项

用于查询的表格命名格式：score_dimension_attribute
保存结果的表格命名格式：topnum_attribute_dimension
*/
	
	DECLARE i INT;
	DECLARE query_table VARCHAR(20);
	DECLARE result_table VARCHAR(20);
	DECLARE sql_text VARCHAR(2000);

  SET i = 1;
	SET query_table = CONCAT('score_',dimension,'_',attribute);
	SET result_table = CONCAT('top',num,'_',attribute,'_',dimension);
	SET sql_text = '';

	WHILE i <= max_userid DO

		SET sql_text = CONCAT('INSERT INTO ',result_table,' SELECT CONCAT(userID,\'_\',itemID),userID,itemID,score FROM (SELECT * FROM ',query_table,' WHERE userID=',i,' ORDER BY score DESC) AS temp LIMIT ',num);
		SELECT sql_text;
		SET @sql_text = sql_text;
		PREPARE stmt FROM @sql_text;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		SET i = i+1;
	END WHILE;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_topn_attribute` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `get_topn_attribute`(IN `k` int(2),IN `dimension` int(2),IN `num` int(2),IN `attribute` varchar(10))
BEGIN
/*
作用：根据输入的参数做相应的topn推荐，并将结果插入到相应的表格
参数：
      k:=推荐集中包含了前k项
			dimension：维度（16、32、64、128）
			num：创建的表格数
			attribute：计算同种类型节点间相似度时考虑的节点属性

用于查询的表格命名格式：top50_attribute_dimension
保存结果的表格命名格式：topi_attribute_dimension
*/
	
	DECLARE i INT;
	DECLARE query_table VARCHAR(20);
	DECLARE result_table VARCHAR(20);
	DECLARE sql_text VARCHAR(2000);
	SET i = 1;
	SET query_table = CONCAT('top',k,'_',attribute,'_',dimension);
	SET result_table = '';
	SET sql_text = '';
	WHILE i <= num DO
		IF i <10 THEN SET result_table = CONCAT('top0',i,'_',attribute,'_',dimension);
		ELSE SET result_table = CONCAT('top',i,'_',attribute,'_',dimension);
		END IF;
		SET sql_text = CONCAT('INSERT INTO ',result_table,' SELECT a.* FROM ',query_table,' a WHERE (SELECT COUNT(*) FROM ',query_table,' WHERE userID=a.userID AND score > a.score)<',i,' ORDER BY a.userID,a.score DESC');
		SELECT sql_text;
		SET @sql_text = sql_text;
		PREPARE stmt FROM @sql_text;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
		SET i = i+1;
	END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-06-06  4:14:54
