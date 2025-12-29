/*
 Navicat Premium Data Transfer

 Source Server         : IaaS pro
 Source Server Type    : MySQL
 Source Server Version : 80034 (8.0.34)
 Source Host           : iaas-center.mysql.rds.aliyuncs.com:3306
 Source Schema         : iaas_compute

 Target Server Type    : MySQL
 Target Server Version : 80034 (8.0.34)
 File Encoding         : 65001

 Date: 29/12/2025 11:06:20
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for account_info
-- ----------------------------
DROP TABLE IF EXISTS `account_info`;
CREATE TABLE `account_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int DEFAULT NULL,
  `account_id` int DEFAULT NULL,
  `access_key` varchar(128) DEFAULT NULL,
  `secret_key` varchar(128) DEFAULT NULL,
  `status` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `access_key_unique` (`access_key`),
  KEY `uid` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for area_info
-- ----------------------------
DROP TABLE IF EXISTS `area_info`;
CREATE TABLE `area_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `area_id` varchar(128) DEFAULT NULL,
  `region_id` varchar(128) DEFAULT NULL,
  `area_name` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `area_id_key` (`area_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for baremetal_image
-- ----------------------------
DROP TABLE IF EXISTS `baremetal_image`;
CREATE TABLE `baremetal_image` (
  `id` int NOT NULL AUTO_INCREMENT,
  `baremetal_image_id` varchar(128) NOT NULL,
  `type` varchar(64) DEFAULT NULL,
  `image_name` varchar(128) DEFAULT NULL,
  `md5` varchar(128) DEFAULT NULL,
  `oss_url` varchar(256) DEFAULT NULL,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for baremetal_operation_job
-- ----------------------------
DROP TABLE IF EXISTS `baremetal_operation_job`;
CREATE TABLE `baremetal_operation_job` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int DEFAULT NULL,
  `job_id` varchar(128) DEFAULT NULL,
  `task_id` varchar(128) DEFAULT NULL,
  `state` varchar(128) DEFAULT NULL,
  `err_msg` varchar(8192) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `job_params` json DEFAULT NULL,
  `start_time` datetime(6) DEFAULT NULL,
  `end_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `job_type` varchar(256) DEFAULT NULL,
  `target` varchar(2048) DEFAULT NULL,
  `idcid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '机房ID',
  `timeout_time` datetime DEFAULT NULL COMMENT '超时时间',
  `hypervisor_id` varchar(256) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `exec_log` json DEFAULT NULL,
  `retry_count` int DEFAULT '0',
  `deploy_data_image_state` varchar(256) DEFAULT NULL,
  `is_deploy_data_image` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_job_key_unique` (`job_id`),
  KEY `task_id` (`task_id`),
  KEY `idx_job_type` (`job_type`) USING BTREE,
  KEY `idx_task_state` (`state`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5781554 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for baremetal_operation_job_20251208
-- ----------------------------
DROP TABLE IF EXISTS `baremetal_operation_job_20251208`;
CREATE TABLE `baremetal_operation_job_20251208` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int DEFAULT NULL,
  `job_id` varchar(128) DEFAULT NULL,
  `task_id` varchar(128) DEFAULT NULL,
  `state` varchar(128) DEFAULT NULL,
  `err_msg` varchar(8192) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `job_params` json DEFAULT NULL,
  `start_time` datetime(6) DEFAULT NULL,
  `end_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `job_type` varchar(256) DEFAULT NULL,
  `target` varchar(2048) DEFAULT NULL,
  `idcid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '机房ID',
  `timeout_time` datetime DEFAULT NULL COMMENT '超时时间',
  `hypervisor_id` varchar(256) DEFAULT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `exec_log` json DEFAULT NULL,
  `retry_count` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_job_key_unique` (`job_id`),
  KEY `task_id` (`task_id`),
  KEY `idx_job_type` (`job_type`) USING BTREE,
  KEY `idx_task_state` (`state`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5402006 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for baremetal_operation_task
-- ----------------------------
DROP TABLE IF EXISTS `baremetal_operation_task`;
CREATE TABLE `baremetal_operation_task` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int DEFAULT NULL,
  `task_id` varchar(128) DEFAULT NULL,
  `trace_id` varchar(128) DEFAULT NULL,
  `request_id` varchar(128) DEFAULT NULL,
  `total_count` int DEFAULT NULL,
  `success_count` int DEFAULT NULL,
  `failed_count` int DEFAULT NULL,
  `state` varchar(128) DEFAULT NULL,
  `err_msg` varchar(8192) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `task_params` json DEFAULT NULL,
  `start_time` datetime(6) DEFAULT NULL,
  `end_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `task_type` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_task_key_unique` (`task_id`),
  KEY `request_id` (`request_id`),
  KEY `idx_trace_id` (`trace_id` DESC) USING BTREE,
  KEY `idx_task_state` (`state`) USING BTREE,
  KEY `idx_task_type` (`task_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=849428 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for baremetal_operation_task_20251208
-- ----------------------------
DROP TABLE IF EXISTS `baremetal_operation_task_20251208`;
CREATE TABLE `baremetal_operation_task_20251208` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int DEFAULT NULL,
  `task_id` varchar(128) DEFAULT NULL,
  `trace_id` varchar(128) DEFAULT NULL,
  `request_id` varchar(128) DEFAULT NULL,
  `total_count` int DEFAULT NULL,
  `success_count` int DEFAULT NULL,
  `failed_count` int DEFAULT NULL,
  `state` varchar(128) DEFAULT NULL,
  `err_msg` varchar(8192) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `task_params` json DEFAULT NULL,
  `start_time` datetime(6) DEFAULT NULL,
  `end_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_time` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '最后更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `task_type` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_task_key_unique` (`task_id`),
  KEY `request_id` (`request_id`),
  KEY `idx_trace_id` (`trace_id` DESC) USING BTREE,
  KEY `idx_task_state` (`state`) USING BTREE,
  KEY `idx_task_type` (`task_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=807673 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for baremetal_proxy_association_entities
-- ----------------------------
DROP TABLE IF EXISTS `baremetal_proxy_association_entities`;
CREATE TABLE `baremetal_proxy_association_entities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `proxy_id` varchar(128) DEFAULT NULL,
  `entity_id` varchar(256) DEFAULT NULL,
  `idc_id` varchar(128) DEFAULT NULL,
  `entity_type` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `proxy_id` (`proxy_id`,`entity_id`),
  KEY `idc_id` (`idc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for baremetal_proxy_info
-- ----------------------------
DROP TABLE IF EXISTS `baremetal_proxy_info`;
CREATE TABLE `baremetal_proxy_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `proxy_id` varchar(128) DEFAULT NULL,
  `proxy_name` varchar(128) DEFAULT NULL,
  `proxy_address` varchar(256) DEFAULT NULL,
  `proxy_port` int DEFAULT NULL,
  `idc_id` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `proxy_info_key_unique` (`proxy_id`),
  KEY `idc_id` (`idc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for baremetal_send_proxy_task
-- ----------------------------
DROP TABLE IF EXISTS `baremetal_send_proxy_task`;
CREATE TABLE `baremetal_send_proxy_task` (
  `id` int NOT NULL AUTO_INCREMENT,
  `task_id` varchar(128) DEFAULT NULL,
  `content` json DEFAULT NULL,
  `status` varchar(128) DEFAULT NULL,
  `idc_id` varchar(128) DEFAULT NULL,
  `proxy_id` varchar(128) DEFAULT NULL,
  `retry_count` int DEFAULT NULL,
  `msg` text,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_task_key_unique` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for cabinet_info
-- ----------------------------
DROP TABLE IF EXISTS `cabinet_info`;
CREATE TABLE `cabinet_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idc_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机房id',
  `cabinet_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机柜id',
  `cabinet_spec` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '机柜型号',
  `rated_power` int DEFAULT NULL COMMENT '额定功率',
  `machine_num` int DEFAULT NULL COMMENT '可容纳物理机数量',
  `status` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '状态',
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `modify_time` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=143 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for cmd_idc_mapping
-- ----------------------------
DROP TABLE IF EXISTS `cmd_idc_mapping`;
CREATE TABLE `cmd_idc_mapping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cmdb_idc_id` varchar(128) NOT NULL,
  `idc_id` varchar(128) NOT NULL,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for event_association_entities
-- ----------------------------
DROP TABLE IF EXISTS `event_association_entities`;
CREATE TABLE `event_association_entities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_id` varchar(128) DEFAULT NULL,
  `idc_id` varchar(128) DEFAULT NULL,
  `entity_id` varchar(256) DEFAULT NULL,
  `entity_type` varchar(128) DEFAULT NULL,
  `proxy_id` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `event_association_entities_key_unique` (`event_id`,`entity_id`),
  KEY `event_id` (`event_id`),
  KEY `proxy_id` (`proxy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for event_info
-- ----------------------------
DROP TABLE IF EXISTS `event_info`;
CREATE TABLE `event_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_id` varchar(128) DEFAULT NULL,
  `event_type` varchar(256) DEFAULT NULL,
  `collect_interval` int DEFAULT NULL,
  `report_interval` int DEFAULT NULL,
  `report_type` varchar(128) DEFAULT NULL,
  `entity_type` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `event_info_key_unique` (`event_id`),
  KEY `event_type` (`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for failure_resource_pool
-- ----------------------------
DROP TABLE IF EXISTS `failure_resource_pool`;
CREATE TABLE `failure_resource_pool` (
  `id` int NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(128) DEFAULT NULL,
  `hypervisor_id` varchar(128) DEFAULT NULL,
  `machine_id` varchar(128) DEFAULT NULL,
  `map_instance_id` varchar(128) DEFAULT NULL,
  `pci` varchar(128) DEFAULT NULL,
  `idc_id` varchar(128) DEFAULT NULL,
  `ipmi` varchar(128) DEFAULT NULL,
  `cloud_vendor` varchar(128) DEFAULT NULL,
  `spec_id` varchar(128) DEFAULT NULL,
  `machine_spec_id` varchar(128) DEFAULT NULL,
  `failure_type` varchar(128) DEFAULT NULL,
  `failure_range` int DEFAULT NULL,
  `failure_description` text,
  `system_ip` varchar(128) DEFAULT NULL,
  `pcf_node` varchar(128) DEFAULT NULL,
  `status` varchar(128) DEFAULT NULL,
  `support_instance_type` varchar(128) DEFAULT NULL,
  `supplier_sn` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `instance_id` (`instance_id`),
  KEY `hypervisor_id` (`hypervisor_id`),
  KEY `map_instance_id` (`map_instance_id`),
  KEY `idc_id` (`idc_id`),
  KEY `cloud_vendor` (`cloud_vendor`),
  KEY `spec_id` (`spec_id`),
  KEY `failure_range` (`failure_range`),
  KEY `support_instance_type` (`support_instance_type`),
  KEY `supplier_sn` (`supplier_sn`)
) ENGINE=InnoDB AUTO_INCREMENT=2069 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for failure_resource_pool_association_report_work_order_detail
-- ----------------------------
DROP TABLE IF EXISTS `failure_resource_pool_association_report_work_order_detail`;
CREATE TABLE `failure_resource_pool_association_report_work_order_detail` (
  `id` int NOT NULL AUTO_INCREMENT,
  `resource_pool_id` int DEFAULT NULL,
  `sub_work_order_id` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `resource_pool_id` (`resource_pool_id`)
) ENGINE=InnoDB AUTO_INCREMENT=577 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for failure_resource_tag
-- ----------------------------
DROP TABLE IF EXISTS `failure_resource_tag`;
CREATE TABLE `failure_resource_tag` (
  `id` int NOT NULL AUTO_INCREMENT,
  `resource_pool_id` int DEFAULT NULL,
  `tag` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `resource_pool_id` (`resource_pool_id`)
) ENGINE=InnoDB AUTO_INCREMENT=597 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for firewall
-- ----------------------------
DROP TABLE IF EXISTS `firewall`;
CREATE TABLE `firewall` (
  `id` int NOT NULL AUTO_INCREMENT,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `device_type` varchar(255) NOT NULL COMMENT '设备类型 RG-WALL 1600-M5800E',
  `firewall_id` varchar(255) NOT NULL,
  `idc_id` varchar(255) NOT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `raw_data` text COMMENT '加密后的认证数据',
  `host` varchar(255) NOT NULL,
  `vdom` varchar(255) NOT NULL COMMENT '虚拟域',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for graphics_card_inventory
-- ----------------------------
DROP TABLE IF EXISTS `graphics_card_inventory`;
CREATE TABLE `graphics_card_inventory` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增主键ID',
  `node_id` int DEFAULT NULL COMMENT 'node节点ID',
  `audio_address` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '声卡ID',
  `graphics_address` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '显卡ID',
  `inspection_status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '巡检状态',
  `inspection_time` datetime(6) DEFAULT NULL COMMENT '巡检时间',
  `inspection_err_msg` text COLLATE utf8mb4_unicode_ci COMMENT '巡检异常信息',
  `status` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '库存上报状态',
  `op_status` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '机器标记状态',
  `on_sale` tinyint DEFAULT NULL COMMENT '机器上架状态',
  `support_instance_types` text COLLATE utf8mb4_unicode_ci COMMENT '机器环境类型',
  `idc_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '机房ID',
  `remark` text COLLATE utf8mb4_unicode_ci COMMENT '机器备注',
  `gpu_num` int DEFAULT NULL COMMENT '机器卡数',
  `hypervisor_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'hypervisor ID',
  `instance_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '实例ID',
  `gpu_op_status` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '显卡标记状态',
  `gpu_remark` text COLLATE utf8mb4_unicode_ci COMMENT '显卡备注',
  `last_refresh_time` datetime(6) DEFAULT NULL COMMENT '库存上报时间',
  `map_idc_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '供应商机房ID',
  `machine_spec_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '机器规格',
  `map_spec_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '供应商机器规格',
  `map_hypervisor_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '供应商机器ID',
  `machine_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '机器ID',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_hypervisor_id` (`hypervisor_id`),
  KEY `idx_instance_id` (`instance_id`),
  KEY `idx_graphics_address` (`graphics_address`),
  KEY `idx_idc_id` (`idc_id`),
  KEY `idx_machine_spec_id` (`machine_spec_id`),
  KEY `idx_status` (`status`),
  KEY `idx_op_status` (`op_status`),
  KEY `idx_on_sale` (`on_sale`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=26062 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='显卡库存信息表(iaas控制台使用)';

-- ----------------------------
-- Table structure for graphics_card_inventory_task_locks
-- ----------------------------
DROP TABLE IF EXISTS `graphics_card_inventory_task_locks`;
CREATE TABLE `graphics_card_inventory_task_locks` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '锁标识符，如：gpu-sync-task',
  `process_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '进程ID，用于标识哪个进程持有锁',
  `acquired_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '获取锁的时间',
  `expires_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '锁过期时间，超过此时间锁自动失效',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_expires_at` (`expires_at`) COMMENT '过期时间索引，用于清理过期锁'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='显卡库存同步任务锁表，防止多实例并发执行(iaas控制台使用)';

-- ----------------------------
-- Table structure for hypervisor_info
-- ----------------------------
DROP TABLE IF EXISTS `hypervisor_info`;
CREATE TABLE `hypervisor_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `map_account_id` int DEFAULT NULL,
  `hypervisor_id` varchar(128) DEFAULT NULL,
  `map_hypervisor_id` varchar(128) DEFAULT NULL,
  `map_instance_name` varchar(128) DEFAULT NULL,
  `type` varchar(64) DEFAULT NULL,
  `idc_id` varchar(128) DEFAULT NULL,
  `ip` varchar(128) DEFAULT NULL,
  `machine_id` varchar(128) DEFAULT NULL,
  `hardware_id` varchar(128) DEFAULT NULL,
  `status` varchar(128) DEFAULT NULL,
  `state` varchar(128) DEFAULT NULL,
  `resource_info` varchar(128) DEFAULT NULL,
  `namespace` varchar(128) DEFAULT NULL,
  `rom_image_id` varchar(128) DEFAULT NULL,
  `cloud_vendor` varchar(128) DEFAULT NULL,
  `node_name` varchar(256) DEFAULT NULL,
  `latest_action` varchar(128) DEFAULT NULL,
  `create_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `modify_time` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `deleted_at` timestamp NULL DEFAULT NULL,
  `icmp_status` varchar(100) DEFAULT NULL,
  `is_managed` tinyint(1) DEFAULT '1',
  `cap_bandwidth` tinyint(1) DEFAULT '0',
  `is_check_report_state` tinyint(1) DEFAULT '0',
  `ipv6_address` varchar(256) DEFAULT NULL,
  `ip_type` varchar(128) DEFAULT NULL,
  `last_instance_id` varchar(128) DEFAULT NULL,
  `flow_id` varchar(128) DEFAULT NULL,
  `mac` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hypervisor_id_unique` (`hypervisor_id`),
  UNIQUE KEY `unique_map_hypervisor_id` (`machine_id`,`map_hypervisor_id`),
  KEY `namespace` (`namespace`),
  KEY `idx_machine_id_deleted_at` (`machine_id`,`deleted_at`) USING BTREE,
  KEY `hypervisor_info_state_IDX` (`state`) USING BTREE,
  KEY `idx_is_managed` (`is_managed`) USING BTREE,
  KEY `idx_cap_bandwidth` (`cap_bandwidth`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=423626 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for iaas_allocation
-- ----------------------------
DROP TABLE IF EXISTS `iaas_allocation`;
CREATE TABLE `iaas_allocation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int DEFAULT NULL,
  `provider_id` int DEFAULT NULL,
  `consumer_id` varchar(128) DEFAULT NULL,
  `used` int DEFAULT NULL,
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `pci_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `idc_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `modify_time` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for iaas_hardware_info
-- ----------------------------
DROP TABLE IF EXISTS `iaas_hardware_info`;
CREATE TABLE `iaas_hardware_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hardware_id` varchar(128) DEFAULT NULL,
  `hardware_version` varchar(256) DEFAULT NULL,
  `storage_gb` int DEFAULT NULL,
  `memory_mb` int DEFAULT NULL,
  `vcpus` int DEFAULT NULL,
  `desc` varchar(256) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `hardware_id_key` (`hardware_id`),
  UNIQUE KEY `hardware_version_key` (`hardware_version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for iaas_inventory
-- ----------------------------
DROP TABLE IF EXISTS `iaas_inventory`;
CREATE TABLE `iaas_inventory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int DEFAULT NULL,
  `traits_id` int DEFAULT NULL,
  `provider_id` int DEFAULT NULL,
  `total` int DEFAULT NULL,
  `reserved` int DEFAULT NULL,
  `min_unit` int DEFAULT NULL,
  `max_unit` int DEFAULT NULL,
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `pci_address` varchar(255) DEFAULT NULL,
  `modify_time` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for iaas_provider_traits
-- ----------------------------
DROP TABLE IF EXISTS `iaas_provider_traits`;
CREATE TABLE `iaas_provider_traits` (
  `id` int NOT NULL AUTO_INCREMENT,
  `provider_id` int DEFAULT NULL,
  `traits_id` int DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for iaas_region_cache
-- ----------------------------
DROP TABLE IF EXISTS `iaas_region_cache`;
CREATE TABLE `iaas_region_cache` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idc_id` varchar(128) DEFAULT NULL,
  `address` varchar(128) DEFAULT NULL,
  `queue_address` varchar(128) DEFAULT NULL,
  `port` int DEFAULT NULL,
  `queue_port` int DEFAULT NULL,
  `storage_address` varchar(256) DEFAULT NULL,
  `storage_secret` varchar(256) DEFAULT NULL,
  `storage_user` varchar(256) DEFAULT NULL,
  `remark` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idc_id` (`idc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for iaas_resource_class
-- ----------------------------
DROP TABLE IF EXISTS `iaas_resource_class`;
CREATE TABLE `iaas_resource_class` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `desc` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `modify_time` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for iaas_resource_provider
-- ----------------------------
DROP TABLE IF EXISTS `iaas_resource_provider`;
CREATE TABLE `iaas_resource_provider` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `desc` varchar(128) DEFAULT NULL,
  `generation` int DEFAULT NULL,
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `hypervisor_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `idc_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `last_refresh_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `modify_time` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for iaas_service
-- ----------------------------
DROP TABLE IF EXISTS `iaas_service`;
CREATE TABLE `iaas_service` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `script_repo` varchar(256) DEFAULT NULL,
  `vars` json DEFAULT NULL,
  `main_name` varchar(128) DEFAULT NULL,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for iaas_service_apply
-- ----------------------------
DROP TABLE IF EXISTS `iaas_service_apply`;
CREATE TABLE `iaas_service_apply` (
  `id` int NOT NULL AUTO_INCREMENT,
  `destination` varchar(128) NOT NULL,
  `iaas_service_name` varchar(128) NOT NULL,
  `iaas_service_version` varchar(128) NOT NULL,
  `status` varchar(128) DEFAULT NULL,
  `destination_type` varchar(128) DEFAULT NULL,
  `vars` json DEFAULT NULL,
  `promethues_instance` varchar(256) DEFAULT NULL,
  `current_version` varchar(128) DEFAULT NULL,
  `job_id` varchar(128) DEFAULT NULL,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for iaas_service_version
-- ----------------------------
DROP TABLE IF EXISTS `iaas_service_version`;
CREATE TABLE `iaas_service_version` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  `iaas_service_name` varchar(128) NOT NULL,
  `arch` varchar(128) DEFAULT NULL,
  `version` varchar(128) DEFAULT NULL,
  `description` varchar(256) DEFAULT NULL,
  `oss_md5` varchar(128) DEFAULT NULL,
  `oss_url` varchar(256) DEFAULT NULL,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for iaas_traits
-- ----------------------------
DROP TABLE IF EXISTS `iaas_traits`;
CREATE TABLE `iaas_traits` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) DEFAULT NULL,
  `desc` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for idc_info
-- ----------------------------
DROP TABLE IF EXISTS `idc_info`;
CREATE TABLE `idc_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idc_id` varchar(128) DEFAULT NULL,
  `area_id` varchar(128) DEFAULT NULL,
  `idc_name` varchar(128) DEFAULT NULL,
  `status` tinyint DEFAULT NULL,
  `cloud_vendor` varchar(128) DEFAULT NULL,
  `map_idc_id` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `compute_agent_endpoits` json DEFAULT NULL,
  `baremetal_proxy_endpoint` json DEFAULT NULL,
  `map_account_id` int DEFAULT NULL,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `supplier` varchar(100) DEFAULT NULL COMMENT '供应商(Supplier)： 表示所属厂商, Ali：阿里云, CMCC：移动云, Baidu：百度云, VE：火山云（字节旗下）',
  `owner_type` varchar(100) DEFAULT NULL COMMENT '表示机房资源的所有权类型,自建：DC, 共建：Collaboration, 租赁：Rental',
  `uidc` varchar(100) DEFAULT NULL COMMENT '表示IaaS、云游戏部门对机房定义的统一编号，用于公司内各部门进行对齐，降低沟通成本',
  `cidc` varchar(100) DEFAULT NULL COMMENT 'CIDC(物理机房名称)：标识机房真实物理机房，为中文名',
  `province` varchar(100) DEFAULT NULL COMMENT '省份',
  `city` varchar(100) DEFAULT NULL COMMENT '城市',
  `tag` varchar(255) DEFAULT NULL COMMENT 'idc的标签字段',
  `pool_id` varchar(256) DEFAULT NULL,
  `monitor_enabled` tinyint DEFAULT '0' COMMENT '机房是否纳入监控，1为纳入监控，0为不纳入监控',
  `iaas10_region_id` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idc_id_key` (`idc_id`),
  KEY `idx_region_id` (`iaas10_region_id`)
) ENGINE=InnoDB AUTO_INCREMENT=89071 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for instance_info
-- ----------------------------
DROP TABLE IF EXISTS `instance_info`;
CREATE TABLE `instance_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `map_account_id` int DEFAULT NULL,
  `instance_id` varchar(128) DEFAULT NULL,
  `instance_name` varchar(128) DEFAULT NULL,
  `map_instance_id` varchar(128) DEFAULT NULL,
  `hypervisor_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '对于 instance_resource_manager_mode 字段是 compute ，且实例状态是关机状态，hypervisor_id 字段不准确（本质是空）',
  `map_hypervisor_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '对于 instance_resource_manager_mode 字段是 compute ，且实例状态是关机状态，map_hypervisor_id 字段不准确（本质是空）',
  `keypair_id` varchar(128) DEFAULT NULL,
  `hostname` varchar(128) DEFAULT NULL,
  `cloud_vendor` varchar(128) DEFAULT NULL,
  `user_data_id` int DEFAULT NULL,
  `root_device_name` varchar(128) DEFAULT NULL,
  `ip` varchar(128) DEFAULT NULL,
  `idc_id` varchar(128) DEFAULT NULL,
  `type` varchar(64) DEFAULT NULL,
  `spec_id` varchar(128) DEFAULT NULL,
  `is_using` tinyint(1) DEFAULT '0',
  `instance_state` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `task_state` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `latest_task_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `system_image_id` varchar(128) DEFAULT NULL,
  `data_image_id` varchar(128) DEFAULT NULL,
  `namespace` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `last_refresh_time` datetime(6) DEFAULT NULL,
  `index` tinyint DEFAULT NULL,
  `mac_address` varchar(255) DEFAULT NULL COMMENT 'mac地址',
  `modify_time` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `public_ip_info` json DEFAULT NULL,
  `aic_resource_version` varchar(100) DEFAULT NULL COMMENT '对应k8s resource version',
  `ak_id` int DEFAULT NULL COMMENT 'ak表主键id',
  `admin_mod` int DEFAULT NULL COMMENT '0-default 1-超管模式 2-恢复模式',
  `inner_report_state` int DEFAULT '0' COMMENT '实例内agent上报:0 未上报,1 上报运行中,2 上报实例异常',
  `map_instance_name` varchar(256) DEFAULT NULL,
  `inner_report_state_utime` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `instance_resource_manager_mode` int NOT NULL DEFAULT '0' COMMENT '实例运营模式: 两种类型  NORMAL(1),  COMPUTE(2), NORMAL 或者是 DEAFULT（0）模式除非释放否则会一直占用资源， COMPUTE 模式，关机就会释放计算资源,开机后则可能重新占用',
  `ipv6_address` varchar(256) DEFAULT NULL,
  `ip_type` varchar(128) DEFAULT NULL,
  `instance_spec_desc` text COMMENT '实例规格描述',
  `inspection_err` text COMMENT '最近一次巡检失败信息',
  `inspection_time` datetime DEFAULT NULL COMMENT '最近一次巡检完成时间',
  `inspection_fault_type` varchar(128) DEFAULT NULL COMMENT '最近一次巡检故障类型',
  `is_wait_sync` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `instance_id_unique` (`instance_id`) USING BTREE,
  UNIQUE KEY `unique_map_instance_id` (`map_hypervisor_id`,`map_instance_id`),
  KEY `idc_id` (`idc_id`),
  KEY `hypervisor_id` (`hypervisor_id`),
  KEY `map_account_id` (`map_account_id`),
  KEY `namespace` (`namespace`),
  KEY `offline_query_time` (`last_refresh_time`) USING BTREE,
  KEY `offline_query_other` (`cloud_vendor`,`type`,`instance_state`) USING BTREE,
  KEY `instance_spec_index` (`spec_id`),
  KEY `inx_map_instance_id` (`map_instance_id`) USING BTREE,
  KEY `idx_inner_report_state_utime` (`inner_report_state_utime`) USING BTREE,
  KEY `idx_mac_address` (`mac_address`),
  KEY `idx_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=19420350 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for instance_spec_info
-- ----------------------------
DROP TABLE IF EXISTS `instance_spec_info`;
CREATE TABLE `instance_spec_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `spec_id` varchar(128) DEFAULT NULL,
  `spec_name` varchar(128) DEFAULT NULL,
  `resolution` varchar(128) DEFAULT NULL,
  `frequency` varchar(128) DEFAULT NULL,
  `arch` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `cpu` int DEFAULT NULL,
  `memory` int DEFAULT NULL,
  `gpu` int DEFAULT NULL,
  `root_device_size` int DEFAULT NULL,
  `is_public` tinyint(1) DEFAULT '0',
  `description` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `spec` tinyint DEFAULT NULL COMMENT '几开',
  `instance_type` varchar(64) DEFAULT NULL,
  `temp` varchar(128) DEFAULT NULL,
  `cpu_model` varchar(64) DEFAULT NULL,
  `gpu_model` varchar(64) DEFAULT NULL,
  `cpu_model_full_name` varchar(128) DEFAULT NULL,
  `gpu_vendor_id` varchar(64) DEFAULT NULL,
  `gpu_device_id` varchar(64) DEFAULT NULL,
  `cpu_io` tinyint DEFAULT NULL,
  `rated_power` int DEFAULT NULL COMMENT '额定功率',
  `vendor_params` json DEFAULT NULL COMMENT '供应商参数',
  `month_price` int DEFAULT NULL COMMENT '按月刊例价，单位：分',
  `day_price` int DEFAULT NULL COMMENT '按日刊例价，单位：分',
  `map_spec_id` varchar(255) DEFAULT NULL COMMENT '供应商规格id',
  `gpu_model_full_name` varchar(128) NOT NULL DEFAULT '',
  `machine_type` varchar(128) DEFAULT NULL COMMENT '实例规格分配的时候指定的机器类型',
  `instance_spec_alias` varchar(100) DEFAULT NULL COMMENT '实例规格别名，用于统计',
  `category` varchar(255) DEFAULT NULL COMMENT '类别，可以用来自区分实例的业务类型\r\n(用来区分机器的业务用途，比如CPU、GPU、Arm、Storage)',
  `tag` varchar(255) DEFAULT NULL COMMENT '可以用来添加自定义字段',
  `instance_api_type` varchar(128) NOT NULL COMMENT '创建实例调用API类型，表示实例是那些 渠道的 SDK 创建出来的，备注未必跟 idc 的 supplier 一致,',
  `supplier` varchar(100) DEFAULT NULL COMMENT '供应商(Supplier)： 表示所属厂商, Ali：阿里云, CMCC：移动云, Baidu：百度云, VE：火山云（字节旗下）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `spec_id_unique` (`spec_id`),
  KEY `type` (`arch`)
) ENGINE=InnoDB AUTO_INCREMENT=9266 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for instance_type_info
-- ----------------------------
DROP TABLE IF EXISTS `instance_type_info`;
CREATE TABLE `instance_type_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(64) DEFAULT NULL,
  `description` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `instance_type_unique` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for keypair_info
-- ----------------------------
DROP TABLE IF EXISTS `keypair_info`;
CREATE TABLE `keypair_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int DEFAULT NULL,
  `keypair_id` varchar(128) DEFAULT NULL,
  `public_key` varchar(256) DEFAULT NULL,
  `private_key` varchar(256) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `keypair_id_unique` (`keypair_id`),
  UNIQUE KEY `keypair_id_key` (`uid`,`keypair_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for machine_info
-- ----------------------------
DROP TABLE IF EXISTS `machine_info`;
CREATE TABLE `machine_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `machine_id` varchar(128) DEFAULT NULL,
  `idc_id` varchar(128) DEFAULT NULL,
  `ipmi_address` varchar(128) DEFAULT NULL,
  `cmdb_id` varchar(128) DEFAULT NULL,
  `status` varchar(128) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(6) DEFAULT NULL,
  `ota_info_id` varchar(128) DEFAULT NULL COMMENT 'arm 用硬件版本等',
  `architecture` varchar(128) DEFAULT NULL COMMENT '架构 x86 arm pcf',
  `sub` varchar(128) DEFAULT NULL COMMENT '板卡刀片',
  `core` varchar(128) DEFAULT NULL COMMENT 'arm板卡节点,pcf端游写成端口，0000代表传统服务器暂不指定',
  `supplier` varchar(128) DEFAULT NULL COMMENT '供应商 ens dc baidu等',
  `supplier_sn` varchar(256) DEFAULT NULL COMMENT '外部供应商实例ID，内部sn',
  `vm_ips` json DEFAULT NULL COMMENT '虚拟机IP范围json,[]string',
  `machie_type` varchar(128) DEFAULT NULL COMMENT '机器类型 arm pcf x86server',
  `modify_time` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `ipmi_user` varchar(256) DEFAULT NULL,
  `ipmi_passwd` varchar(256) DEFAULT NULL,
  `ipmi_version` varchar(100) DEFAULT NULL COMMENT 'lanplus代表v2.0,不填默认v1',
  `power_status` varchar(100) DEFAULT NULL,
  `cabinet_id` varchar(128) DEFAULT NULL,
  `machine_spec_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '机器型号id',
  `pxe_mac` varchar(128) DEFAULT NULL COMMENT 'pxe启动dhcp网卡mac地址,对应cmdb业务mac',
  `enroll_task_id` varchar(128) DEFAULT NULL COMMENT '注册时的任务id',
  `ironic_state` json DEFAULT NULL COMMENT 'ironic上报状态',
  `manage_state` varchar(128) DEFAULT NULL COMMENT '裸金属管理状态',
  `business_mac` varchar(128) DEFAULT NULL COMMENT '业务口mac',
  `is_managed` tinyint(1) DEFAULT '1',
  `cap_bandwidth` tinyint(1) DEFAULT '0',
  `pxe_networkcard_vlan` varchar(128) DEFAULT NULL,
  `ipmi_port_or_slot` varchar(128) DEFAULT NULL,
  `manager_driver_type` varchar(128) DEFAULT NULL COMMENT '裸金属机器的管控时候的 driver 类型，主要有 DRIVER_TYPE_IPMI， DRIVER_TYPE_IRONIC（ironic）， DRIVER_TYPE_BOX（宁夏盒子）等类型',
  `support_instance_type` varchar(128) DEFAULT NULL COMMENT '支持的分配类型列表, INSTANCE_TYPE_BARE_METAL_DISKLESS,INSTANCE_TYPE_BARE_METAL, INSTANCE_TYPE_KVM 之类的',
  `machine_report_time` datetime DEFAULT NULL COMMENT '机器上报时间',
  `machine_spec_desc` text COMMENT '机器规格描述',
  `is_register` tinyint(1) DEFAULT '0',
  `is_inspection` tinyint(1) DEFAULT '0',
  `is_manager_server` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `machine_id_unique` (`machine_id`),
  UNIQUE KEY `unique_supplier_sn` (`idc_id`,`supplier_sn`),
  KEY `idx_supplier_sn` (`supplier_sn`)
) ENGINE=InnoDB AUTO_INCREMENT=9611171 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for machine_spec_info
-- ----------------------------
DROP TABLE IF EXISTS `machine_spec_info`;
CREATE TABLE `machine_spec_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `machine_spec_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `machine_spec_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `disk` int DEFAULT NULL COMMENT '单位Mb',
  `memory` int DEFAULT NULL COMMENT '单位Mb',
  `cpu_vendor` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `cpu_model` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `cpu_cores` int DEFAULT NULL,
  `gpu_vendor_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `gpu_device_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `gpu_num` int DEFAULT NULL,
  `status` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `modify_time` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `gpu_model` varchar(256) DEFAULT NULL,
  `map_spec_id` varchar(256) DEFAULT NULL,
  `vendor_params` json DEFAULT NULL,
  `arch` varchar(256) DEFAULT NULL,
  `cpu_info` json DEFAULT NULL,
  `gpu_info` json DEFAULT NULL,
  `asset_spec` varchar(100) DEFAULT NULL COMMENT '用于对应 CMDB 上的资产规格，如 8U4N-i5-3060',
  `machine_spec_alias` varchar(100) DEFAULT NULL COMMENT '机器规格别名，统计使用',
  `machine_type` varchar(256) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL COMMENT '类别，可以用来自区分实例的业务类型\r\n(用来区分机器的业务用途，比如CPU、GPU、Arm、Storage)',
  `tag` varchar(255) DEFAULT NULL COMMENT '可以用来添加自定义字段',
  `supplier` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '供应商(Supplier)： 表示所属厂商, Ali：阿里云, CMCC：移动云, Baidu：百度云, VE：火山云（字节旗下）',
  PRIMARY KEY (`id`),
  UNIQUE KEY `machine_spec_id_unique` (`machine_spec_id`,`deleted_at`) USING BTREE,
  KEY `machine_map_spec_index` (`map_spec_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100093 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for manager_base_image
-- ----------------------------
DROP TABLE IF EXISTS `manager_base_image`;
CREATE TABLE `manager_base_image` (
  `id` int NOT NULL AUTO_INCREMENT,
  `image_id` varchar(128) DEFAULT NULL,
  `instance_id` varchar(256) DEFAULT NULL,
  `instance_type` varchar(256) DEFAULT NULL,
  `machine_type` varchar(256) DEFAULT NULL,
  `cloud_vendor` varchar(256) DEFAULT NULL,
  `spec_id` varchar(256) DEFAULT NULL,
  `write_mode` varchar(256) DEFAULT NULL,
  `image_structure` varchar(256) DEFAULT NULL,
  `disk_type` varchar(256) DEFAULT NULL,
  `password` varchar(256) DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `instance_id` (`instance_id`),
  KEY `image_id` (`image_id`),
  KEY `instance_type` (`instance_type`),
  KEY `machine_type` (`machine_type`),
  KEY `cloud_vendor` (`cloud_vendor`),
  KEY `spec_id` (`spec_id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for manager_deploy_server
-- ----------------------------
DROP TABLE IF EXISTS `manager_deploy_server`;
CREATE TABLE `manager_deploy_server` (
  `id` int NOT NULL AUTO_INCREMENT,
  `policy_id` varchar(128) DEFAULT NULL,
  `service_name` varchar(256) DEFAULT NULL,
  `server_params` json DEFAULT NULL,
  `version` varchar(256) DEFAULT NULL,
  `is_required` tinyint(1) DEFAULT NULL,
  `strategy` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `policy_id` (`policy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for manager_instance_network_info
-- ----------------------------
DROP TABLE IF EXISTS `manager_instance_network_info`;
CREATE TABLE `manager_instance_network_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(128) DEFAULT NULL,
  `primary` tinyint(1) DEFAULT NULL,
  `ip` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_instance_network_ip_unique` (`instance_id`,`ip`),
  KEY `instance_id` (`instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16910573 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for manager_machine_network_info
-- ----------------------------
DROP TABLE IF EXISTS `manager_machine_network_info`;
CREATE TABLE `manager_machine_network_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `network_info` json DEFAULT NULL,
  `machine_id` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_machine_network_info_key_unique` (`machine_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for manager_operation_job
-- ----------------------------
DROP TABLE IF EXISTS `manager_operation_job`;
CREATE TABLE `manager_operation_job` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int DEFAULT NULL,
  `job_id` varchar(128) DEFAULT NULL,
  `task_id` varchar(128) DEFAULT NULL,
  `state` varchar(128) DEFAULT NULL,
  `err_msg` text,
  `job_params` json DEFAULT NULL,
  `start_time` datetime(6) DEFAULT NULL,
  `end_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `job_type` varchar(256) DEFAULT NULL,
  `total_step` int DEFAULT NULL,
  `idc_id` varchar(256) DEFAULT NULL,
  `instance_id` varchar(256) DEFAULT NULL,
  `is_reported` tinyint(1) DEFAULT NULL,
  `create_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) DEFAULT NULL COMMENT '最近更新时间',
  `request_id` varchar(64) DEFAULT NULL,
  `exec_log` json DEFAULT NULL,
  `retry_count` int DEFAULT '0',
  `extra_task_id` varchar(128) DEFAULT NULL COMMENT '其他服务的任务ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_job_key_unique` (`job_id`),
  KEY `task_id` (`task_id`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3064435 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for manager_operation_sub_job
-- ----------------------------
DROP TABLE IF EXISTS `manager_operation_sub_job`;
CREATE TABLE `manager_operation_sub_job` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int DEFAULT NULL,
  `sub_job_id` varchar(128) DEFAULT NULL,
  `jobId` varchar(128) DEFAULT NULL,
  `job_type` varchar(256) DEFAULT NULL,
  `state` varchar(128) DEFAULT NULL,
  `err_msg` text,
  `job_params` json DEFAULT NULL,
  `step` int DEFAULT NULL,
  `start_time` datetime(6) DEFAULT NULL,
  `end_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_sub_job_key_unique` (`sub_job_id`),
  KEY `jobId` (`jobId`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=916729 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for manager_operation_task
-- ----------------------------
DROP TABLE IF EXISTS `manager_operation_task`;
CREATE TABLE `manager_operation_task` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int DEFAULT NULL,
  `task_id` varchar(128) DEFAULT NULL,
  `trace_id` varchar(128) DEFAULT NULL,
  `request_id` varchar(128) DEFAULT NULL,
  `total_count` int DEFAULT NULL,
  `success_count` int DEFAULT NULL,
  `failed_count` int DEFAULT NULL,
  `state` varchar(128) DEFAULT NULL,
  `err_msg` text,
  `task_params` json DEFAULT NULL,
  `start_time` datetime(6) DEFAULT NULL,
  `end_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `task_type` varchar(256) DEFAULT NULL,
  `create_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '最近更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_task_key_unique` (`task_id`),
  KEY `trace_id` (`trace_id`),
  KEY `request_id` (`request_id`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1801716 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for manager_policy_info
-- ----------------------------
DROP TABLE IF EXISTS `manager_policy_info`;
CREATE TABLE `manager_policy_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `policy_id` varchar(128) DEFAULT NULL,
  `title` varchar(256) DEFAULT NULL,
  `policy_goals` varchar(256) DEFAULT NULL,
  `image_id` varchar(256) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `remark` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `title` (`title`),
  KEY `policy_id` (`policy_id`),
  KEY `policy_goals` (`policy_goals`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for manager_policy_scope
-- ----------------------------
DROP TABLE IF EXISTS `manager_policy_scope`;
CREATE TABLE `manager_policy_scope` (
  `id` int NOT NULL AUTO_INCREMENT,
  `policy_id` varchar(128) DEFAULT NULL,
  `target_id` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_policy_info_key_unique` (`target_id`),
  KEY `policy_id` (`policy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for manager_script_rule
-- ----------------------------
DROP TABLE IF EXISTS `manager_script_rule`;
CREATE TABLE `manager_script_rule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `policy_id` varchar(128) DEFAULT NULL,
  `script_path` varchar(256) DEFAULT NULL,
  `script_main` varchar(256) DEFAULT NULL,
  `script_params` json DEFAULT NULL,
  `version` varchar(256) DEFAULT NULL,
  `is_required` tinyint(1) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `policy_id` (`policy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for map_account_info
-- ----------------------------
DROP TABLE IF EXISTS `map_account_info`;
CREATE TABLE `map_account_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `map_account_id` int DEFAULT NULL,
  `map_account_uid` varchar(128) DEFAULT NULL COMMENT '供应商账号uid',
  `cloud_vendor` varchar(128) DEFAULT NULL,
  `access_key` varchar(128) DEFAULT NULL,
  `secret_key` varchar(128) DEFAULT NULL,
  `status` varchar(128) DEFAULT NULL,
  `remark` varchar(128) DEFAULT NULL,
  `namespace` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `supplier` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '供应商(Supplier)： 表示所属厂商, Ali：阿里云, CMCC：移动云, Baidu：百度云, VE：火山云（字节旗下）',
  `alias` varchar(255) DEFAULT NULL COMMENT '代号，别名',
  PRIMARY KEY (`id`),
  UNIQUE KEY `map_account_id_unique` (`map_account_id`),
  KEY `cloud_vendor` (`cloud_vendor`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for namespace_info
-- ----------------------------
DROP TABLE IF EXISTS `namespace_info`;
CREATE TABLE `namespace_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int DEFAULT NULL,
  `namespace` varchar(128) DEFAULT NULL,
  `remark` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_namespace_info_unique` (`uid`,`namespace`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for net_interface
-- ----------------------------
DROP TABLE IF EXISTS `net_interface`;
CREATE TABLE `net_interface` (
  `id` int NOT NULL AUTO_INCREMENT,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `idc_id` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `firewall_id` varchar(255) NOT NULL,
  `interface_id` varchar(255) NOT NULL,
  `network_id` varchar(255) DEFAULT NULL COMMENT '用于绑定流出接口，逗号分隔',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for network_dnat
-- ----------------------------
DROP TABLE IF EXISTS `network_dnat`;
CREATE TABLE `network_dnat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '自定义名字',
  `idc_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'error' COMMENT '云天定义的机房ID。必须在idc表能查到，且是阿里机房',
  `nat_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'error' COMMENT '必须在NAT表存在',
  `dnat_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'error' COMMENT '前缀 dnat- + 16字符',
  `map_dnat_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '对应供应商的DNAT ID',
  `outer_eip_id` varchar(4096) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `outer_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'error' COMMENT '1~65535，如果使用端口段，则用/分隔开始和结束',
  `inner_ip` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `inner_port` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'error' COMMENT '1~65535，如果使用端口段，则用/分隔开始和结束',
  `protocol` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'All' COMMENT 'TCP、UDP、All',
  `health_port` int NOT NULL DEFAULT '0' COMMENT '1~65535，用于健康检测',
  `state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Disable' COMMENT 'Preparing、Available、Deleting、Disable',
  `standby_eip_ids` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '备用EIP，必须在eip存在，多条以逗号分隔',
  `standby_state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Disable' COMMENT '备用EIP状态，Disable,Running,Stopping,Stopped,Starting',
  `map_account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '供应商账号',
  `supplier` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '供应商名称',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '归属到哪个iaas账号，必须在账号表存在',
  `pre_sell_tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '预售到哪个iaas账号，必须在账号表存在',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '自动生成',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '自动更新',
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '业务自行填',
  `one_to_one` tinyint NOT NULL DEFAULT (0) COMMENT '是否一对一映射，只有自建支持',
  `allowed_srcaddr` varchar(1024) DEFAULT '' COMMENT '允许的源地址',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_rule` (`idc_id`,`nat_id`,`dnat_id`),
  UNIQUE KEY `idx_dnat_id` (`dnat_id`) USING BTREE,
  UNIQUE KEY `idx_map_dnat_id` (`map_dnat_id`) USING BTREE,
  KEY `dnat_id` (`dnat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=94754 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for network_eip
-- ----------------------------
DROP TABLE IF EXISTS `network_eip`;
CREATE TABLE `network_eip` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '自定义名字',
  `idc_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'error' COMMENT '云天定义的机房ID。必须在idc表能查到，且是阿里机房',
  `eip_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'error' COMMENT '前缀 aip- + 16字符',
  `map_eip_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '对应供应商的DNAT ID',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'EIP的地址',
  `isp` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT 'CUCC：联通；CMCC：移动；CTCC：电信',
  `is_standby` int NOT NULL DEFAULT '0' COMMENT '是否备用EIP。0：不是；1：是',
  `standby_state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Disable' COMMENT '备用EIP状态，Disable,Running,Stopping,Stopped,Starting',
  `max_bandwidth` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '1Mbps' COMMENT '最高带宽',
  `state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Disable' COMMENT 'Binding、UnBinding、Bound、Available、Disable',
  `map_account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '供应商账号',
  `supplier` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '供应商名称',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '归属到哪个iaas账号，必须在账号表存在',
  `pre_sell_tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '预售到哪个iaas账号，必须在账号表存在',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '自动生成',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '自动更新',
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '业务自行填',
  `charge_type` varchar(255) DEFAULT 'PostPaid' COMMENT '带宽计费模式：PostPaid（目前只支持PostPaid）',
  `bandwidth_charge_type` varchar(255) DEFAULT '95BandwidthByMonth' COMMENT '带宽计费模式：95BandwidthByMonth（目前只支持95BandwidthByMonth）',
  `resource_instance_id` varchar(255) DEFAULT '' COMMENT '绑EIP的资源',
  `resource_instance_type` varchar(255) DEFAULT '' COMMENT 'NAT, SLB, NetworkInterface, NATSLB, EGC',
  `capture_time` datetime(3) DEFAULT NULL COMMENT '带宽采集时间',
  `report_time` datetime(6) DEFAULT NULL,
  `ignore_error` tinyint DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_eip_id` (`eip_id`) USING BTREE,
  KEY `eip_id` (`eip_id`),
  KEY `idx_address` (`address`) USING BTREE,
  KEY `idx_map_eip_id` (`map_eip_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=52050 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for network_info
-- ----------------------------
DROP TABLE IF EXISTS `network_info`;
CREATE TABLE `network_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int DEFAULT NULL,
  `account_id` int DEFAULT NULL,
  `map_account_id` int DEFAULT NULL,
  `idc_id` varchar(128) DEFAULT NULL,
  `network_id` varchar(128) DEFAULT NULL,
  `map_network_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `cidr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `name` varchar(128) DEFAULT NULL,
  `network_type` varchar(128) DEFAULT NULL,
  `pyhsical_network` varchar(128) DEFAULT NULL,
  `segment_id` varchar(128) DEFAULT NULL,
  `mtu` int DEFAULT NULL,
  `state` varchar(128) DEFAULT NULL,
  `description` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `network_origin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '网络来源，ali_vpc，dc_preset_vlan.字段已废弃，新功能应该使用supplier字段，兼容性考虑该字段暂时保留',
  `supplier` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'pb中common.EnumSupplierType枚举字段',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '租户信息',
  `pre_sell_tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '预分配租户信息',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_network_id` (`network_id`) USING BTREE,
  UNIQUE KEY `idx_map_network_id` (`map_network_id`) USING BTREE,
  KEY `idx_network_idc` (`idc_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6410 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for network_nat
-- ----------------------------
DROP TABLE IF EXISTS `network_nat`;
CREATE TABLE `network_nat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '自定义名字',
  `idc_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'error' COMMENT '云天定义的机房ID。必须在idc表能查到，且是阿里机房',
  `nat_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'error' COMMENT '前缀 nat- + 16字符',
  `map_nat_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '对应供应商的NAT ID',
  `network_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'error' COMMENT '关联的网络ID，必须存在',
  `vswitch_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '关联的交换机ID',
  `map_account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '供应商账号',
  `supplier` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '供应商名称',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '归属到哪个iaas账号，必须在账号表存在',
  `pre_sell_tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '预售到哪个iaas账号，必须在账号表存在',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '自动生成',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '自动更新',
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '如果不填，自动更新',
  `state` varchar(255) DEFAULT 'Waiting' COMMENT 'Waiting, Creating, Running, Deleted, Disable',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_map_nat_id` (`map_nat_id`) USING BTREE,
  UNIQUE KEY `idx_nat_id` (`nat_id`) USING BTREE,
  KEY `nat_id` (`nat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=58110 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for network_snat
-- ----------------------------
DROP TABLE IF EXISTS `network_snat`;
CREATE TABLE `network_snat` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '自定义名字',
  `idc_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'error' COMMENT '云天定义的机房ID。必须在idc表能查到，且是阿里机房',
  `nat_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'error' COMMENT '必须在NAT表存在',
  `snat_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'error' COMMENT '前缀 snat- + 16字符',
  `map_snat_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '对应供应商的SNAT ID',
  `eip_ids` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'error' COMMENT '必须在eip存在，多条以逗号分隔',
  `cidr_rule` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '可以应用本条规则的网段',
  `state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Disable' COMMENT 'Preparing,Available,Deleting,Disable 四选一',
  `standby_eip_ids` varchar(4096) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '备用EIP，必须在eip存在，多条以逗号分隔',
  `standby_state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Disable' COMMENT '备用EIP状态，Disable,Running,Stopping,Stopped,Starting',
  `idle_timeout` int NOT NULL DEFAULT '60' COMMENT '1~86400可选，单位秒',
  `map_account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '供应商账号',
  `supplier` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '供应商名称',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '归属到哪个iaas账号，必须在账号表存在',
  `pre_sell_tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '预售到哪个iaas账号，必须在账号表存在',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '自动生成',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '自动更新',
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '业务自行填',
  `isp_affinity` int NOT NULL DEFAULT '0' COMMENT '运营商亲和性，默认为否',
  `snat_type` varchar(255) DEFAULT '' COMMENT 'SNAT的类型',
  `disable_eip_ids` varchar(255) DEFAULT '' COMMENT '停用的地址',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_rule` (`idc_id`,`nat_id`,`snat_id`),
  UNIQUE KEY `idx_snat_id` (`snat_id`) USING BTREE,
  UNIQUE KEY `idx_map_snat_id` (`map_snat_id`) USING BTREE,
  KEY `snat_id` (`snat_id`)
) ENGINE=InnoDB AUTO_INCREMENT=54269 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for order_info
-- ----------------------------
DROP TABLE IF EXISTS `order_info`;
CREATE TABLE `order_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` varchar(128) DEFAULT NULL COMMENT '订单id',
  `map_order_id` varchar(128) DEFAULT NULL COMMENT '映射订单id',
  `spec_id` varchar(128) DEFAULT NULL COMMENT '规格id',
  `count` int DEFAULT NULL COMMENT '数量',
  `order_type` varchar(64) DEFAULT NULL COMMENT '订单类型',
  `cloud_vendor` varchar(128) DEFAULT NULL COMMENT '供应商',
  `account_id` int DEFAULT NULL,
  `map_account_id` int DEFAULT NULL,
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `modify_time` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_unique` (`order_id`,`deleted_at`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=144519 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for placement_dc_arm_inventory
-- ----------------------------
DROP TABLE IF EXISTS `placement_dc_arm_inventory`;
CREATE TABLE `placement_dc_arm_inventory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idc_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `node_name` varchar(128) DEFAULT NULL,
  `ip` varchar(128) DEFAULT NULL,
  `network_define` varchar(64) DEFAULT NULL,
  `labels` json DEFAULT NULL,
  `is_ready` tinyint DEFAULT NULL,
  `status` varchar(64) DEFAULT NULL,
  `aic_used` varchar(64) DEFAULT NULL COMMENT 'aic_used',
  `resource_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `last_refresh_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `modify_time` timestamp NULL DEFAULT NULL,
  `supplier` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '机器来源信息 CS: 云天， ALI: 阿里',
  PRIMARY KEY (`id`),
  UNIQUE KEY `node_name_unique` (`node_name`),
  KEY `idc_idx` (`idc_id`,`status`,`aic_used`,`is_ready`,`resource_id`)
) ENGINE=InnoDB AUTO_INCREMENT=124854 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for placement_dc_x86_allocation
-- ----------------------------
DROP TABLE IF EXISTS `placement_dc_x86_allocation`;
CREATE TABLE `placement_dc_x86_allocation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idc_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `cabinet_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `hypervisor_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `instance_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `spec_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `memory` int DEFAULT NULL,
  `disk` int DEFAULT NULL,
  `cpu_vendor` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `cpu_model` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `cpu_cores` int DEFAULT NULL,
  `cpu_info` json DEFAULT NULL,
  `gpu_vendor_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `gpu_device_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `gpu_num` int DEFAULT NULL,
  `gpu_info` json DEFAULT NULL,
  `rated_power` int DEFAULT NULL COMMENT '额定功率',
  `resource_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `modify_time` timestamp NULL DEFAULT NULL,
  `gpu_model` varchar(128) NOT NULL DEFAULT '',
  `support_instance_types` varchar(255) DEFAULT NULL COMMENT '支持的分配类型列表',
  `ip_type` varchar(128) DEFAULT NULL COMMENT '第三方库存资源IP类型',
  `carrier` varchar(128) DEFAULT NULL COMMENT '第三方库存资源供应商',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `instance_unique_key` (`instance_id`),
  KEY `hypervisor_idx` (`hypervisor_id`),
  KEY `idc_hypervisor_idx` (`idc_id`,`hypervisor_id`),
  KEY `idc_instance_idx` (`idc_id`,`instance_id`),
  KEY `idc_id_spec_id_index` (`idc_id`,`spec_id`,`cpu_cores`) COMMENT '用于根据机房和规格查询已分配数'
) ENGINE=InnoDB AUTO_INCREMENT=116074 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for placement_dc_x86_inventory
-- ----------------------------
DROP TABLE IF EXISTS `placement_dc_x86_inventory`;
CREATE TABLE `placement_dc_x86_inventory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idc_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `cabinet_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `hypervisor_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `memory` int DEFAULT NULL,
  `disk` int DEFAULT NULL,
  `cpu_vendor` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `cpu_model` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `cpu_cores` int DEFAULT NULL,
  `numa_cores_max` tinyint DEFAULT NULL,
  `cpu_info` json DEFAULT NULL,
  `gpu_vendor_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `gpu_device_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `gpu_num` int DEFAULT NULL,
  `gpu_info` json DEFAULT NULL,
  `account_id` int DEFAULT NULL,
  `shielded_gpu_info` json DEFAULT NULL,
  `is_bare_metal` tinyint DEFAULT '1',
  `status` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `last_refresh_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `modify_time` timestamp NULL DEFAULT NULL,
  `gpu_model` varchar(128) NOT NULL DEFAULT '',
  `support_instance_types` varchar(255) DEFAULT NULL COMMENT '支持的分配类型列表',
  `op_status` varchar(100) DEFAULT NULL COMMENT '运维手动标记的状态',
  `on_sale` int DEFAULT '1' COMMENT '机器上下架状态 1：上架， 2：未上架',
  `inspection_status` varchar(64) DEFAULT NULL,
  `inspection_err_msg` text,
  `inspection_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `ip_type` varchar(128) DEFAULT NULL COMMENT '第三方库存资源IP类型',
  `carrier` varchar(128) DEFAULT NULL COMMENT '第三方库存资源供应商',
  `map_spec_id` varchar(128) DEFAULT NULL COMMENT '第三方实例规格ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `hypervisor_unique` (`hypervisor_id`),
  KEY `hypervisor_key` (`hypervisor_id`) USING BTREE,
  KEY `spec_filter_key` (`memory`,`disk`,`cpu_cores`,`gpu_num`) USING BTREE,
  KEY `hypervisor_status_idx` (`hypervisor_id`,`status`),
  KEY `idc_id_status_cpu_model_gpu_model_index` (`idc_id`,`status`,`cpu_model`,`gpu_model`)
) ENGINE=InnoDB AUTO_INCREMENT=121217 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for placement_dc_x86_total
-- ----------------------------
DROP TABLE IF EXISTS `placement_dc_x86_total`;
CREATE TABLE `placement_dc_x86_total` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idc_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `cabinet_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `hypervisor_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `memory` int DEFAULT NULL,
  `disk` int DEFAULT NULL,
  `cpu_vendor` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `cpu_model` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `cpu_cores` int DEFAULT NULL,
  `cpu_info` json DEFAULT NULL,
  `gpu_vendor_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `gpu_device_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `gpu_num` int DEFAULT NULL,
  `gpu_info` json DEFAULT NULL,
  `status` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `modify_time` timestamp NULL DEFAULT NULL,
  `gpu_model` varchar(128) NOT NULL DEFAULT '',
  `gpu_device_name` varchar(128) NOT NULL DEFAULT '',
  `support_instance_types` varchar(255) DEFAULT NULL COMMENT '支持的分配类型列表',
  `op_status` varchar(100) DEFAULT NULL COMMENT '运维手动标记的状态',
  `on_sale` int DEFAULT '1' COMMENT '机器上下架状态 1：上架， 2：未上架',
  `remark` varchar(2048) DEFAULT NULL COMMENT '备注信息',
  `inspection_status` varchar(64) DEFAULT NULL,
  `inspection_err_msg` text,
  `inspection_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `ip_type` varchar(128) DEFAULT NULL COMMENT '第三方库存资源IP类型',
  `carrier` varchar(128) DEFAULT NULL COMMENT '第三方库存资源供应商',
  `map_spec_id` varchar(128) DEFAULT NULL COMMENT '第三方实例规格ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `hypervisor_unique` (`hypervisor_id`),
  KEY `hypervisor_key` (`hypervisor_id`) USING BTREE,
  KEY `idc_id_cpu_model_gpu_model_index` (`idc_id`,`cpu_model`,`gpu_model`) COMMENT '查询库存屏蔽和故障数量使用'
) ENGINE=InnoDB AUTO_INCREMENT=119288 DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for placement_pre_allocation
-- ----------------------------
DROP TABLE IF EXISTS `placement_pre_allocation`;
CREATE TABLE `placement_pre_allocation` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `instance_id` varchar(128) NOT NULL COMMENT '实例 ID',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `idc_id` varchar(64) NOT NULL COMMENT '机房 ID',
  `cabinet_id` varchar(64) NOT NULL COMMENT '机柜 ID',
  `hypervisor_id` varchar(64) NOT NULL COMMENT '宿主机 ID',
  `memory` int NOT NULL DEFAULT '0' COMMENT '内存(GB)',
  `disk` int NOT NULL DEFAULT '0' COMMENT '磁盘(GB)',
  `gpu_num` int NOT NULL DEFAULT '0' COMMENT 'GPU 数量',
  `spec_id` varchar(64) NOT NULL COMMENT '规格 ID',
  `cpu_info` json NOT NULL COMMENT 'CPU NUMA 信息',
  `gpu_info` json NOT NULL COMMENT 'GPU 信息',
  `rated_power` int NOT NULL DEFAULT '0' COMMENT '额定功率',
  `resource_id` varchar(128) NOT NULL COMMENT '预分配批次 ID',
  `pxe_networkcard_vlan` varchar(64) NOT NULL COMMENT 'PXE 网络',
  `preserve_start_time` datetime DEFAULT NULL COMMENT '预留开始时间',
  `preserve_end_time` datetime DEFAULT NULL COMMENT '预留结束时间',
  `deleted_at` datetime(3) DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`id`),
  KEY `idx_resource` (`resource_id`),
  KEY `idx_idc_spec` (`idc_id`,`spec_id`),
  KEY `idx_instance` (`instance_id`),
  KEY `idx_placement_pre_allocation_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=6888 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='库存预分配记录';

-- ----------------------------
-- Table structure for policy
-- ----------------------------
DROP TABLE IF EXISTS `policy`;
CREATE TABLE `policy` (
  `id` int NOT NULL AUTO_INCREMENT,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `idc_id` varchar(255) NOT NULL,
  `firewall_id` varchar(255) NOT NULL,
  `policy_id` varchar(255) NOT NULL,
  `map_policy_id` varchar(255) NOT NULL COMMENT '防火墙系统策略ID',
  `in_interface_id` varchar(255) NOT NULL,
  `out_interface_id` varchar(255) NOT NULL,
  `white_list` text NOT NULL COMMENT '白名单,逗号分隔',
  `port_map_id` text NOT NULL COMMENT '端口映射ID, 逗号分隔',
  `service_id` text NOT NULL COMMENT '服务ID(防火墙的服务id), 逗号分隔',
  `use_nat` tinyint(1) NOT NULL COMMENT '是否使用NAT, 多线路时可能需要使用，移动走移动，电信走电信的意思',
  `description` text COMMENT '描述,记录一些事件',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for port_info
-- ----------------------------
DROP TABLE IF EXISTS `port_info`;
CREATE TABLE `port_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int DEFAULT NULL,
  `account_id` int DEFAULT NULL,
  `map_account_id` int DEFAULT NULL,
  `idc_id` varchar(128) DEFAULT NULL,
  `network_id` varchar(128) DEFAULT NULL,
  `subnet_id` varchar(128) DEFAULT NULL,
  `port_id` varchar(128) DEFAULT NULL,
  `instance_id` varchar(128) DEFAULT NULL,
  `name` varchar(128) DEFAULT NULL,
  `mac_address` varchar(128) DEFAULT NULL,
  `ip_address` varchar(128) DEFAULT NULL,
  `state` varchar(128) DEFAULT NULL,
  `description` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `target_dev` varchar(128) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_port_id` (`port_id`)
) ENGINE=InnoDB AUTO_INCREMENT=158264 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for port_map
-- ----------------------------
DROP TABLE IF EXISTS `port_map`;
CREATE TABLE `port_map` (
  `id` int NOT NULL AUTO_INCREMENT,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `idc_id` varchar(255) NOT NULL,
  `real_port_map_id` varchar(255) NOT NULL COMMENT '真实的防火墙端口映射ID',
  `port_map_id` varchar(255) NOT NULL,
  `public_ip` varchar(255) NOT NULL,
  `internal_ip` varchar(255) NOT NULL,
  `protocol` varchar(255) DEFAULT NULL,
  `one_to_one` tinyint(1) NOT NULL COMMENT '一对一映射',
  `public_port` varchar(255) DEFAULT NULL COMMENT '公网端口 220,1000',
  `internal_port` varchar(255) DEFAULT NULL COMMENT '内网端口 1,65535',
  `description` text COMMENT '描述,记录一些事件',
  `instance_id` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `port_map_instance_id` (`instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for public_ip
-- ----------------------------
DROP TABLE IF EXISTS `public_ip`;
CREATE TABLE `public_ip` (
  `id` int NOT NULL AUTO_INCREMENT,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `idc_id` varchar(255) NOT NULL,
  `interface_id` varchar(255) NOT NULL COMMENT '流入接口',
  `public_ip` varchar(255) NOT NULL,
  `operator` varchar(255) NOT NULL COMMENT '运营商',
  `available_port_num` int NOT NULL DEFAULT '65535' COMMENT '可用端口数量',
  `description` text,
  PRIMARY KEY (`id`),
  KEY `public_ip_idc_id` (`idc_id`,`public_ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for region_info
-- ----------------------------
DROP TABLE IF EXISTS `region_info`;
CREATE TABLE `region_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `region_id` varchar(128) DEFAULT NULL,
  `region_name` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `region_id_key` (`region_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for report_work_order
-- ----------------------------
DROP TABLE IF EXISTS `report_work_order`;
CREATE TABLE `report_work_order` (
  `id` int NOT NULL AUTO_INCREMENT,
  `work_order_id` varchar(128) DEFAULT NULL,
  `work_order_remark` varchar(128) DEFAULT NULL,
  `resource` text,
  `status` varchar(128) DEFAULT NULL,
  `row_id` varchar(128) DEFAULT NULL,
  `idc_id` varchar(128) DEFAULT NULL,
  `report_people` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_task_key_unique` (`work_order_id`),
  KEY `work_order_id` (`work_order_id`),
  KEY `status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=166 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for report_work_order_detail
-- ----------------------------
DROP TABLE IF EXISTS `report_work_order_detail`;
CREATE TABLE `report_work_order_detail` (
  `id` int NOT NULL AUTO_INCREMENT,
  `work_order_id` varchar(128) DEFAULT NULL,
  `sub_work_order_id` varchar(128) DEFAULT NULL,
  `hypervisor_id` varchar(128) DEFAULT NULL,
  `machine_id` varchar(128) DEFAULT NULL,
  `ipmi` varchar(128) DEFAULT NULL,
  `failure_description` text,
  `status` varchar(128) DEFAULT NULL,
  `system_ip` varchar(128) DEFAULT NULL,
  `pcf_node` varchar(128) DEFAULT NULL,
  `idc_id` varchar(128) DEFAULT NULL,
  `supplier_sn` varchar(128) DEFAULT NULL,
  `machine_spec_id` varchar(128) DEFAULT NULL,
  `row_id` varchar(128) DEFAULT NULL,
  `process` varchar(128) DEFAULT NULL,
  `repair_process` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `accept_result` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_task_key_unique` (`sub_work_order_id`),
  KEY `work_order_id` (`work_order_id`),
  KEY `sub_work_order_id` (`sub_work_order_id`),
  KEY `hypervisor_id` (`hypervisor_id`),
  KEY `machine_id` (`machine_id`),
  KEY `ipmi` (`ipmi`),
  KEY `idc_id` (`idc_id`),
  KEY `supplier_sn` (`supplier_sn`),
  KEY `machine_spec_id` (`machine_spec_id`),
  KEY `status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=498 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for spp_bill_data
-- ----------------------------
DROP TABLE IF EXISTS `spp_bill_data`;
CREATE TABLE `spp_bill_data` (
  `id` int NOT NULL AUTO_INCREMENT,
  `instance_id` varchar(128) DEFAULT NULL,
  `ninety_five_time` varchar(128) DEFAULT NULL,
  `amount_number` varchar(128) DEFAULT NULL,
  `bill_cycle` varchar(128) DEFAULT NULL,
  `hash_number` varchar(128) DEFAULT NULL,
  `cost_start_time` varchar(128) DEFAULT NULL,
  `cost_end_time` varchar(128) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_hash_number_instance_id` (`hash_number`,`instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=211 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for spp_operation_job
-- ----------------------------
DROP TABLE IF EXISTS `spp_operation_job`;
CREATE TABLE `spp_operation_job` (
  `id` int NOT NULL AUTO_INCREMENT,
  `job_id` varchar(128) DEFAULT NULL,
  `task_id` varchar(128) DEFAULT NULL,
  `job_type` varchar(256) DEFAULT NULL,
  `state` varchar(128) DEFAULT NULL,
  `err_msg` text,
  `job_params` json DEFAULT NULL,
  `total_step` int DEFAULT NULL,
  `start_time` datetime(6) DEFAULT NULL,
  `end_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `idc_id` varchar(256) DEFAULT NULL,
  `machine_id` varchar(256) DEFAULT NULL,
  `instance_id` varchar(256) DEFAULT NULL,
  `hypervisor_id` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_job_key_unique` (`job_id`),
  KEY `task_id` (`task_id`)
) ENGINE=InnoDB AUTO_INCREMENT=43083 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for spp_operation_sub_job
-- ----------------------------
DROP TABLE IF EXISTS `spp_operation_sub_job`;
CREATE TABLE `spp_operation_sub_job` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sub_job_id` varchar(128) DEFAULT NULL,
  `jobId` varchar(128) DEFAULT NULL,
  `job_type` varchar(256) DEFAULT NULL,
  `state` varchar(128) DEFAULT NULL,
  `err_msg` text,
  `job_params` json DEFAULT NULL,
  `step` int DEFAULT NULL,
  `start_time` datetime(6) DEFAULT NULL,
  `end_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `machine_id` varchar(256) DEFAULT NULL,
  `instance_id` varchar(256) DEFAULT NULL,
  `hypervisor_id` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_sub_job_key_unique` (`sub_job_id`),
  KEY `jobId` (`jobId`)
) ENGINE=InnoDB AUTO_INCREMENT=19165 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for spp_operation_task
-- ----------------------------
DROP TABLE IF EXISTS `spp_operation_task`;
CREATE TABLE `spp_operation_task` (
  `id` int NOT NULL AUTO_INCREMENT,
  `account_id` int DEFAULT NULL,
  `task_id` varchar(128) DEFAULT NULL,
  `trace_id` varchar(128) DEFAULT NULL,
  `request_id` varchar(128) DEFAULT NULL,
  `task_type` varchar(256) DEFAULT NULL,
  `total_count` int DEFAULT NULL,
  `success_count` int DEFAULT NULL,
  `failed_count` int DEFAULT NULL,
  `state` varchar(128) DEFAULT NULL,
  `err_msg` text,
  `task_params` json DEFAULT NULL,
  `start_time` datetime(6) DEFAULT NULL,
  `end_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_task_key_unique` (`task_id`),
  KEY `task_type` (`task_type`)
) ENGINE=InnoDB AUTO_INCREMENT=5307 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for subnet_info
-- ----------------------------
DROP TABLE IF EXISTS `subnet_info`;
CREATE TABLE `subnet_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int DEFAULT NULL,
  `account_id` int DEFAULT NULL,
  `map_account_id` int DEFAULT NULL,
  `idc_id` varchar(128) DEFAULT NULL,
  `network_id` varchar(128) DEFAULT NULL,
  `subnet_id` varchar(128) DEFAULT NULL,
  `map_subnet_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `name` varchar(128) DEFAULT NULL,
  `cidr` varchar(128) DEFAULT NULL,
  `gateway_ip` varchar(128) DEFAULT NULL,
  `dns_nameservers` varchar(128) DEFAULT NULL,
  `enable_dhcp` tinyint(1) DEFAULT NULL,
  `in_use` tinyint(1) DEFAULT NULL,
  `description` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `ip_ranges` varchar(4096) DEFAULT NULL,
  `use_for` varchar(128) DEFAULT NULL COMMENT '给arm或kvm用',
  `supplier` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'pb中common.EnumSupplierType枚举字段',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `pre_sell_tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_subnet` (`subnet_id`) USING BTREE,
  UNIQUE KEY `idx_map_subnet_id` (`map_subnet_id`) USING BTREE,
  KEY `subnet_info_index` (`account_id`,`idc_id`,`network_id`,`subnet_id`,`use_for`) USING BTREE,
  KEY `idx_network_subnet` (`network_id`,`subnet_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6656 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for supplier_network
-- ----------------------------
DROP TABLE IF EXISTS `supplier_network`;
CREATE TABLE `supplier_network` (
  `id` int NOT NULL AUTO_INCREMENT,
  `machine_id` varchar(128) DEFAULT NULL,
  `idc_id` varchar(128) DEFAULT NULL,
  `map_instance_id` varchar(128) DEFAULT NULL,
  `gateway` varchar(256) DEFAULT NULL,
  `ip` varchar(256) DEFAULT NULL,
  `mac` varchar(256) DEFAULT NULL,
  `cidr` varchar(256) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `machine_id` (`machine_id`),
  KEY `map_instance_id` (`map_instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11697 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for t_iaas_instance_info
-- ----------------------------
DROP TABLE IF EXISTS `t_iaas_instance_info`;
CREATE TABLE `t_iaas_instance_info` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键编码',
  `instance_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ssh_domain` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ssh_public_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ssh_inner_ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ssh_port` bigint DEFAULT '0',
  `ssh_pass` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ssh_user` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ssh_salt` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `tenant_account` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `create_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '最近更新时间',
  `modify_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '最后修改时间',
  `public_ssh_detect_time` datetime(3) DEFAULT NULL COMMENT '公网ssh探测时间',
  `public_ssh_detect_state` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'None' COMMENT '公网ssh探测状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5832 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for t_iaas_instance_info_bak
-- ----------------------------
DROP TABLE IF EXISTS `t_iaas_instance_info_bak`;
CREATE TABLE `t_iaas_instance_info_bak` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键编码',
  `instance_id` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ssh_domain` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ssh_public_ip` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ssh_inner_ip` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ssh_port` bigint DEFAULT '0',
  `ssh_pass` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ssh_user` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ssh_salt` varchar(128) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `tenant_account` varchar(191) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `create_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '最近更新时间',
  `modify_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '最后修改时间',
  `public_ssh_detect_time` datetime(3) DEFAULT NULL COMMENT '公网ssh探测时间',
  `public_ssh_detect_state` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT 'None' COMMENT '公网ssh探测状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=590 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for user_hypervisor_info
-- ----------------------------
DROP TABLE IF EXISTS `user_hypervisor_info`;
CREATE TABLE `user_hypervisor_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int DEFAULT NULL,
  `account_id` int DEFAULT NULL,
  `map_account_id` int DEFAULT NULL,
  `idc_id` varchar(128) DEFAULT NULL,
  `hypervisor_id` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_hypervisor_unique` (`uid`,`hypervisor_id`),
  KEY `uid` (`uid`),
  KEY `idc_id` (`idc_id`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for user_idc_info
-- ----------------------------
DROP TABLE IF EXISTS `user_idc_info`;
CREATE TABLE `user_idc_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `idc_id` varchar(128) DEFAULT NULL,
  `account_id` int DEFAULT NULL,
  `map_account_id` int DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_idc_key` (`account_id`,`map_account_id`,`idc_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for user_info
-- ----------------------------
DROP TABLE IF EXISTS `user_info`;
CREATE TABLE `user_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int DEFAULT NULL,
  `main_uid` int DEFAULT NULL,
  `comments` varchar(128) DEFAULT NULL,
  `display_name` varchar(24) DEFAULT NULL,
  `login_name` varchar(128) DEFAULT NULL,
  `phone` varchar(11) DEFAULT NULL,
  `email` varchar(64) DEFAULT NULL,
  `password` varchar(64) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customer_id_key` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for user_instance_info
-- ----------------------------
DROP TABLE IF EXISTS `user_instance_info`;
CREATE TABLE `user_instance_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int DEFAULT NULL,
  `account_id` int DEFAULT NULL,
  `map_account_id` int DEFAULT NULL,
  `idc_id` varchar(128) DEFAULT NULL,
  `instance_id` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_instance_id_unique` (`instance_id`),
  KEY `idc_id` (`idc_id`),
  KEY `uid` (`uid`),
  KEY `account_id` (`account_id`),
  KEY `map_account_id` (`map_account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=572000 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for user_map_account_info
-- ----------------------------
DROP TABLE IF EXISTS `user_map_account_info`;
CREATE TABLE `user_map_account_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `uid` int DEFAULT NULL,
  `account_id` int DEFAULT NULL,
  `map_account_id` int DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `account_id` (`account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for work_order_user_info
-- ----------------------------
DROP TABLE IF EXISTS `work_order_user_info`;
CREATE TABLE `work_order_user_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(256) DEFAULT NULL,
  `cn_name` varchar(256) DEFAULT NULL,
  `owner_id` varchar(256) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `update_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `worker_order_user_info_unique` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=309 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- View structure for iaas_idc_info_view
-- ----------------------------
DROP VIEW IF EXISTS `iaas_idc_info_view`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `iaas_idc_info_view` AS select `ii`.`city` AS `城市`,`ii`.`idc_name` AS `c-机房id`,`ii`.`idc_id` AS `e-机房id`,if((`ii`.`status` = '0'),'下线','在线') AS `机房状态`,`dic`.`tenant_account` AS `租户列表`,`ii`.`supplier` AS `机房类型`,`mai`.`map_account_uid` AS `供应商账号`,`mai`.`remark` AS `供应商备注`,`ii`.`map_idc_id` AS `供应商机房id`,`ii`.`uidc` AS `区域别名`,`ii`.`cidc` AS `算力机房id`,`issci`.`cluster_id` AS `cluster_id` from ((((select `di`.`region_uid` AS `region_uid`,json_unquote(json_extract(json_arrayagg(concat('',`di`.`tenant_account`,'')),'$')) AS `tenant_account` from (select distinct `i`.`region_uid` AS `region_uid`,`i`.`tenant_account` AS `tenant_account` from `iaas_wms`.`instance` `i` where ((`i`.`state` <> 2) and (`i`.`tenant_account` <> ''))) `di` group by `di`.`region_uid`) `dic` join `idc_info` `ii`) join `map_account_info` `mai`) join (select json_unquote(json_extract(`sci`.`idc_id`,'$[0]')) AS `idc_id`,json_unquote(json_extract(`sci`.`permissions`,'$."cluster.id"')) AS `cluster_id` from `iaas_storage`.`storage_cluster_info` `sci` where (json_extract(`sci`.`idc_id`,'$[0]') <> '')) `issci`) where (((`dic`.`region_uid` collate utf8mb4_0900_bin) = (`ii`.`idc_id` collate utf8mb4_0900_bin)) and (`mai`.`map_account_id` = `ii`.`map_account_id`) and (`ii`.`idc_id` = `issci`.`idc_id`));

-- ----------------------------
-- View structure for iass_idc_user_view
-- ----------------------------
DROP VIEW IF EXISTS `iass_idc_user_view`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `iass_idc_user_view` AS select `xt`.`idc_id` AS `机房ID`,`xt`.`hypervisor_id` AS `宿主机ID`,`mihi`.`machine_spec_id` AS `宿主机型号`,`mihi`.`ip` AS `ip`,`mihi`.`ipmi_address` AS `IPMI`,`xt`.`cpu_cores` AS `宿主机CPU数量`,`xt`.`memory` AS `宿主机内存大小`,`xt`.`gpu_num` AS `宿主机显卡数量`,`xa`.`user_mem` AS `内存使用大小`,`xa`.`user_cpu` AS `CPU使用数量`,`xa`.`user_gpu` AS `GPU使用数量` from (((select `x`.`idc_id` AS `idc_id`,`x`.`hypervisor_id` AS `hypervisor_id`,`x`.`cpu_cores` AS `cpu_cores`,floor((`x`.`memory` / 1024)) AS `memory`,`x`.`gpu_num` AS `gpu_num` from `placement_dc_x86_total` `x`) `xt` left join (select `x`.`hypervisor_id` AS `hypervisor_id`,count(`x`.`hypervisor_id`) AS `count(x.hypervisor_id)`,sum(`x`.`memory`) AS `user_mem`,sum(`x`.`cpu_cores`) AS `user_cpu`,sum(`x`.`gpu_num`) AS `user_gpu` from `placement_dc_x86_allocation` `x` group by `x`.`hypervisor_id`) `xa` on((`xt`.`hypervisor_id` = `xa`.`hypervisor_id`))) join (select `hi`.`hypervisor_id` AS `hypervisor_id`,`mi`.`machine_spec_id` AS `machine_spec_id`,`hi`.`ip` AS `ip`,`mi`.`ipmi_address` AS `ipmi_address` from (`machine_info` `mi` join `hypervisor_info` `hi`) where ((`mi`.`machine_id` = `hi`.`machine_id`) and (`mi`.`deleted_at` is null))) `mihi` on((`mihi`.`hypervisor_id` = `xa`.`hypervisor_id`)));

-- ----------------------------
-- View structure for iass_instance_presale_info
-- ----------------------------
DROP VIEW IF EXISTS `iass_instance_presale_info`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `iass_instance_presale_info` AS select `imi`.`idc_id` AS `机房`,substring_index(`ii`.`idc_name`,'-',1) AS `地域`,substring_index(substring_index(`ii`.`idc_name`,'-',2),'-',-(1)) AS `城市`,`ii`.`map_idc_id` AS `CG_IDC`,`iwi`.`instance_uid` AS `实例id`,`iwi`.`spec` AS `实例类型`,`isi`.`spec_name` AS `硬件类型`,`imi`.`instance_state` AS `实例状态`,`imi`.`ip` AS `实例ip`,`iwi`.`tenant_account` AS `售出租户`,`iwi`.`pre_sell` AS `预售用户`,`iwi`.`supplier_bare_metal_uid` AS `供应商id` from (((`iaas_wms`.`instance` `iwi` join `instance_info` `imi`) join `idc_info` `ii`) join `instance_spec_info` `isi`) where (((`iwi`.`instance_uid` collate utf8mb4_0900_bin) = (`imi`.`instance_id` collate utf8mb4_0900_bin)) and (`imi`.`deleted_at` is null) and (`ii`.`idc_id` = `imi`.`idc_id`) and (`isi`.`spec_id` = `imi`.`spec_id`));

-- ----------------------------
-- Procedure structure for UpdateBareMetalSpec
-- ----------------------------
DROP PROCEDURE IF EXISTS `UpdateBareMetalSpec`;
delimiter ;;
CREATE PROCEDURE `UpdateBareMetalSpec`()
BEGIN
    -- 声明变量来保存新找到的spec值
    DECLARE new_spec_id VARCHAR(255);
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur_bare_metal_uid VARCHAR(255);
    DECLARE cur_bare_metal_id INT;

    -- 声明一个游标来遍历所有需要更新的bare_metal行
    DECLARE cur CURSOR FOR 
        SELECT bare_metal.bare_metal_uid, bare_metal.id
        FROM instance_spec_info
        JOIN iaas_wms.bare_metal ON bare_metal.spec COLLATE utf8mb4_0900_ai_ci = instance_spec_info.spec_id COLLATE utf8mb4_0900_ai_ci;

    -- 当游标结束时设置done为TRUE
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- 打开游标
    OPEN cur;

    -- 遍历游标中的每一行
    read_loop: LOOP
        FETCH cur INTO cur_bare_metal_uid, cur_bare_metal_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
				
        -- 输出变量值
--         SELECT cur_bare_metal_uid, cur_bare_metal_id;
		
        -- 根据bare_metal_uid找到新的spec值
        SELECT machine_spec_info.machine_spec_id INTO new_spec_id
        FROM hypervisor_info
        JOIN machine_info ON hypervisor_info.machine_id = machine_info.machine_id
        JOIN machine_spec_info ON machine_info.machine_spec_id = machine_spec_info.machine_spec_id
        WHERE hypervisor_info.hypervisor_id = cur_bare_metal_uid;
				
				IF new_spec_id IS NULL THEN
            SELECT cur_bare_metal_uid;
        END IF;

        -- 更新bare_metal表中的spec字段
        UPDATE iaas_wms.bare_metal
        SET spec = new_spec_id
        WHERE id = cur_bare_metal_id;
				
-- 				select spec from iaas_wms.bare_metal as bare_metal where id = cur_bare_metal_id;
    END LOOP;

    -- 关闭游标
    CLOSE cur;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for UpdateSupplierInstanceUid
-- ----------------------------
DROP PROCEDURE IF EXISTS `UpdateSupplierInstanceUid`;
delimiter ;;
CREATE PROCEDURE `UpdateSupplierInstanceUid`()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE tenant_instance_uid VARCHAR(255);
  DECLARE map_instance_id VARCHAR(255);
  DECLARE cur CURSOR FOR 
    SELECT tenant_instance_info.instance_uid, instance_info.map_instance_id
    FROM iaas_wms.instance AS tenant_instance_info
    JOIN instance_info ON tenant_instance_info.instance_uid COLLATE utf8mb4_0900_ai_ci = instance_info.instance_id COLLATE utf8mb4_0900_ai_ci
    WHERE tenant_instance_info.supplier_instance_uid COLLATE utf8mb4_0900_ai_ci != instance_info.map_instance_id COLLATE utf8mb4_0900_ai_ci;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur;

  read_loop: LOOP
    FETCH cur INTO tenant_instance_uid, map_instance_id;
    IF done THEN
      LEAVE read_loop;
    END IF;
    
    -- 更新tenant_instance_info表中的supplier_instance_uid字段
    UPDATE iaas_wms.instance
    SET supplier_instance_uid = map_instance_id
    WHERE instance_uid = tenant_instance_uid;
    
    -- 可以添加一些逻辑来限制每次处理的行数，例如：
    -- SET @row_count = @row_count + 1;
    -- IF @row_count >= 100 THEN
    --   LEAVE read_loop;
    -- END IF;
  END LOOP;

  CLOSE cur;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table network_dnat
-- ----------------------------
DROP TRIGGER IF EXISTS `before_insert_networkdnat`;
delimiter ;;
CREATE TRIGGER `before_insert_networkdnat` BEFORE INSERT ON `network_dnat` FOR EACH ROW BEGIN
    IF NEW.map_dnat_id IS NULL OR NEW.map_dnat_id = '' THEN
        SET NEW.map_dnat_id = UUID();
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table network_eip
-- ----------------------------
DROP TRIGGER IF EXISTS `before_insert_networkeip`;
delimiter ;;
CREATE TRIGGER `before_insert_networkeip` BEFORE INSERT ON `network_eip` FOR EACH ROW BEGIN
    IF NEW.map_eip_id IS NULL OR NEW.map_eip_id = '' THEN
        SET NEW.map_eip_id = UUID();
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table network_info
-- ----------------------------
DROP TRIGGER IF EXISTS `before_insert_networkinfo`;
delimiter ;;
CREATE TRIGGER `before_insert_networkinfo` BEFORE INSERT ON `network_info` FOR EACH ROW BEGIN
    IF NEW.map_network_id IS NULL OR NEW.map_network_id = '' THEN
        SET NEW.map_network_id = UUID();
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table network_nat
-- ----------------------------
DROP TRIGGER IF EXISTS `before_insert_networknat`;
delimiter ;;
CREATE TRIGGER `before_insert_networknat` BEFORE INSERT ON `network_nat` FOR EACH ROW BEGIN
    IF NEW.map_nat_id IS NULL OR NEW.map_nat_id = '' THEN
        SET NEW.map_nat_id = UUID();
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table network_snat
-- ----------------------------
DROP TRIGGER IF EXISTS `before_insert_networksnat`;
delimiter ;;
CREATE TRIGGER `before_insert_networksnat` BEFORE INSERT ON `network_snat` FOR EACH ROW BEGIN
    IF NEW.map_snat_id IS NULL OR NEW.map_snat_id = '' THEN
        SET NEW.map_snat_id = UUID();
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table subnet_info
-- ----------------------------
DROP TRIGGER IF EXISTS `before_insert_subnetinfo`;
delimiter ;;
CREATE TRIGGER `before_insert_subnetinfo` BEFORE INSERT ON `subnet_info` FOR EACH ROW BEGIN
    IF NEW.map_subnet_id IS NULL OR NEW.map_subnet_id = '' THEN
        SET NEW.map_subnet_id = UUID();
    END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
