/*
 Navicat Premium Data Transfer

 Source Server         : IaaS pro
 Source Server Type    : MySQL
 Source Server Version : 80034 (8.0.34)
 Source Host           : iaas-center.mysql.rds.aliyuncs.com:3306
 Source Schema         : iaas_storage

 Target Server Type    : MySQL
 Target Server Version : 80034 (8.0.34)
 File Encoding         : 65001

 Date: 29/12/2025 11:06:39
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for container_image_info
-- ----------------------------
DROP TABLE IF EXISTS `container_image_info`;
CREATE TABLE `container_image_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL DEFAULT '0',
  `image_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `rom_image_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `is_public` tinyint(1) DEFAULT '0',
  `description` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `image_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `size` int DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `mgr_state` tinyint DEFAULT '0',
  `status` tinyint NOT NULL DEFAULT '0',
  `map_account_id` int DEFAULT NULL,
  `map_image_id` varchar(64) DEFAULT NULL,
  `user_image_file` varchar(256) DEFAULT NULL,
  `supplier_type` int DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `image_id` (`image_id`) USING BTREE,
  KEY `account_id` (`account_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for data_image_info
-- ----------------------------
DROP TABLE IF EXISTS `data_image_info`;
CREATE TABLE `data_image_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL DEFAULT '0',
  `image_id` varchar(64) NOT NULL,
  `data_version` varchar(128) DEFAULT NULL,
  `image_name` varchar(64) DEFAULT NULL,
  `snapshot_index` int DEFAULT NULL,
  `parent_image_id` varchar(64) DEFAULT NULL,
  `root_image_id` varchar(64) DEFAULT NULL,
  `oss_file_ready` tinyint DEFAULT '0',
  `root_image_lock` varchar(64) DEFAULT NULL,
  `description` varchar(128) DEFAULT NULL,
  `deploy_type` varchar(32) DEFAULT NULL,
  `size` int DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `instance_id` varchar(128) DEFAULT NULL,
  `mgr_state` tinyint DEFAULT '0',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `mount_instance` varchar(64) DEFAULT NULL,
  `flatten_image` varchar(64) DEFAULT NULL,
  `rollback_index` int DEFAULT '0',
  `mount_index` tinyint DEFAULT NULL,
  `map_account_id` int DEFAULT '0',
  `map_image_id` varchar(64) DEFAULT NULL,
  `map_snapshot_id` varchar(64) DEFAULT NULL,
  `supplier_type` int DEFAULT '0',
  `real_size` int DEFAULT '0' COMMENT 'real_size,单位MB',
  `total_used_size` int DEFAULT '0' COMMENT '母盘总使用大小,单位MB',
  `is_cloud_disk` tinyint NOT NULL DEFAULT (0) COMMENT '是否是云盘',
  PRIMARY KEY (`id`),
  UNIQUE KEY `image_id` (`image_id`),
  UNIQUE KEY `user_storage_unique` (`root_image_id`,`snapshot_index`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7003 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for esport_download_idc_map_info
-- ----------------------------
DROP TABLE IF EXISTS `esport_download_idc_map_info`;
CREATE TABLE `esport_download_idc_map_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `area_type` bigint DEFAULT NULL COMMENT '云电竞给的idc_id',
  `esport_unique_id` bigint DEFAULT NULL COMMENT '云电竞给的idc_id对应的下载id',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录更新时间',
  `modify_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `area_type` (`area_type`),
  UNIQUE KEY `esport_unique_id` (`esport_unique_id`),
  KEY `idx_modify_time` (`modify_time`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for esport_upload_instance_map_info
-- ----------------------------
DROP TABLE IF EXISTS `esport_upload_instance_map_info`;
CREATE TABLE `esport_upload_instance_map_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `instance_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'iaas 实例 id',
  `esport_unique_id` bigint DEFAULT NULL COMMENT '云电竞给的上传机的唯一id',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录更新时间',
  `modify_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `instance_id` (`instance_id`),
  UNIQUE KEY `esport_unique_id` (`esport_unique_id`),
  KEY `idx_modify_time` (`modify_time`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Table structure for os_image_info
-- ----------------------------
DROP TABLE IF EXISTS `os_image_info`;
CREATE TABLE `os_image_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL DEFAULT '0',
  `image_id` varchar(64) NOT NULL,
  `os_version` varchar(128) DEFAULT NULL,
  `image_name` varchar(64) DEFAULT NULL,
  `snapshot_index` int DEFAULT NULL,
  `parent_image_id` varchar(64) DEFAULT NULL,
  `root_image_id` varchar(64) DEFAULT NULL,
  `root_image_lock` varchar(64) DEFAULT NULL,
  `description` varchar(128) DEFAULT NULL,
  `architecture` varchar(16) DEFAULT NULL,
  `platform` varchar(16) DEFAULT NULL,
  `owner_type` tinyint DEFAULT NULL,
  `size` int DEFAULT '0',
  `mgr_state` tinyint DEFAULT '0',
  `instance_id` varchar(64) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `oss_file_ready` tinyint DEFAULT '0',
  `mount_instance` varchar(64) DEFAULT NULL,
  `flatten_image` varchar(64) DEFAULT NULL,
  `rollback_index` int DEFAULT '0',
  `map_account_id` int DEFAULT '0',
  `map_image_id` varchar(64) DEFAULT NULL,
  `tags` varchar(512) DEFAULT NULL,
  `supplier_type` int DEFAULT '0',
  `extra_image_info` text COMMENT '如ironic中特有的信息',
  `real_size` int DEFAULT '0' COMMENT 'real_size,单位MB',
  `total_used_size` int DEFAULT '0' COMMENT '母盘总使用大小,单位MB',
  `is_cloud_disk` tinyint NOT NULL DEFAULT (0) COMMENT '是否是云盘',
  PRIMARY KEY (`id`),
  UNIQUE KEY `image_id` (`image_id`),
  UNIQUE KEY `user_storage_unique` (`root_image_id`,`snapshot_index`),
  UNIQUE KEY `map_image_id` (`image_id`,`map_account_id`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3215 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for rom_image_info
-- ----------------------------
DROP TABLE IF EXISTS `rom_image_info`;
CREATE TABLE `rom_image_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL DEFAULT '0',
  `image_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `filename` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `vedcode` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `is_public` tinyint(1) DEFAULT '0',
  `file_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `description` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `hardware_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '0',
  `mgr_state` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `image_id` (`image_id`) USING BTREE,
  KEY `account_id` (`account_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for storage_alarm_template
-- ----------------------------
DROP TABLE IF EXISTS `storage_alarm_template`;
CREATE TABLE `storage_alarm_template` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键编码',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT '告警模板名称',
  `template` varchar(5120) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT '告警模板内容',
  `create_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '最近更新时间',
  `modify_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '最后修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_storage_alarm_template_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_ci;

-- ----------------------------
-- Table structure for storage_alarm_tenant
-- ----------------------------
DROP TABLE IF EXISTS `storage_alarm_tenant`;
CREATE TABLE `storage_alarm_tenant` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键编码',
  `tenant_account` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT '租户',
  `query_max_hour` smallint DEFAULT NULL COMMENT '查询时间范围(最近创建)',
  `query_interval_minute` smallint DEFAULT NULL COMMENT '查询间隔时间(分钟)',
  `trigger_interval_minute` smallint DEFAULT NULL COMMENT '告警通知间隔(分钟)',
  `notice_trigger_ratio` smallint DEFAULT NULL COMMENT '普通告警触发百分比',
  `notice_trigger_count` smallint DEFAULT NULL COMMENT '普通告警触发数量',
  `serious_trigger_ratio` smallint DEFAULT NULL COMMENT '严重告警触发百分比',
  `notice_wecom_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT '普通告警通知群',
  `serious_wecom_group` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT '严重告警通知群',
  `exec_timeout_minute` smallint DEFAULT NULL COMMENT '执行超时时间(分钟)',
  `schedule_timeout_minute` smallint DEFAULT NULL COMMENT '编排超时时间(分钟)',
  `exec_failed_notice_user` json DEFAULT NULL COMMENT '执行失败通知的用户列表(手机号)',
  `schedule_failed_notice_user` json DEFAULT NULL COMMENT '编排失败通知的用户列表(手机号)',
  `schedule_task_type` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT '检测编排任务类型',
  `query_resource_type` json DEFAULT NULL COMMENT '查询资源类型列表',
  `alarm_template` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_ci DEFAULT NULL COMMENT '告警模板名称',
  `create_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '最近更新时间',
  `modify_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '最后修改时间',
  `exec_ignore_task_type` varchar(128) COLLATE utf8mb4_0900_as_ci DEFAULT '59' COMMENT '检查执行忽略任务类型',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uni_storage_alarm_tenant_tenant_account` (`tenant_account`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_ci;

-- ----------------------------
-- Table structure for storage_cluster_info
-- ----------------------------
DROP TABLE IF EXISTS `storage_cluster_info`;
CREATE TABLE `storage_cluster_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `map_account_id` int DEFAULT NULL,
  `idc_id` json DEFAULT NULL,
  `endpoint` varchar(128) DEFAULT NULL,
  `storage_type` tinyint NOT NULL DEFAULT '0',
  `storage_size` int DEFAULT '0',
  `storage_status` tinyint DEFAULT '0',
  `description` varchar(128) DEFAULT NULL,
  `permissions` json DEFAULT NULL,
  `mgr_state` tinyint DEFAULT '0',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `agent_addr` varchar(32) DEFAULT NULL,
  `root_pool` varchar(32) DEFAULT NULL,
  `runtime_pool` varchar(32) DEFAULT NULL,
  `aic_node_addr` varchar(32) DEFAULT NULL,
  `rgw_bucket` varchar(32) DEFAULT NULL,
  `rgw_option` json DEFAULT NULL,
  `diskless_addr` varchar(64) DEFAULT NULL COMMENT '无盘系统访问地址',
  `ironic_api_addr` varchar(64) DEFAULT NULL COMMENT 'ironic_api_addr,eg:http://10.118.240.45:6385',
  `image_id` varchar(256) DEFAULT NULL COMMENT '云电竞机房使用母盘,eg:data_pool-g4.game.image',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for storage_express_file_info
-- ----------------------------
DROP TABLE IF EXISTS `storage_express_file_info`;
CREATE TABLE `storage_express_file_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `local_base_directory` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '本地base目录',
  `local_directory` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '本地目录',
  `remote_directory` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '云端目录',
  `op` int NOT NULL COMMENT '1: 上传 2: 下载',
  `idc_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'iaas idcid',
  `instance_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'iaas 实例 id',
  `task_id` bigint NOT NULL COMMENT '关联的主任务 id',
  `subtask_id` bigint NOT NULL COMMENT '关联的子任务 id',
  `op_result` bigint NOT NULL COMMENT '1: 成功 2: 失败 3: 进行中',
  `esport_version_info` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'esport 的版本信息',
  `version_info` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'iaas 的版本信息',
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '租户 id',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录更新时间',
  `modify_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '记录修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_modify_time` (`modify_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2071 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='快传文件信息表';

-- ----------------------------
-- Table structure for storage_image_info
-- ----------------------------
DROP TABLE IF EXISTS `storage_image_info`;
CREATE TABLE `storage_image_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL DEFAULT '0',
  `storage_id` int NOT NULL,
  `image_id` varchar(64) DEFAULT NULL,
  `snapshot_id` varchar(64) DEFAULT NULL,
  `image_name` varchar(64) DEFAULT NULL,
  `image_type` tinyint NOT NULL,
  `map_account_id` int DEFAULT NULL,
  `map_image_id` varchar(64) DEFAULT NULL,
  `endpoint` varchar(128) DEFAULT NULL,
  `snapshot_index` int DEFAULT NULL,
  `parent_image_id` varchar(64) DEFAULT NULL,
  `root_image_id` varchar(64) DEFAULT NULL,
  `description` varchar(128) DEFAULT NULL,
  `deploy_type` tinyint DEFAULT NULL,
  `size` int DEFAULT NULL,
  `version` varchar(128) DEFAULT NULL,
  `mgr_state` tinyint DEFAULT '0',
  `storage_type` tinyint NOT NULL DEFAULT '0',
  `task_id` int DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `distribute_state` tinyint NOT NULL,
  `structure` tinyint DEFAULT '1',
  `extra_image_info` text COMMENT '如ironic中特有的信息',
  `real_size` int DEFAULT '0' COMMENT '真实使用大小,单位MB',
  `total_used_size` int DEFAULT '0' COMMENT '母盘总使用大小,单位MB',
  `is_cloud_disk` tinyint NOT NULL DEFAULT (0) COMMENT '是否是云盘',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_storage_unique` (`storage_id`,`image_id`,`deleted_at`),
  UNIQUE KEY `image_snapshot_unique` (`storage_id`,`root_image_id`,`snapshot_index`,`deleted_at`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1002070118 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for storage_image_subtask_info
-- ----------------------------
DROP TABLE IF EXISTS `storage_image_subtask_info`;
CREATE TABLE `storage_image_subtask_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL DEFAULT '0',
  `storage_id` int NOT NULL,
  `storage_image_id` int NOT NULL DEFAULT '0',
  `parent_task` int NOT NULL,
  `instance_id` varchar(64) DEFAULT NULL,
  `image_id` varchar(64) DEFAULT NULL,
  `volume_id` varchar(64) DEFAULT NULL,
  `idc_id` varchar(64) DEFAULT NULL,
  `image_type` tinyint NOT NULL,
  `image_status` tinyint NOT NULL,
  `task_type` int NOT NULL,
  `task_state` tinyint NOT NULL,
  `task_args` json DEFAULT NULL,
  `distribute_state` tinyint NOT NULL,
  `description` varchar(128) DEFAULT NULL,
  `exec_log` json DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `endpoint` varchar(128) DEFAULT NULL,
  `retry_count` int NOT NULL DEFAULT '0',
  `schedule_id` int NOT NULL DEFAULT '0',
  `is_end_task` tinyint NOT NULL DEFAULT '0',
  `progress` bigint DEFAULT NULL,
  `ave_speed_mb` bigint DEFAULT NULL,
  `cur_speed_mb` bigint DEFAULT NULL,
  `step` varchar(128) DEFAULT NULL,
  `detail_code` int NOT NULL DEFAULT '0' COMMENT '错误码',
  PRIMARY KEY (`id`),
  KEY `storage_image_id` (`storage_image_id`),
  KEY `parent_task` (`parent_task`) USING BTREE,
  KEY `idx_create_time` (`create_time`),
  KEY `idx_modify_time` (`modify_time`),
  KEY `idx_imageid_storageid_deletedat_taskstate` (`image_id`,`storage_id`,`deleted_at`,`task_state`),
  KEY `idx_scheduleid_taskstate_deletedat` (`schedule_id`,`task_state`,`deleted_at`),
  KEY `idx_instanceid_accountid_deletedat_taskstate` (`instance_id`,`account_id`,`deleted_at`,`task_state`),
  KEY `idx_volume_deletedat_taskstate` (`volume_id`,`deleted_at`,`task_state`) USING BTREE,
  KEY `task_resource_index` (`parent_task`,`instance_id`,`image_id`,`volume_id`,`task_type`) USING BTREE,
  KEY `idx_idc_desc_modify` (`idc_id`,`description`,`modify_time`),
  KEY `idx_covering` (`idc_id`,`description`,`distribute_state`,`modify_time`,`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=8433840 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for storage_image_subtask_info_20250529
-- ----------------------------
DROP TABLE IF EXISTS `storage_image_subtask_info_20250529`;
CREATE TABLE `storage_image_subtask_info_20250529` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL DEFAULT '0',
  `storage_id` int NOT NULL,
  `storage_image_id` int NOT NULL DEFAULT '0',
  `parent_task` int NOT NULL,
  `instance_id` varchar(64) DEFAULT NULL,
  `image_id` varchar(64) DEFAULT NULL,
  `volume_id` varchar(64) DEFAULT NULL,
  `idc_id` varchar(64) DEFAULT NULL,
  `image_type` tinyint NOT NULL,
  `image_status` tinyint NOT NULL,
  `task_type` int NOT NULL,
  `task_state` tinyint NOT NULL,
  `task_args` json DEFAULT NULL,
  `distribute_state` tinyint NOT NULL,
  `description` varchar(128) DEFAULT NULL,
  `exec_log` json DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `endpoint` varchar(128) DEFAULT NULL,
  `retry_count` int NOT NULL DEFAULT '0',
  `schedule_id` int NOT NULL DEFAULT '0',
  `is_end_task` tinyint NOT NULL DEFAULT '0',
  `progress` bigint DEFAULT NULL,
  `ave_speed_mb` bigint DEFAULT NULL,
  `cur_speed_mb` bigint DEFAULT NULL,
  `step` varchar(128) DEFAULT NULL,
  `detail_code` int NOT NULL DEFAULT '0' COMMENT '错误码',
  PRIMARY KEY (`id`),
  KEY `storage_image_id` (`storage_image_id`),
  KEY `parent_task` (`parent_task`) USING BTREE,
  KEY `idx_create_time` (`create_time`),
  KEY `idx_modify_time` (`modify_time`),
  KEY `idx_imageid_storageid_deletedat_taskstate` (`image_id`,`storage_id`,`deleted_at`,`task_state`),
  KEY `idx_scheduleid_taskstate_deletedat` (`schedule_id`,`task_state`,`deleted_at`),
  KEY `idx_instanceid_accountid_deletedat_taskstate` (`instance_id`,`account_id`,`deleted_at`,`task_state`),
  KEY `idx_volume_deletedat_taskstate` (`volume_id`,`deleted_at`,`task_state`) USING BTREE,
  KEY `task_resource_index` (`parent_task`,`instance_id`,`image_id`,`volume_id`,`task_type`) USING BTREE,
  KEY `idx_idc_desc_modify` (`idc_id`,`description`,`modify_time`),
  KEY `idx_covering` (`idc_id`,`description`,`distribute_state`,`modify_time`,`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3239632 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for storage_image_task_info
-- ----------------------------
DROP TABLE IF EXISTS `storage_image_task_info`;
CREATE TABLE `storage_image_task_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL DEFAULT '0',
  `task_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `idc_id` json DEFAULT NULL,
  `image_id` varchar(64) DEFAULT NULL,
  `change_log` varchar(128) DEFAULT NULL,
  `description` varchar(128) DEFAULT NULL,
  `trace_id` varchar(64) DEFAULT NULL,
  `request_id` varchar(128) DEFAULT NULL,
  `task_type` int NOT NULL,
  `task_state` tinyint DEFAULT NULL,
  `total_count` int DEFAULT '0',
  `pause_count` int DEFAULT '0',
  `success_count` int DEFAULT '0',
  `failed_count` int DEFAULT '0',
  `task_args` json DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `volume_type` tinyint DEFAULT '0',
  `image_type` tinyint NOT NULL,
  `detail_code` int NOT NULL DEFAULT '0' COMMENT '错误码',
  `tenant_account` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `image_id` (`image_id`),
  KEY `task_id` (`task_id`) USING BTREE,
  KEY `idx_create_time` (`create_time`),
  KEY `idx_modify_time` (`modify_time`),
  KEY `idx_create_task_type_state` (`task_type`,`task_state`,`deleted_at`,`create_time`),
  KEY `idx_trace_id` (`trace_id`) USING BTREE,
  KEY `idx_tenant_account` (`tenant_account`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1353361 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for storage_image_upload_info
-- ----------------------------
DROP TABLE IF EXISTS `storage_image_upload_info`;
CREATE TABLE `storage_image_upload_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `image_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `content` json DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `qcow_info` json DEFAULT NULL,
  `full_file_info` json DEFAULT NULL COMMENT '全量文件下载信息',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `image_id` (`image_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8782 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for storage_volume_info
-- ----------------------------
DROP TABLE IF EXISTS `storage_volume_info`;
CREATE TABLE `storage_volume_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL,
  `volume_id` varchar(64) NOT NULL,
  `image_id` varchar(64) DEFAULT NULL,
  `instance_id` varchar(64) DEFAULT NULL,
  `map_account_id` int DEFAULT NULL,
  `map_image_id` varchar(64) DEFAULT NULL,
  `map_volume_id` varchar(64) DEFAULT NULL,
  `idc_id` varchar(64) DEFAULT NULL,
  `storage_id` int NOT NULL,
  `storage_image_id` int NOT NULL,
  `image_type` tinyint NOT NULL,
  `endpoint` varchar(256) DEFAULT NULL,
  `snapshot_index` int DEFAULT NULL,
  `parent_image_id` varchar(64) DEFAULT NULL,
  `root_image_id` varchar(64) DEFAULT NULL,
  `volume_index` smallint NOT NULL,
  `description` varchar(128) DEFAULT NULL,
  `deploy_type` tinyint DEFAULT NULL,
  `size` int DEFAULT NULL,
  `version` varchar(128) DEFAULT NULL,
  `image_status` tinyint DEFAULT NULL,
  `storage_type` tinyint NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `write_mode` tinyint NOT NULL DEFAULT '0',
  `flatten_image` varchar(64) DEFAULT NULL,
  `base_point` varchar(256) DEFAULT NULL,
  `structure` tinyint DEFAULT '1',
  `disk_type` tinyint DEFAULT '1',
  `volume_type` tinyint DEFAULT '0',
  `dynamic_mode` tinyint DEFAULT '0',
  `dynamic_path` varchar(64) DEFAULT NULL,
  `target_name` varchar(128) DEFAULT NULL,
  `extra_image_info` text COMMENT '如ironic中特有的信息',
  `local_disk_size_limit` bigint DEFAULT '0' COMMENT '盘在库存中占用的本地盘空间配额，单位MB',
  `is_cloud_disk` tinyint NOT NULL DEFAULT (0) COMMENT '是否是云盘',
  `cache_type` int DEFAULT '0',
  `cache_size_gb` bigint DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `volume_id` (`volume_id`),
  UNIQUE KEY `volume_index_unique` (`storage_id`,`instance_id`,`image_id`,`volume_index`,`volume_type`) USING BTREE,
  KEY `account_id` (`account_id`),
  KEY `instance_id` (`instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1153343 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for storage_volume_info_copy1
-- ----------------------------
DROP TABLE IF EXISTS `storage_volume_info_copy1`;
CREATE TABLE `storage_volume_info_copy1` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL,
  `volume_id` varchar(64) NOT NULL,
  `image_id` varchar(64) DEFAULT NULL,
  `instance_id` varchar(64) DEFAULT NULL,
  `map_account_id` int DEFAULT NULL,
  `map_image_id` varchar(64) DEFAULT NULL,
  `map_volume_id` varchar(64) DEFAULT NULL,
  `idc_id` varchar(64) DEFAULT NULL,
  `storage_id` int NOT NULL,
  `storage_image_id` int NOT NULL,
  `image_type` tinyint NOT NULL,
  `endpoint` varchar(256) DEFAULT NULL,
  `snapshot_index` int DEFAULT NULL,
  `parent_image_id` varchar(64) DEFAULT NULL,
  `root_image_id` varchar(64) DEFAULT NULL,
  `volume_index` smallint NOT NULL,
  `description` varchar(128) DEFAULT NULL,
  `deploy_type` tinyint DEFAULT NULL,
  `size` int DEFAULT NULL,
  `version` varchar(128) DEFAULT NULL,
  `image_status` tinyint DEFAULT NULL,
  `storage_type` tinyint NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  `write_mode` tinyint NOT NULL DEFAULT '0',
  `flatten_image` varchar(64) DEFAULT NULL,
  `base_point` varchar(128) DEFAULT NULL,
  `structure` tinyint DEFAULT '1',
  `disk_type` tinyint DEFAULT '1',
  `volume_type` tinyint DEFAULT '0',
  `dynamic_mode` tinyint DEFAULT '0',
  `dynamic_path` varchar(64) DEFAULT NULL,
  `target_name` varchar(128) DEFAULT NULL,
  `extra_image_info` text COMMENT '如ironic中特有的信息',
  PRIMARY KEY (`id`),
  UNIQUE KEY `volume_id` (`volume_id`),
  UNIQUE KEY `volume_index_unique` (`storage_id`,`instance_id`,`image_id`,`volume_index`,`volume_type`) USING BTREE,
  KEY `account_id` (`account_id`),
  KEY `instance_id` (`instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=415903 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for storage_volume_instance_info
-- ----------------------------
DROP TABLE IF EXISTS `storage_volume_instance_info`;
CREATE TABLE `storage_volume_instance_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int NOT NULL,
  `volume_id` varchar(64) NOT NULL,
  `map_account_id` int DEFAULT NULL,
  `instance_id` varchar(64) DEFAULT NULL,
  `image_id` varchar(64) DEFAULT NULL,
  `idc_id` varchar(64) DEFAULT NULL,
  `storage_id` int NOT NULL,
  `image_type` tinyint NOT NULL,
  `volume_index` smallint NOT NULL,
  `endpoint` varchar(128) DEFAULT NULL,
  `description` varchar(128) DEFAULT NULL,
  `deploy_type` tinyint DEFAULT NULL,
  `size` int DEFAULT NULL,
  `version` varchar(128) DEFAULT NULL,
  `mount_status` tinyint DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `attach_time` datetime DEFAULT NULL,
  `detach_time` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `volume_id` (`volume_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for t_iaas_image_info
-- ----------------------------
DROP TABLE IF EXISTS `t_iaas_image_info`;
CREATE TABLE `t_iaas_image_info` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键编码',
  `image_id` varchar(128) NOT NULL,
  `image_name` varchar(255) NOT NULL,
  `image_version` varchar(64) NOT NULL,
  `image_utime` datetime(3) DEFAULT NULL,
  `image_star` bigint DEFAULT '0',
  `image_tags` json DEFAULT NULL,
  `image_os_version` varchar(128) DEFAULT NULL,
  `python_version` varchar(64) DEFAULT NULL,
  `cuda_version` varchar(64) DEFAULT NULL,
  `lib_versions` json DEFAULT NULL,
  `model_list` json DEFAULT NULL,
  `model_desc_markdown` text,
  `ports` varchar(255) DEFAULT NULL,
  `login_info_id` bigint unsigned DEFAULT '0',
  `tenant_account` varchar(191) DEFAULT NULL,
  `create_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '最近更新时间',
  `modify_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '最后修改时间',
  `model_desc_short` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10043 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for t_iaas_image_login_info
-- ----------------------------
DROP TABLE IF EXISTS `t_iaas_image_login_info`;
CREATE TABLE `t_iaas_image_login_info` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `rdp_type` int DEFAULT '0' COMMENT '0:unknown 1:ssh 2:mstsc 3:vncviewer 4:vncviewer加固',
  `rdp_port` int DEFAULT '0' COMMENT '如vnc或者windows远程桌面的端口',
  `rdp_user` varchar(255) DEFAULT NULL COMMENT '如vnc或者windows远程桌面的账户',
  `rdp_paas` varchar(255) DEFAULT NULL COMMENT '如vnc或者windows远程桌面的密码',
  `ssh_port` int DEFAULT '0' COMMENT 'ssh的端口',
  `ssh_user` varchar(255) DEFAULT NULL COMMENT 'ssh的账户',
  `ssh_paas` varchar(255) DEFAULT NULL COMMENT 'ssh的密码',
  `salt` varchar(255) NOT NULL COMMENT 'salt',
  `create_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '最近更新时间',
  `modify_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '最后修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='镜像登录信息表';

SET FOREIGN_KEY_CHECKS = 1;
