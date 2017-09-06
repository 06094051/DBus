create database dbusmgr;

CREATE USER dbusmgr IDENTIFIED BY 'jNXbcK&*ms2hmvRI';

GRANT ALL ON dbusmgr.* TO dbusmgr@'%' IDENTIFIED BY 'jNXbcK&*ms2hmvRI';

flush privileges;

USE `dbusmgr`;

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for t_avro_schema
-- ----------------------------
DROP TABLE IF EXISTS `t_avro_schema`;
CREATE TABLE `t_avro_schema` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ds_id` int(11) NOT NULL COMMENT 't_dbus_datasource��ID',
  `namespace` varchar(64) NOT NULL DEFAULT '' COMMENT 'schema����',
  `schema_name` varchar(64) NOT NULL DEFAULT '' COMMENT 'schema����',
  `full_name` varchar(128) NOT NULL DEFAULT '' COMMENT 'schema����',
  `schema_hash` int(11) NOT NULL,
  `schema_text` varchar(20460) NOT NULL DEFAULT '' COMMENT 'schema�ַ�����json',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_schema_name` (`full_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='������Ϣ��avro schema��';


-- ----------------------------
-- Table structure for t_data_schema
-- ----------------------------
DROP TABLE IF EXISTS `t_data_schema`;
CREATE TABLE `t_data_schema` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ds_id` int(11) unsigned NOT NULL COMMENT 't_dbus_datasource ��ID',
  `schema_name` varchar(64) NOT NULL DEFAULT '' COMMENT 'schema',
  `status` varchar(32) NOT NULL DEFAULT '' COMMENT '״̬ active/inactive',
  `src_topic` varchar(64) NOT NULL DEFAULT '' COMMENT 'Դtopic',
  `target_topic` varchar(64) NOT NULL DEFAULT '' COMMENT 'Ŀ��topic',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����ʱ��',
  `description` varchar(128) DEFAULT NULL COMMENT 'schema������Ϣ',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_dsid_sname` (`ds_id`,`schema_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_data_tables
-- ----------------------------
DROP TABLE IF EXISTS `t_data_tables`;
CREATE TABLE `t_data_tables` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ds_id` int(11) unsigned NOT NULL COMMENT 't_dbus_datasource ��ID',
  `schema_id` int(11) unsigned NOT NULL COMMENT 't_tab_schema ��ID',
  `schema_name` varchar(64) NOT NULL DEFAULT '' COMMENT 'schema',
  `table_name` varchar(64) NOT NULL DEFAULT '' COMMENT '����',
  `physical_table_regex` varchar(96) DEFAULT NULL,
  `output_topic` varchar(96) DEFAULT '' COMMENT 'kafka_topic',
  `ver_id` int(11) unsigned DEFAULT NULL COMMENT '��ǰʹ�õ�meta�汾ID',
  `status` varchar(32) NOT NULL DEFAULT 'abort' COMMENT '״̬ waiting���ȴ���ȫ�� ok:��ȫ�����������Կ�ʼ�������ݴ��� abort����Ҫ�����ñ������',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����ʱ��',
  `meta_change_flg` int(1) DEFAULT '0' COMMENT 'meta�����ʶ����ʼֵΪ��0����ʾ����û�з��������1������meta������������ֶ�Ŀǰmysql appenderģ��ʹ�á�',
  `batch_id`  int(11) NULL DEFAULT 0 COMMENT '����ID�����������ȫ�������Σ�ÿ����ȫ����++������ֻʹ�ø��ֶβ����޸�' ,
  `ver_change_history`  varchar(96) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '��汾�����ʷ���洢��ֵΪver_id����ʽΪ ����,����,����,... ' ,
  `ver_change_notice_flg`  int(1) NOT NULL DEFAULT 0 COMMENT '��web���Ƿ���ʾ��ṹ�����˱����1Ϊ�ǣ�0Ϊ����' ,
  `output_before_update_flg`  int(1) NOT NULL DEFAULT 0 COMMENT 'ָ���ñ��Ƿ���UMS�����b��before update��' ,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_sid_tabname` (`schema_id`,`table_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_dbus_datasource
-- ----------------------------
DROP TABLE IF EXISTS `t_dbus_datasource`;
CREATE TABLE `t_dbus_datasource` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ds_name` varchar(64) NOT NULL DEFAULT '' COMMENT '����Դ����',
  `ds_type` varchar(32) NOT NULL DEFAULT '' COMMENT '����Դ����oracle/mysql',
  `status` varchar(32) NOT NULL DEFAULT '' COMMENT '״̬��active/inactive',
  `ds_desc` varchar(64) NOT NULL COMMENT '����Դ����',
  `topic` varchar(64) NOT NULL DEFAULT '',
  `ctrl_topic` varchar(64) NOT NULL DEFAULT '',
  `schema_topic` varchar(64) NOT NULL,
  `split_topic` varchar(64) NOT NULL,
  `master_url` varchar(4000) NOT NULL DEFAULT '' COMMENT '����jdbc���Ӵ�',
  `slave_url` varchar(4000) NOT NULL DEFAULT '' COMMENT '����jdbc���Ӵ�',
  `dbus_user` varchar(64) NOT NULL,
  `dbus_pwd` varchar(64) NOT NULL,
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_ds_name` (`ds_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='dbus����Դ���ñ�';

-- ----------------------------
-- Table structure for t_encode_columns
-- ----------------------------
DROP TABLE IF EXISTS `t_encode_columns`;
CREATE TABLE `t_encode_columns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `table_id` int(11) DEFAULT NULL COMMENT '��ID',
  `field_name` varchar(64) DEFAULT NULL COMMENT '�ֶ�����',
  `encode_type` varchar(64) DEFAULT NULL COMMENT '������ʽ',
  `encode_param` varchar(512) DEFAULT NULL COMMENT '����ʹ�õĲ���',
  `desc_` varchar(64) DEFAULT NULL COMMENT '����',
  `truncate` int(1) DEFAULT '0' COMMENT '1:���ַ��������ֶ�ֵ�����󳬳�Դ���ֶγ���ʱ����Դ���ֶγ��Ƚ�ȡ 0:������ȡ����',
  `update_time` datetime DEFAULT NULL COMMENT '����ʱ��',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='�������ñ�';

-- ----------------------------
-- Table structure for t_meta_version
-- ----------------------------
DROP TABLE IF EXISTS `t_meta_version`;
CREATE TABLE `t_meta_version` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `table_id` int(11) NOT NULL,
  `ds_id` int(11) unsigned NOT NULL COMMENT 't_dbus_datasource���ID',
  `db_name` varchar(64) NOT NULL DEFAULT '' COMMENT '���ݿ���',
  `schema_name` varchar(64) NOT NULL DEFAULT '' COMMENT 'schema��',
  `table_name` varchar(64) NOT NULL DEFAULT '' COMMENT '����',
  `version` int(11) NOT NULL COMMENT '�汾��',
  `inner_version` int(11) NOT NULL COMMENT '�ڲ��汾��',
  `event_offset` bigint(20) DEFAULT NULL COMMENT '����version�������Ϣ��kafka�е�offsetֵ',
  `event_pos` bigint(20) DEFAULT NULL COMMENT '����version�������Ϣ��trail�ļ��е�posֵ',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '��������',
  PRIMARY KEY (`id`),
  KEY `idx_event_offset` (`event_offset`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='t_table_meta�İ汾��Ϣ';

-- ----------------------------
-- Table structure for t_storm_topology
-- ----------------------------
DROP TABLE IF EXISTS `t_storm_topology`;
CREATE TABLE `t_storm_topology` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `topology_name` varchar(128) NOT NULL,
  `ds_id` int(11) NOT NULL,
  `jar_name` varchar(512) DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_table_meta
-- ----------------------------
DROP TABLE IF EXISTS `t_table_meta`;
CREATE TABLE `t_table_meta` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ver_id` int(11) NOT NULL COMMENT '�汾id��t_meta_version��',
  `column_name` varchar(64) NOT NULL DEFAULT '' COMMENT '�滻�����ַ������ɵ��������滻����replaceAll("[^A-Za-z0-9_]", "_")',
  `original_column_name` varchar(64) DEFAULT NULL COMMENT '���ݿ���ԭʼ������',
  `column_id` int(4) NOT NULL COMMENT '��ID',
  `internal_column_id` int(11) DEFAULT NULL,
  `hidden_column` varchar(8) DEFAULT NULL,
  `virtual_column` varchar(8) DEFAULT NULL,
  `original_ser` int(11) NOT NULL COMMENT 'Դ�������',
  `data_type` varchar(128) NOT NULL DEFAULT '' COMMENT '��������',
  `data_length` int(11) NOT NULL COMMENT '���ݳ���',
  `data_precision` int(11) DEFAULT NULL COMMENT '���ݾ���',
  `data_scale` int(11) DEFAULT NULL COMMENT 'С�����ֳ���',
  `char_length` int(11) DEFAULT NULL,
  `char_used` varchar(1) DEFAULT NULL,
  `nullable` varchar(1) NOT NULL DEFAULT '' COMMENT '�Ƿ�ɿ�Y/N',
  `is_pk` varchar(1) NOT NULL DEFAULT '' COMMENT '�Ƿ�Ϊ����Y/N',
  `pk_position` int(2) DEFAULT NULL COMMENT '������˳��',
  `alter_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '����/�޸ĵ�ʱ��',
  PRIMARY KEY (`id`),
  KEY `idx_table_meta` (`ver_id`,`column_name`,`original_ser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='ץȡ��Դ������meta��Ϣ';


