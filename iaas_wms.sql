/*
 Navicat Premium Data Transfer

 Source Server         : IaaS pro
 Source Server Type    : MySQL
 Source Server Version : 80034 (8.0.34)
 Source Host           : iaas-center.mysql.rds.aliyuncs.com:3306
 Source Schema         : iaas_wms

 Target Server Type    : MySQL
 Target Server Version : 80034 (8.0.34)
 File Encoding         : 65001

 Date: 29/12/2025 11:06:33
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for _deprecated_bill
-- ----------------------------
DROP TABLE IF EXISTS `_deprecated_bill`;
CREATE TABLE `_deprecated_bill` (
  `id` int NOT NULL AUTO_INCREMENT,
  `region_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '区域id',
  `tenant_order_id` int NOT NULL COMMENT '订单id',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '租户id',
  `instance_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例id',
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '规格id',
  `bill_type` int NOT NULL COMMENT '账单类型，1-普通账单，2-差价账单，3-溢价账单',
  `bill_period` int NOT NULL COMMENT '账单周期，1-日账单，2-月账单',
  `bill_date` date NOT NULL COMMENT '账单日期',
  `mount` int NOT NULL COMMENT '账单金额，单位：分',
  `service_time` int NOT NULL COMMENT '使用时长，单位：分钟',
  `bill_start_time` datetime NOT NULL COMMENT '计费开始时间',
  `bill_end_time` datetime NOT NULL COMMENT '计费结束时间',
  `status` int NOT NULL COMMENT '状态，1-包月中，2-已退订，3-日结算',
  `source` int NOT NULL COMMENT '数据来源，1-自有，2-导入',
  `order` int DEFAULT NULL COMMENT '排序字段',
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `modify_time` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `instance_order_date_type_unique` (`bill_date`,`instance_uid`,`tenant_order_id`,`bill_type`) USING BTREE,
  KEY `order_index` (`bill_date`,`tenant_order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=122060 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for _deprecated_bill_compare_detail
-- ----------------------------
DROP TABLE IF EXISTS `_deprecated_bill_compare_detail`;
CREATE TABLE `_deprecated_bill_compare_detail` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bill_compare_record_id` int NOT NULL COMMENT '账单比对记录id',
  `instance_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '实例id',
  `bill_start_time` datetime(6) DEFAULT NULL COMMENT '计费开始时间',
  `bill_end_time` datetime(6) DEFAULT NULL COMMENT '计费结束时间',
  `service_time` int DEFAULT NULL COMMENT '计费时长，单位：分钟',
  `mount` int DEFAULT NULL COMMENT '费用，单位：分',
  `map_instance_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '供应商实例id',
  `map_bill_start_time` datetime(6) DEFAULT NULL COMMENT '供应商计费开始时间',
  `map_bill_end_time` datetime(6) DEFAULT NULL COMMENT '供应商计费结束时间',
  `map_service_time` int DEFAULT NULL COMMENT '供应商计费时长，单位：分钟',
  `map_mount` int DEFAULT NULL COMMENT '供应商费用，单位：分',
  `data_result` int DEFAULT NULL COMMENT '数据核对结果，1-iaas未记录，2-供应商未记录，3-正常',
  `time_result` int DEFAULT NULL COMMENT '时长核对结果，1-iaas偏长，2-供应商偏长，3-正常',
  `mount_result` int DEFAULT NULL COMMENT '金额核对结果，1-iaas偏大，2-供应商偏大，3-正常',
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `modify_time` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bill_compare_record_index` (`bill_compare_record_id`,`instance_uid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for _deprecated_bill_compare_record
-- ----------------------------
DROP TABLE IF EXISTS `_deprecated_bill_compare_record`;
CREATE TABLE `_deprecated_bill_compare_record` (
  `id` int NOT NULL AUTO_INCREMENT,
  `supplier_billing_id` json DEFAULT NULL COMMENT '供应商账单id列表',
  `supplier_account_id` json DEFAULT NULL COMMENT '供应商账号id列表，为空为全部',
  `generate_time` datetime(6) DEFAULT NULL COMMENT '结果生成时间',
  `start_time` datetime(6) NOT NULL COMMENT 'iaas账单起始时间',
  `end_time` datetime(6) NOT NULL COMMENT 'iaas账单终止时间',
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `modify_time` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `bill_type` tinyint NOT NULL DEFAULT '1' COMMENT '实例类型，1-实例账单，2-带宽账单，3-共享盘账单，4-云硬盘账单',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for _deprecated_history
-- ----------------------------
DROP TABLE IF EXISTS `_deprecated_history`;
CREATE TABLE `_deprecated_history` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_type` int NOT NULL COMMENT '用户类型，0：租户，1:员工',
  `user_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '用户唯一标识，租户为租户账号，内部用户为用户名',
  `operator_info` json NOT NULL COMMENT '本次操作记录信息',
  `operator_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '本次操作类型，该字段单独取出，方便索引',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for _deprecated_income
-- ----------------------------
DROP TABLE IF EXISTS `_deprecated_income`;
CREATE TABLE `_deprecated_income` (
  `id` int NOT NULL AUTO_INCREMENT,
  `instance_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例id',
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '规格id',
  `bill_date` date NOT NULL COMMENT '账单日期',
  `mount` int NOT NULL COMMENT '账单金额，单位：分',
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `modify_time` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `instance_date_unique` (`bill_date`,`instance_uid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=26197 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for _deprecated_instance_price
-- ----------------------------
DROP TABLE IF EXISTS `_deprecated_instance_price`;
CREATE TABLE `_deprecated_instance_price` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `region_uid` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '机房id',
  `spec` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '规格id',
  `batch` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '批次',
  `resource_id` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '资源id',
  `month_price` decimal(10,2) NOT NULL COMMENT '按月刊例价，单位：分',
  `day_price` decimal(10,2) NOT NULL COMMENT '按日刊例价，单位：分',
  `type` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '类型',
  `comment` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` int NOT NULL COMMENT '状态，0：有效，1：无效，2：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for _deprecated_spec
-- ----------------------------
DROP TABLE IF EXISTS `_deprecated_spec`;
CREATE TABLE `_deprecated_spec` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `resource_type` int NOT NULL COMMENT '0：实例，1：存储，2：裸金属',
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '规格名',
  `origin_spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '供应商提供的原始规格名',
  `state` int NOT NULL COMMENT '状态：0：有效，1：无效，2：删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_spec` (`spec`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for _deprecated_supplier_billing_income
-- ----------------------------
DROP TABLE IF EXISTS `_deprecated_supplier_billing_income`;
CREATE TABLE `_deprecated_supplier_billing_income` (
  `id` int NOT NULL AUTO_INCREMENT,
  `instance_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例id',
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '规格id',
  `bill_date` date NOT NULL COMMENT '账单日期',
  `mount` int NOT NULL COMMENT '账单金额，单位：分',
  `supplier_billing_info_id` int unsigned NOT NULL COMMENT '所属供应商账单信息id,记录该项成本由供应商账单的哪一条记录拆分出来的',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间,管理字段',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间,管理字段',
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间,管理字段',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_bill_instance_uid_bill_date` (`supplier_billing_info_id`,`instance_uid`,`bill_date`) USING BTREE COMMENT '每天每个实例只有一个账单',
  KEY `idx_supplier_billing_info_id` (`supplier_billing_info_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC COMMENT='从供应商账单记录表中解析出来的成本记录表';

-- ----------------------------
-- Table structure for bare_metal
-- ----------------------------
DROP TABLE IF EXISTS `bare_metal`;
CREATE TABLE `bare_metal` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `bare_metal_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '裸金属的唯一标识字符串',
  `region_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '区域',
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '规格',
  `arch` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '架构',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `delete_time` datetime DEFAULT NULL,
  `state` int NOT NULL COMMENT '状态，0：有效，1：无效，2：已删除',
  `supplier_bare_metal_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '供应商裸金属唯一标识',
  `supplier_spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '供应商板卡规格',
  `supplier_account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '供应商账号信息',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_bare_metal_uid` (`bare_metal_uid`),
  KEY `idx_supplier_bare_metal_uid` (`supplier_bare_metal_uid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=642780 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for bare_metal_price
-- ----------------------------
DROP TABLE IF EXISTS `bare_metal_price`;
CREATE TABLE `bare_metal_price` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `region_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '机房',
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '规格',
  `batch` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '批次',
  `resource_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '资源id',
  `month_price` decimal(10,2) NOT NULL COMMENT '包月价格，单位分',
  `day_price` decimal(10,2) NOT NULL COMMENT '按日单价，单位分',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '类型',
  `comment` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` int NOT NULL COMMENT '状态，0：有效，1：无效，2：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for bill_compare_overview
-- ----------------------------
DROP TABLE IF EXISTS `bill_compare_overview`;
CREATE TABLE `bill_compare_overview` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `product_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '产品',
  `supplier_account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '供应商账号',
  `region_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '机房',
  `machine_spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL,
  `estimate_day_duration` int NOT NULL COMMENT '按日预估成本时长，单位天',
  `estimate_day_amount` decimal(14,2) NOT NULL COMMENT '按日预估成本，单位分',
  `estimate_month_duration` decimal(10,2) NOT NULL COMMENT '按月预估成本时长，单位月',
  `estimate_month_amount` decimal(14,2) NOT NULL COMMENT '按月预估成本金额，单位分',
  `reality_cost_day_duration` int NOT NULL COMMENT '按日实际成本时长，单位天',
  `reality_cost_day_amount` decimal(14,2) NOT NULL COMMENT '按日实际成本金额，单位分',
  `reality_cost_month_duration` decimal(10,2) NOT NULL COMMENT '按月实际成本时长，单位月',
  `reality_cost_month_amount` decimal(14,2) NOT NULL COMMENT '按月实际成本金额，单位分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `bill_compare_record_id` int unsigned NOT NULL COMMENT '对账记录id',
  `bill_period` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '所属账期',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for bill_compare_record
-- ----------------------------
DROP TABLE IF EXISTS `bill_compare_record`;
CREATE TABLE `bill_compare_record` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_period` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '账期',
  `bill_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '账单类型',
  `supplier_billing_id` int unsigned NOT NULL COMMENT '供应商账单id',
  `supplier_account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '供应商账号',
  `iaas_bill_period` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'iaas账单账期',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for bill_compare_result
-- ----------------------------
DROP TABLE IF EXISTS `bill_compare_result`;
CREATE TABLE `bill_compare_result` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `gpu_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '',
  `supplier_gpu_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '',
  `estimate_cost_duration` int NOT NULL DEFAULT '0',
  `estimate_cost_bill_start_time` datetime NOT NULL DEFAULT '0001-01-01 00:00:00',
  `estimate_cost_bill_end_time` datetime NOT NULL DEFAULT '0001-01-01 00:00:00',
  `estimate_cost_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `reality_cost_duration` int NOT NULL DEFAULT '0',
  `reality_cost_bill_start_time` datetime NOT NULL DEFAULT '0001-01-01 00:00:00',
  `reality_cost_bill_end_time` datetime NOT NULL DEFAULT '0001-01-01 00:00:00',
  `reality_cost_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `machine_spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '',
  `region_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '机房',
  `supplier_account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '供应商账号',
  `compare_result` int NOT NULL DEFAULT '0' COMMENT '比较结果',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `bill_compare_record_id` int unsigned NOT NULL DEFAULT '0' COMMENT '对账记录id',
  `bill_period` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '所属账期',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for bill_record
-- ----------------------------
DROP TABLE IF EXISTS `bill_record`;
CREATE TABLE `bill_record` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '账单类型',
  `bill_period` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '账期',
  `trigger_mode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '触发方式，自动出账，人工补账',
  `bill_time_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '月末账单，月中账单。月末账单每月只能有一次，月中账单每月可以有多次。',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '出账状态，处理中，成功，失败',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=106322 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for data_image
-- ----------------------------
DROP TABLE IF EXISTS `data_image`;
CREATE TABLE `data_image` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '租户账号',
  `data_image_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '唯一标识',
  `type` int NOT NULL COMMENT '镜像类型：0：公共镜像，1：私有镜像',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` int NOT NULL COMMENT '状态，0：有效，1：无效，2：已删除',
  `image_name` varchar(255) COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '镜像名称',
  `image_tags` json DEFAULT NULL COMMENT '镜像标签',
  `size_gb` bigint DEFAULT '0' COMMENT '数据集大小',
  `model_desc_short` text COLLATE utf8mb4_0900_as_cs COMMENT '数据集描述',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_data_image_uid` (`data_image_uid`) USING BTREE,
  KEY `idx_tenant_account` (`tenant_account`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6663 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for discount_info
-- ----------------------------
DROP TABLE IF EXISTS `discount_info`;
CREATE TABLE `discount_info` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `instance_spec` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例规格',
  `amount` decimal(65,15) NOT NULL COMMENT '优惠金额，单位分',
  `number` int NOT NULL DEFAULT '1' COMMENT '优惠实例数量。当前每张券默认用于一个实例。',
  `description` varchar(1024) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '备注',
  `applicable_scope` json NOT NULL COMMENT '优惠适用范围，json列表。可选项:购买实例、续费实例等',
  `discount_origin_scope` json NOT NULL COMMENT '优惠获取范围，json列表。可选项:新购，邀请等',
  `effective_start_time` datetime NOT NULL COMMENT '优惠生效时间',
  `effective_end_time` datetime NOT NULL COMMENT '优惠结束时间',
  `can_stacked` tinyint NOT NULL DEFAULT '0' COMMENT '优惠是否可以叠加使用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_instance_spec` (`instance_spec`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for estimate_cost_bill
-- ----------------------------
DROP TABLE IF EXISTS `estimate_cost_bill`;
CREATE TABLE `estimate_cost_bill` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `gpu_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'GPU ID,根据裸金属id和卡数自动生成',
  `billing_time` datetime NOT NULL COMMENT '出账时间',
  `period_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '计费模式，包月还是包日',
  `charge_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '预付费还是后付费',
  `bill_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '扣费还是退款',
  `product_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '计费项目',
  `machine_spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '机器规格',
  `region_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '机房',
  `bill_start_time` datetime NOT NULL COMMENT '开始计费时间',
  `bill_end_time` datetime NOT NULL COMMENT '结束计费时间',
  `bill_duration` int NOT NULL COMMENT '计费时长，单位秒',
  `use_duration` int NOT NULL COMMENT '实际使用时长，单位秒',
  `usage` int NOT NULL COMMENT '用量',
  `usage_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '用量单位',
  `amount` decimal(10,2) NOT NULL COMMENT '金额，单位分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `bill_period` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '账期',
  `bill_record_id` int unsigned NOT NULL COMMENT '出账记录id',
  `supplier_account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '供应商账号信息',
  `full_month` tinyint NOT NULL COMMENT '使用时长是否够一个完整的月，是：1，否：0',
  `bare_metal_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '所属裸金属的唯一标识字符串',
  `arch` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '机器架构类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=572892 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for estimate_cost_bill_overview
-- ----------------------------
DROP TABLE IF EXISTS `estimate_cost_bill_overview`;
CREATE TABLE `estimate_cost_bill_overview` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_record_id` int unsigned NOT NULL COMMENT '出账记录id',
  `bill_period` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '账期',
  `supplier_account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '供应商账号',
  `machine_spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '机器规格',
  `region_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '机房',
  `product_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '产品，计费项目',
  `day_duration` int NOT NULL COMMENT '按日时长，单位日',
  `day_amount` decimal(14,2) NOT NULL COMMENT '按日金额，单位分',
  `month_duration` decimal(10,2) NOT NULL COMMENT '按月时长，单位月',
  `month_amount` decimal(14,2) NOT NULL COMMENT '按月金额，单位分',
  `total_amount` decimal(14,2) NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1529 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for iaas_bandwidth
-- ----------------------------
DROP TABLE IF EXISTS `iaas_bandwidth`;
CREATE TABLE `iaas_bandwidth` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bill_compare_record_id` int DEFAULT NULL COMMENT '账单比对记录id',
  `region_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '区域id',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '租户id',
  `amount_month_95` int DEFAULT NULL COMMENT '月95峰值价钱，单位：分',
  `amount_day_95_mean` int DEFAULT NULL COMMENT '日95峰值月平均价钱，单位：分',
  `bandwidth_month_95` int DEFAULT NULL COMMENT '月95峰值带宽，单位：Mbps',
  `bandwidth_day_95_mean` int DEFAULT NULL COMMENT '日95峰值月平均带宽，单位：Mbps',
  `start_date` date NOT NULL COMMENT '起始时间',
  `end_date` date NOT NULL COMMENT '终止时间',
  `create_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `modify_time` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for iaas_machine_sync
-- ----------------------------
DROP TABLE IF EXISTS `iaas_machine_sync`;
CREATE TABLE `iaas_machine_sync` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `supplier_sn` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT 'cmdb设备sn,pcf为固资sn+编号，Server为固资sn.对应iaas这边machine_info中的supplier_sn',
  `supplier_instance_name` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '供应商实例名',
  `data_operate_type` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '数据同步方式，新增：add，删除：delete,信息修改：modify',
  `iaas_machine_id` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT 'iaas物理机id',
  `uidc` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '统一机房编号',
  `idc_name_in_cmdb` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT 'uidc代表的机房在cmdb中的机房名',
  `cmdb_machine_configuration` varchar(1024) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '机器在cmdb侧的配置',
  `machine_spec_id` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '机器在iaas侧的机器规格',
  `machine_type` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '机器类型，PCF,SERVER,AIC',
  `ipmi` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT 'ipmi',
  `system_ip` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '系统iP',
  `ipmi_passwd` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT 'IpmiPasswd',
  `ipmi_user` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT 'IpmiUser',
  `pxe_mac` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT 'pxe启动dhcp网卡mac地址,对应cmdb中的mac地址',
  `node_index` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '节点编号，自建机器sub刀片编号，core节点编号与这里的node_index是一样的',
  `gpu_num` int NOT NULL DEFAULT '0' COMMENT '显卡数量，pcf为1，server为多个',
  `data_operate_task_state` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT 'Pending' COMMENT '数据处理状态，待处理：Pending，处理中：Processing，处理失败：Failed',
  `message` varchar(2048) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '如果task_state为Failed,这里填入错误排查的相关信息',
  `is_managed` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'iaas是否完全纳管，完全纳管为1，虚线纳管为0',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '数据添加时间',
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '程序修改时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '数据修改时间',
  `map_spec_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '供应商规格ID',
  `supplier` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '供应商',
  `map_idc_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '供应商ID',
  `aic_instance_data` json NOT NULL COMMENT '同步增加aic数据时填入aic信息',
  `map_account_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '阿里数据所属账号uid',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_supplier_sn` (`supplier_sn`) USING BTREE,
  KEY `machine_id_idx` (`iaas_machine_id`) USING BTREE,
  KEY `uidc_idx` (`uidc`) USING BTREE,
  KEY `idc_name_in_cmdb_idx` (`idc_name_in_cmdb`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7077167 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for iaas_machine_sync_blacklist
-- ----------------------------
DROP TABLE IF EXISTS `iaas_machine_sync_blacklist`;
CREATE TABLE `iaas_machine_sync_blacklist` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `supplier_sn` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `comment` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `supplier_sn_idx` (`supplier_sn`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=664 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for instance
-- ----------------------------
DROP TABLE IF EXISTS `instance`;
CREATE TABLE `instance` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `region_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '区域',
  `instance_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例唯一标识字符串序列',
  `bare_metal_id` int unsigned NOT NULL COMMENT '所属裸金属id',
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '该实例的规格',
  `architecture` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '实例架构',
  `bill_status` int NOT NULL DEFAULT '0' COMMENT '实例出账状态,0:正常，1：续约未出账，2：退订未出帐',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例所属租户账号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modify_time` datetime DEFAULT NULL COMMENT '当modify_time发生变化时，记录modify_time旧值',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例业务状态，比如：正常，操作受限等',
  `supplier_order_id` int unsigned NOT NULL COMMENT '供应单id',
  `tenant_order_id` int unsigned NOT NULL COMMENT '订单id,这里用于填入订单id,起到锁定的作用。平台采购时，填入0',
  `last_tenant_order_id` int unsigned DEFAULT NULL COMMENT '当tenant_order_id发生变化时，记录tenant_order_id的旧值',
  `state` int NOT NULL COMMENT '状态，0：有效，1：无效，2：已删除',
  `pre_sell` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '预售用户',
  `instance_reuse` tinyint(1) NOT NULL DEFAULT '0' COMMENT '实例复用模式：0:release(释放实例),1:shutdown（实例关机）,2:ignore（不做任何处理）',
  `keep_pre_sell_state` tinyint(1) DEFAULT NULL COMMENT '释放实例时是否保留预售状态',
  `supplier_sub_account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '供应商子账号ID',
  `supplier_instance_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '供应商实例id',
  `supplier_bare_metal_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '供应商物理机id',
  `supplier_idc_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '供应商机房名',
  `supplier_instance_spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '供应商实例规格名',
  `instance_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '实例类型',
  `tenant_tag` json NOT NULL COMMENT '租户tag',
  `system_tag` json NOT NULL COMMENT '系统tag',
  `comment` varchar(10240) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '[计费公共字段]记录相关的错误信息，方便问题排查',
  `sale_time` datetime DEFAULT NULL COMMENT '[计费公共字段]实例出售时间',
  `payment_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '[计费公共字段]实例付费类型，预付费PrePaid，后付费PostPaid',
  `operation_record` json DEFAULT NULL COMMENT '[计费公共字段]为一个列表，比如[0,0],分别表示停机命名是否发送，释放命令是否发送。已发送的命令不再重复发送。',
  `renew_status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '[预付费字段]实例续约状态',
  `expiration_time` datetime DEFAULT NULL COMMENT '[预付费字段]实例过期时间',
  `auto_renewal` tinyint DEFAULT NULL COMMENT '[预付费字段]是否自动续费，0不自动续费，1自动续费',
  `notify_record` json DEFAULT NULL COMMENT '[预付费字段]为一个列表，比如[0,0,0,0,0]，分别表示到期前 1 天，到期前 2 个小时，到期前 10 分钟，到期时，释放时通知用户，已经通知，则相应的位置改为1.不再重复通知',
  `payment_period_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '[预付费字段]选择预付费时，这里填入付费时长单位，小时hour，日Day，月Month',
  `usage_based_billing_method` int DEFAULT NULL COMMENT '[后付费字段]选择后付费时，这里记录按量计费方式',
  `start_report_time` datetime DEFAULT NULL COMMENT '[后付费字段]实例开始上报(计算部分正常)时间',
  `network_health_time` datetime DEFAULT NULL COMMENT '[后付费字段]网络正常时间',
  `stop_report_time` datetime DEFAULT NULL COMMENT '[后付费字段]实例停止上报(计算部分不正常)时间',
  `post_paid_bill_time` datetime DEFAULT NULL COMMENT '[后付费字段]实例计费成功时间',
  `instance_modify_record_id` bigint unsigned DEFAULT NULL COMMENT '[后付费字段]实例状态变更记录id',
  `last_tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '[计费公共字段]实例最近一次用户归属，释放的时候设置，备查',
  `instance_resource_manager_mode` int NOT NULL DEFAULT '0' COMMENT '[计费公共字段]实例资源运营模式',
  `renew_time` datetime DEFAULT NULL COMMENT '[预付费字段]实例续约时间',
  `err_type` varchar(255) COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '故障类型',
  `err_description` text COLLATE utf8mb4_0900_as_cs COMMENT '故障描述',
  `resource_id` varchar(256) COLLATE utf8mb4_0900_as_cs DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_instance_uid` (`instance_uid`),
  KEY `idx_tenant_account` (`tenant_account`) USING BTREE,
  KEY `idx_bare_metal_id` (`bare_metal_id`) USING BTREE,
  KEY `idx_tenant_order_id` (`tenant_order_id`) USING BTREE,
  KEY `idx_payment_type` (`payment_type`) USING BTREE,
  KEY `idx_instance_resource_manager_mode` (`instance_resource_manager_mode`) USING BTREE,
  KEY `idx_state` (`state`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2113958 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for instance_income_bill
-- ----------------------------
DROP TABLE IF EXISTS `instance_income_bill`;
CREATE TABLE `instance_income_bill` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '租户账户',
  `instance_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例id',
  `billing_time` datetime NOT NULL COMMENT '出账时间',
  `tenant_order_id` int unsigned NOT NULL COMMENT '关联订单id',
  `period_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '计费模式，包月还是包日',
  `charge_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '付费类型，预付费还是后付费',
  `bill_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '扣费还是退款',
  `product_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '产品，计费项目',
  `instance_spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例规格',
  `region_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '机房',
  `bill_start_time` datetime NOT NULL COMMENT '开始计费时间',
  `bill_end_time` datetime NOT NULL COMMENT '结束计费时间',
  `bill_duration` int NOT NULL COMMENT '计费时长，单位秒',
  `use_duration` int NOT NULL COMMENT '使用时长，单位秒',
  `usage` int NOT NULL COMMENT '用量',
  `usage_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '用量单位',
  `amount` decimal(10,2) NOT NULL COMMENT '应付金额，单位分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `bill_period` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '账期',
  `bill_record_id` int unsigned NOT NULL COMMENT '出账记录id',
  `machine_spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例所在机器规格',
  `full_month` tinyint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_instance_bill` (`instance_uid`,`tenant_order_id`,`bill_period`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1399895 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for instance_income_bill_overview
-- ----------------------------
DROP TABLE IF EXISTS `instance_income_bill_overview`;
CREATE TABLE `instance_income_bill_overview` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `bill_record_id` int NOT NULL COMMENT '出账记录id',
  `bill_period` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '账期',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '租户',
  `instance_spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例规格',
  `region_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '机房',
  `product_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '产品，计费项目',
  `day_duration` int NOT NULL COMMENT '按日时长，单位天',
  `day_amount` decimal(14,2) NOT NULL COMMENT '按日金额，单位分',
  `month_duration` decimal(10,2) NOT NULL COMMENT '包月时长，单位月',
  `month_amount` decimal(14,2) NOT NULL COMMENT '包月金额，单位分',
  `total_amount` decimal(14,2) NOT NULL COMMENT '总金额，单位分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5241 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for instance_modify_record
-- ----------------------------
DROP TABLE IF EXISTS `instance_modify_record`;
CREATE TABLE `instance_modify_record` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `instance_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例id，唯一标识',
  `modify_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '变更类型',
  `message_time` datetime NOT NULL COMMENT '消息时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_modify` (`instance_uid`,`modify_type`,`message_time`) USING BTREE,
  KEY `idx_instance_uid` (`instance_uid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=48400 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for instance_operation_record
-- ----------------------------
DROP TABLE IF EXISTS `instance_operation_record`;
CREATE TABLE `instance_operation_record` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `instance_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例uid',
  `tenant_order_id` int unsigned NOT NULL COMMENT '实例关联订单id',
  `operation_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例操作记录，创建，续费，释放',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  `renewal_duration` int DEFAULT NULL COMMENT '续费操作时，续费时长',
  `renewal_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '续费操作时，续费时长单位',
  `duration_until_expiration_time` int NOT NULL DEFAULT '0' COMMENT '实际释放时间与到期时间之间的时间差，单位秒',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for instance_paid_bill
-- ----------------------------
DROP TABLE IF EXISTS `instance_paid_bill`;
CREATE TABLE `instance_paid_bill` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `instance_uid` varchar(64) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例id',
  `tenant_account` varchar(64) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '账单归属租户',
  `payment_type` varchar(16) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '[计费公共字段]实例付费类型，预付费PrePaid，后付费PostPaid',
  `charge_start_time` datetime NOT NULL COMMENT '按量付费账单起始时间/预付费账单续费开始时间',
  `charge_end_time` datetime NOT NULL COMMENT '按量付费账单结束时间/预付费账单续费过期时间',
  `instance_modify_record_id` bigint unsigned NOT NULL COMMENT '实例修改记录id',
  `amount` decimal(65,15) NOT NULL COMMENT '费用，单位分',
  `tenant_order_id` int unsigned DEFAULT NULL COMMENT '实例创建时，会有订单id，续费时没有订单id',
  `discount_amount` decimal(65,15) NOT NULL COMMENT '使用了优惠券时，优惠券抵扣费用，单位分',
  `balance_amount` decimal(65,15) NOT NULL COMMENT '从支付钱包中扣除的费用，单位分',
  `pay_info` json NOT NULL COMMENT '与支付信息',
  `balance_change` json DEFAULT NULL COMMENT '账单关联流水',
  `reason` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '计费原因',
  `status` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '支付状态，未支付，成功或者失败',
  `create_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '最近更新时间',
  `modify_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '最后修改时间',
  `addition_field` bigint unsigned NOT NULL DEFAULT '0' COMMENT '账单出账时间戳，单位纳秒，关机/释放事件触发时填0(唯一)',
  `comment` varchar(1024) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '备注,账单失败时，失败原因记录到这里',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_uid_tenant_record` (`instance_uid`,`instance_modify_record_id`,`addition_field`) USING BTREE COMMENT '同一个用户的同一个实例的同一次变更只计费一次',
  UNIQUE KEY `idx_charge_duration` (`instance_uid`,`charge_start_time`,`charge_end_time`) USING BTREE COMMENT '同一个实例，同一段时间，只能计费一次',
  KEY `idx_create_time` (`create_time`) USING BTREE,
  KEY `idx_payment_type` (`payment_type`) USING BTREE,
  KEY `idx_tenant_account` (`tenant_account`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=422309 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for instance_price
-- ----------------------------
DROP TABLE IF EXISTS `instance_price`;
CREATE TABLE `instance_price` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `region_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '机房id',
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '规格id',
  `batch` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '批次',
  `resource_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '资源id',
  `month_price` decimal(10,2) NOT NULL COMMENT '按月刊例价，单位：分',
  `day_price` decimal(10,2) NOT NULL COMMENT '按日刊例价，单位：分',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '类型',
  `comment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` int NOT NULL COMMENT '状态，0：有效，1：无效，2：已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for instance_tpl
-- ----------------------------
DROP TABLE IF EXISTS `instance_tpl`;
CREATE TABLE `instance_tpl` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tpl_name` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '模板名称',
  `type` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '模板类型 instance 实例，baremetal 裸金属',
  `template` json DEFAULT NULL COMMENT '模板配置json字符串，用于存储前端创建实例裸金属的表单字段',
  `description` varchar(255) COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '模板描述',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for instance_wait_release
-- ----------------------------
DROP TABLE IF EXISTS `instance_wait_release`;
CREATE TABLE `instance_wait_release` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `instance_uid` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '实例唯一标识',
  `supplier_instance_id` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '供应商实例id',
  `supplier_instance_name` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '供应商实例名',
  `hypervisor_id` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '实例所在裸金属唯一标识',
  `idc_id` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '机房id',
  `supplier_idc_id` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '供应商机房id',
  `buy_time` datetime NOT NULL COMMENT '购买时间',
  `supplier_sale_time` datetime NOT NULL COMMENT '供应商售出时间',
  `expiration_time` datetime NOT NULL COMMENT '本账期到期时间',
  `supplier_expiration_time` datetime NOT NULL COMMENT '本账期供应商提供的到期时间',
  `renewed` tinyint NOT NULL COMMENT '是否已经提前续约',
  `next_expiration_time` datetime NOT NULL COMMENT '已经续约的情况下，下一个账期到期时间',
  `supplier_next_expiration_time` datetime NOT NULL COMMENT '已经续约的情况下，下一个账期供应商提供的到期时间',
  `spec` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例规格，实例为裸金属时为裸金属规格',
  `supplier_spec` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '供应商实例规格',
  `supplier` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '供应商',
  `cloud_vendor` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例产商信息',
  `map_account_uid` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '供应商账号uid',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `current_billing_start_time_from_create_time` datetime DEFAULT NULL COMMENT '当前账期开始时间。由阿里的实例创建时间计算而来',
  `current_billing_start_time_from_expiration_time` datetime DEFAULT NULL COMMENT '当前账期开始时间。由阿里的实例到期时间计算而来',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_supplier_instance_id` (`supplier_instance_id`),
  KEY `idx_instance_uid` (`instance_uid`) USING BTREE,
  KEY `idx_hypervisor_id` (`hypervisor_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=196174 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for ip
-- ----------------------------
DROP TABLE IF EXISTS `ip`;
CREATE TABLE `ip` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'ip地址',
  `ip_int_value` bigint NOT NULL COMMENT 'ipv4对应的整数值',
  `ip_version` smallint NOT NULL COMMENT 'ip地址版本，0：IPv4,1:ipv6',
  `ip_type` smallint NOT NULL COMMENT 'ip类型，1:公网ip,0:内网ip',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '所属租户账号',
  `instance_id` int unsigned NOT NULL COMMENT '所属实例账号',
  `region_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '区域',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` int NOT NULL COMMENT '状态，0：有效，1：无效，2：已删除',
  `purpose` json NOT NULL COMMENT '用途',
  `comment` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '备注',
  `network_line` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '线路',
  `binding_nat` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '绑定nat',
  `instance_architecture` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '所属实例架构',
  `ip_id` varchar(64) COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT 'ip资源id',
  `map_account_id` int DEFAULT '0' COMMENT '供应商账号id',
  `capture_time` datetime DEFAULT NULL COMMENT '采集时间',
  `ignore_error` tinyint NOT NULL DEFAULT '0' COMMENT '是否忽略报错',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_ip_region_id_account` (`ip`,`region_uid`,`ip_id`,`map_account_id`) USING BTREE,
  KEY `idx_tenant_account` (`tenant_account`) USING BTREE,
  KEY `idx_instance_id` (`instance_id`) USING BTREE,
  KEY `idx_ip_int_value` (`ip_int_value`) USING BTREE,
  KEY `idx_ip_instance_id` (`ip`,`instance_id`) USING BTREE,
  KEY `idx_region_uid_instance_id` (`region_uid`,`instance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1908698 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for job_info
-- ----------------------------
DROP TABLE IF EXISTS `job_info`;
CREATE TABLE `job_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `job_id` varchar(128) DEFAULT NULL,
  `task_id` varchar(128) DEFAULT NULL,
  `job_type` varchar(256) DEFAULT NULL,
  `is_close` tinyint(1) DEFAULT NULL,
  `state` varchar(128) DEFAULT NULL,
  `err_msg` text,
  `job_params` json DEFAULT NULL,
  `instance_id` varchar(128) DEFAULT NULL,
  `map_instance_id` varchar(128) DEFAULT NULL,
  `hypervisor_id` varchar(128) DEFAULT NULL,
  `instance_spec_id` varchar(128) DEFAULT NULL,
  `machine_spec_id` varchar(128) DEFAULT NULL,
  `map_account_id` varchar(128) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `start_time` datetime(6) DEFAULT NULL,
  `end_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_job_key_unique` (`job_id`),
  KEY `task_id` (`task_id`),
  KEY `state` (`state`),
  KEY `job_type` (`job_type`),
  KEY `instance_id` (`instance_id`),
  KEY `hypervisor_id` (`hypervisor_id`),
  KEY `map_instance_id` (`map_instance_id`),
  KEY `machine_spec_id` (`machine_spec_id`),
  KEY `instance_spec_id` (`instance_spec_id`),
  KEY `map_account_id` (`map_account_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11388 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for network
-- ----------------------------
DROP TABLE IF EXISTS `network`;
CREATE TABLE `network` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `idc_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '机房信息，在其他表中可能是region字段',
  `network_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '网络id',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '租户账号',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` int NOT NULL COMMENT '状态：0：有效，1：无效，2：已经删除',
  `pre_sell` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '预售用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_network` (`network_id`) USING BTREE,
  KEY `idx_tenant_network` (`tenant_account`,`idc_id`,`network_id`,`state`) USING BTREE,
  KEY `idx_pre_sell` (`pre_sell`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for order_detail
-- ----------------------------
DROP TABLE IF EXISTS `order_detail`;
CREATE TABLE `order_detail` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_classification` int NOT NULL COMMENT '订单分类，1，租户订单，2，采购单，3，供应单',
  `order_type` int NOT NULL COMMENT '订单类型，0:，新购，1，退货，2，续费',
  `order_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '订单唯一标识',
  `user_type` int NOT NULL COMMENT '用户类型，0，租户，1，员工',
  `user_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '租户为账号名，员工为员工唯一标识',
  `resource_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '资源uid',
  `resource_type` int NOT NULL COMMENT '资源类型，0：实例，1，存储',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_resource_uid` (`resource_uid`) USING BTREE,
  KEY `idx_order_uid` (`order_uid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3128381 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for post_paid_bill
-- ----------------------------
DROP TABLE IF EXISTS `post_paid_bill`;
CREATE TABLE `post_paid_bill` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `instance_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例id',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '账单归属租户',
  `charge_start_time` datetime NOT NULL COMMENT '该账单起始时间',
  `charge_end_time` datetime NOT NULL COMMENT '该账单结束时间',
  `instance_modify_record_id` bigint unsigned NOT NULL COMMENT '实例修改记录id',
  `amount` decimal(65,15) NOT NULL COMMENT '额定金额，单位分',
  `discount_amount` decimal(65,15) NOT NULL COMMENT '使用了优惠券时，优惠券抵扣费用，单位分',
  `balance_amount` decimal(65,15) NOT NULL COMMENT '从支付钱包中扣除的费用，单位分',
  `pay_info` json NOT NULL COMMENT '支付信息',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '计费原因',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '支付状态，未支付，成功或者失败',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `comment` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '备注',
  `addition_field` bigint unsigned NOT NULL DEFAULT '0' COMMENT '定时任务出账，该字段填时间戳，单位纳秒，其他情况填0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_uid_tenant_record` (`instance_uid`,`tenant_account`,`instance_modify_record_id`,`addition_field`) USING BTREE COMMENT '同一个用户的同一个实例的同一次变更只计费一次',
  UNIQUE KEY `idx_charge_duration` (`instance_uid`,`charge_start_time`,`charge_end_time`) USING BTREE COMMENT '同一个实例，同一段时间，只能计费一次',
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for pre_paid_bill
-- ----------------------------
DROP TABLE IF EXISTS `pre_paid_bill`;
CREATE TABLE `pre_paid_bill` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `instance_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '实例id',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '账单归属租户',
  `expiration_time_before_renewal` datetime DEFAULT NULL COMMENT '预付费实例续费账单，这里填入续费前的实例过期时间',
  `expiration_time_after_renewal` datetime DEFAULT NULL COMMENT '预付费实例续费账单，这里填入续费后的实例过期时间',
  `amount` decimal(65,15) NOT NULL COMMENT '费用，单位分',
  `discount_amount` decimal(65,15) NOT NULL COMMENT '使用了优惠券时，优惠券累计折扣金额，单位分',
  `balance_amount` decimal(65,15) NOT NULL COMMENT '从钱包中扣除的金额,单位分',
  `tenant_order_id` int unsigned DEFAULT NULL COMMENT '实例创建时，会有订单id，续费时没有订单id',
  `pay_info` json DEFAULT NULL COMMENT '支付信息',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '计费原因',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '支付状态，未支付，成功或者失败',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `comment` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '备注,账单失败时，失败原因记录到这里',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_uid_tenant_expiration_time` (`instance_uid`,`tenant_account`,`expiration_time_before_renewal`,`expiration_time_after_renewal`) USING BTREE COMMENT '同一个用户的同一个实例一段时间只能有一个账单',
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for purchase_order
-- ----------------------------
DROP TABLE IF EXISTS `purchase_order`;
CREATE TABLE `purchase_order` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `purchase_order_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '唯一标识',
  `resource_type` int NOT NULL COMMENT '资源类型，0：实例，1：存储',
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '本次采购的商品规格',
  `number` int NOT NULL COMMENT '本次采购的商品数量',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '采购单状态',
  `purchase_strategy` json NOT NULL COMMENT '采购策略信息',
  `order_type` int NOT NULL COMMENT '订单类型，采购，退还',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `message` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '采购单失败时，填入失败信息',
  `supplier_resource_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '供应商资源id,预占用资源并锁定供应商资源',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_purchase_order_uid` (`purchase_order_uid`)
) ENGINE=InnoDB AUTO_INCREMENT=383500 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for reality_cost_bill
-- ----------------------------
DROP TABLE IF EXISTS `reality_cost_bill`;
CREATE TABLE `reality_cost_bill` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `gpu_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'GPU ID,根据裸金属id和卡数自动生成',
  `billing_time` datetime NOT NULL COMMENT '出账时间',
  `period_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '计费模式，包月还是包日',
  `charge_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '预付费还是后付费',
  `bill_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '扣费还是退款',
  `product_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '计费项目',
  `machine_spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '机器规格',
  `region_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '机房',
  `bill_start_time` datetime NOT NULL COMMENT '开始计费时间',
  `bill_end_time` datetime NOT NULL COMMENT '结束计费时间',
  `bill_duration` int NOT NULL COMMENT '计费时长，单位秒',
  `use_duration` int NOT NULL COMMENT '实际使用时长，单位秒',
  `usage` int NOT NULL COMMENT '用量',
  `usage_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '用量单位',
  `amount` decimal(10,2) NOT NULL COMMENT '金额，单位分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `bill_period` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '账期',
  `supplier_billing_id` int unsigned NOT NULL COMMENT '供应商账单id',
  `supplier_billing_info_id` int unsigned NOT NULL COMMENT '供应商账单明细id',
  `supplier_account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '供应商账号信息',
  `full_month` tinyint NOT NULL COMMENT '使用时长是否够一个完整的月，是：1，否：0',
  `supplier_bare_metal_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '供应商裸金属实例唯一标识',
  `arch` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '机器架构',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for reality_cost_bill_overview
-- ----------------------------
DROP TABLE IF EXISTS `reality_cost_bill_overview`;
CREATE TABLE `reality_cost_bill_overview` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `supplier_billing_id` int unsigned NOT NULL COMMENT '供应商账单id',
  `bill_period` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '账单',
  `supplier_account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '供应商账号',
  `machine_spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '机器规格',
  `region_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '机房',
  `product_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '计费项目',
  `day_duration` int NOT NULL COMMENT '按日时长，单位日',
  `day_amount` decimal(10,2) NOT NULL COMMENT '按日金额，单位分',
  `month_duration` decimal(10,2) NOT NULL COMMENT '按月时长，单位月',
  `month_amount` decimal(10,2) NOT NULL COMMENT '按月金额，单位分',
  `total_amount` decimal(10,2) NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for reserve_detail
-- ----------------------------
DROP TABLE IF EXISTS `reserve_detail`;
CREATE TABLE `reserve_detail` (
  `id` int NOT NULL AUTO_INCREMENT,
  `resource_id` varchar(256) DEFAULT NULL,
  `spec_id` varchar(128) DEFAULT NULL,
  `spec_name` varchar(128) DEFAULT NULL,
  `idc_id` varchar(128) DEFAULT NULL,
  `network_id` varchar(128) DEFAULT NULL,
  `vlan_id` varchar(128) DEFAULT NULL,
  `count` int DEFAULT NULL,
  `start_time` datetime(6) DEFAULT NULL,
  `expire_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `resource_id` (`resource_id`),
  KEY `spec_id` (`spec_id`),
  KEY `idc_id` (`idc_id`),
  KEY `network_id` (`network_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for reserve_info
-- ----------------------------
DROP TABLE IF EXISTS `reserve_info`;
CREATE TABLE `reserve_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `resource_id` varchar(256) DEFAULT NULL,
  `is_close` tinyint(1) DEFAULT NULL,
  `start_time` datetime(6) DEFAULT NULL,
  `expire_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `tenant_account` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_task_key_unique` (`resource_id`),
  KEY `is_close` (`is_close`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for storage
-- ----------------------------
DROP TABLE IF EXISTS `storage`;
CREATE TABLE `storage` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '规格',
  `storage_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '存储唯一标识字符串',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '所属租户账号信息',
  `instance_id` int unsigned NOT NULL COMMENT '所属实例id',
  `region_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '区域',
  `capacity` int NOT NULL COMMENT '容量',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` int NOT NULL COMMENT '状态，0：有效，1：无效，2：已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_storage_uid` (`storage_uid`),
  KEY `idx_tenant_account` (`tenant_account`) USING BTREE,
  KEY `idx_instance_id` (`instance_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for subnet
-- ----------------------------
DROP TABLE IF EXISTS `subnet`;
CREATE TABLE `subnet` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `network_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL,
  `subnet_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` int NOT NULL COMMENT '状态字段，0：正常，1：禁用，2软删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_network_subnet` (`network_id`,`subnet_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for supplier
-- ----------------------------
DROP TABLE IF EXISTS `supplier`;
CREATE TABLE `supplier` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '供应商id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '供应商名字',
  `comment` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '备注',
  `state` int NOT NULL COMMENT '状态，0：有效，1：无效，2：已删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=420951 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for supplier_account_info
-- ----------------------------
DROP TABLE IF EXISTS `supplier_account_info`;
CREATE TABLE `supplier_account_info` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `owner_account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'Owner账号ID',
  `owner_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'Owner账号',
  `account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '账号ID',
  `account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '账号',
  `supplier_id` int unsigned NOT NULL COMMENT '所属供应商id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_supplier_id_account_id` (`supplier_id`,`account_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=25504 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for supplier_bandwidth
-- ----------------------------
DROP TABLE IF EXISTS `supplier_bandwidth`;
CREATE TABLE `supplier_bandwidth` (
  `id` int NOT NULL AUTO_INCREMENT,
  `supplier_account` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '供应商account',
  `supplier_billing_id` int NOT NULL COMMENT '供应商带宽账单id',
  `amount` int NOT NULL COMMENT '金额，单位：分',
  `bandwidth` int NOT NULL COMMENT '带宽，单位：Mbps',
  `start_time` date NOT NULL COMMENT '开始日期',
  `end_time` date NOT NULL COMMENT '结束日期',
  `create_time` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `update_time` datetime(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `modify_time` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for supplier_billing
-- ----------------------------
DROP TABLE IF EXISTS `supplier_billing`;
CREATE TABLE `supplier_billing` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `filename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '导入文件时的文件名',
  `bill_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '导入文件时输入的账单标题',
  `ownership_period` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '所属账期',
  `supplier_id` int unsigned NOT NULL COMMENT '供应商id',
  `comment` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `bill_type` tinyint NOT NULL DEFAULT '1' COMMENT '账单类型，1-arm实例账单，2-带宽账单， 3-共享存储账单，4-x86实例账单，5-云硬盘存储账单',
  `preprocessed` int NOT NULL DEFAULT '0' COMMENT '账单是否被预处理过了，0没有，1处理过了，不进行重复处理',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_bill_title` (`bill_title`) USING BTREE COMMENT '账单标题需要唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC COMMENT='供应商账单记录表';

-- ----------------------------
-- Table structure for supplier_billing_info
-- ----------------------------
DROP TABLE IF EXISTS `supplier_billing_info`;
CREATE TABLE `supplier_billing_info` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id,管理字段',
  `accounting_period` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '账期',
  `financial_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '财务单元',
  `account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '账号ID',
  `account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '账号',
  `owner_account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT 'Owner账号ID',
  `owner_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT 'Owner账号',
  `product_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '产品Code',
  `product` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '产品',
  `product_detail_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '产品明细Code',
  `product_detail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '产品明细',
  `consumption_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '消费类型',
  `consumption_time` datetime DEFAULT NULL COMMENT '消费时间',
  `billing_start_time` datetime DEFAULT NULL COMMENT '账单开始时间',
  `billing_end_time` datetime DEFAULT NULL COMMENT '账单结束时间',
  `service_duration` decimal(10,2) DEFAULT NULL COMMENT '服务时长',
  `order_number_bill_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '订单号/账单号',
  `related_order_number_bill_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '关联订单号/账单号',
  `bill_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '账单类型',
  `billing_method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费方式',
  `instance_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '实例ID',
  `instance_nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '实例昵称',
  `resource_group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '资源组',
  `instance_tags` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '实例标签',
  `instance_config` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '实例配置',
  `instance_spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '实例规格',
  `public_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '公网IP',
  `private_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '私网IP',
  `region` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '地域',
  `availability_zone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '可用区',
  `list_price` decimal(10,2) DEFAULT NULL COMMENT '官网价',
  `discount_amount` decimal(10,2) DEFAULT NULL COMMENT '优惠金额',
  `coupon_deduction` decimal(10,2) DEFAULT NULL COMMENT '优惠券抵扣',
  `amount_due` decimal(10,2) DEFAULT NULL COMMENT '应付金额',
  `cash_payment` decimal(10,2) DEFAULT NULL COMMENT '现金支付',
  `cash_credit_deduction` decimal(10,2) DEFAULT NULL COMMENT '代金券抵扣',
  `stored_value_card_payment_amount` decimal(10,2) DEFAULT NULL COMMENT '储值卡支付金额',
  `arrears_amount` decimal(10,2) DEFAULT NULL COMMENT '欠费金额',
  `currency` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '币种',
  `duration_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '时长单位',
  `billing_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费编号',
  `business_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '业务类型',
  `credit_limit_refund_deduction` decimal(10,2) DEFAULT NULL COMMENT '信用额度退款抵扣',
  `related_supplier_billing_info_id_list` json NOT NULL COMMENT '在供应商账单中，有些账单同属于一个实例，在分析时需要聚合，这里将关联记录聚合到一个列表',
  `supplier_billing_id` int unsigned NOT NULL COMMENT '所属供应商账单id,管理字段',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间,管理字段',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间,管理字段',
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间,管理字段',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_supplier_billing_id` (`supplier_billing_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC COMMENT='供应商账单信息表';

-- ----------------------------
-- Table structure for supplier_order
-- ----------------------------
DROP TABLE IF EXISTS `supplier_order`;
CREATE TABLE `supplier_order` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `supplier_order_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '唯一标识',
  `spec` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '商品规格',
  `number` int unsigned NOT NULL COMMENT '商品数量',
  `supplier_id` int unsigned NOT NULL COMMENT '供应商id',
  `purchase_order_id` int unsigned NOT NULL COMMENT '与本供应商订单相对应的采购单id',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '供应商订单状态',
  `order_type` int NOT NULL COMMENT '订单类型，创建还是销毁',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `supplier_order_create_time` datetime DEFAULT NULL COMMENT '供应单创建时间（供应商的时间）',
  `supplier_account_id` int unsigned NOT NULL COMMENT '供应商账号信息。兼容旧接口，保留supplier_id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_supplier_order_uid` (`supplier_order_uid`),
  KEY `idx_supplier_id` (`supplier_id`) USING BTREE,
  KEY `idx_purchase_order_id` (`purchase_order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=425732 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for supplier_shared_storage_billing_info
-- ----------------------------
DROP TABLE IF EXISTS `supplier_shared_storage_billing_info`;
CREATE TABLE `supplier_shared_storage_billing_info` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id,管理字段',
  `billing_period` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '账期',
  `financial_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '财务单元',
  `account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '账号ID',
  `account_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '账号',
  `owner_account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT 'Owner账号ID',
  `owner_account_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT 'Owner账号',
  `product_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '产品Code',
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '产品',
  `product_detail_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '产品明细Code',
  `product_detail_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '产品明细',
  `consumption_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '消费类型',
  `consumption_time` datetime DEFAULT NULL COMMENT '消费时间',
  `bill_start_time` datetime DEFAULT NULL COMMENT '账单开始时间',
  `bill_end_time` datetime DEFAULT NULL COMMENT '账单结束时间',
  `service_duration` decimal(10,2) DEFAULT NULL COMMENT '服务时长',
  `order_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '订单号/账单号',
  `related_order_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '关联订单号/账单号',
  `bill_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '账单类型',
  `billing_method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费方式',
  `instance_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '实例ID',
  `instance_nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '实例昵称',
  `resource_group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '资源组',
  `instance_tag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '实例标签',
  `instance_configuration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '实例配置',
  `instance_specification` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '实例规格',
  `public_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '公网IP',
  `private_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '私网IP',
  `region` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '地域',
  `availability_zone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '可用区',
  `billing_item` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费项',
  `unit_price` decimal(10,2) DEFAULT NULL COMMENT '单价',
  `unit_price_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '单价单位',
  `usage` decimal(10,2) DEFAULT NULL COMMENT '用量',
  `usage_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '用量单位',
  `resource_package_deduction` decimal(10,2) DEFAULT NULL COMMENT '资源包抵扣',
  `official_price` decimal(10,2) DEFAULT NULL COMMENT '官网价',
  `discount_amount` decimal(10,2) DEFAULT NULL COMMENT '优惠金额',
  `coupon_deduction` decimal(10,2) DEFAULT NULL COMMENT '优惠券抵扣',
  `payable_amount` decimal(10,2) DEFAULT NULL COMMENT '应付金额',
  `cash_payment` decimal(10,2) DEFAULT NULL COMMENT '现金支付',
  `voucher_deduction` decimal(10,2) DEFAULT NULL COMMENT '代金券抵扣',
  `stored_value_card_payment` decimal(10,2) DEFAULT NULL COMMENT '储值卡支付金额',
  `arrears_amount` decimal(10,2) DEFAULT NULL COMMENT '欠费金额',
  `currency` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '币种',
  `duration_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '时长单位',
  `deduction_including_ri` decimal(10,2) DEFAULT NULL COMMENT '抵扣量（含RI）',
  `discount_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '优惠名称',
  `single_product_discount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '单品优惠',
  `combined_discount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '组合优惠',
  `billing_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费编号',
  `savings_plan_deduction_amount` decimal(10,2) DEFAULT NULL COMMENT '节省计划抵扣金额',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '备注',
  `business_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '业务类型',
  `credit_refund_deduction` decimal(10,2) DEFAULT NULL COMMENT '信用额度退款抵扣',
  `billing_item_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费项Code',
  `billing_rule_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费规则说明',
  `unit_price_factor` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '单价因子',
  `billing_factor` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费因子',
  `billing_formula` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费公式',
  `deduction_resource_package_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '抵扣资源包ID',
  `deduction_resource_package_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '抵扣资源包名称',
  `resource_package_deduction_amount` decimal(10,2) DEFAULT NULL COMMENT '资源包抵扣量',
  `pre_deduction_usage` decimal(10,2) DEFAULT NULL COMMENT '抵扣前用量',
  `post_deduction_usage` decimal(10,2) DEFAULT NULL COMMENT '抵扣后用量',
  `discount_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '优惠ID',
  `discount_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '优惠类型',
  `discount_content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '优惠内容',
  `contract_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '合同编号',
  `usage_duration` decimal(10,2) DEFAULT NULL COMMENT '使用时长',
  `billing_cycle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费周期',
  `general_usage` decimal(10,2) DEFAULT NULL COMMENT '广义用量',
  `billing_process` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费过程',
  `savings_plan_total_deduction` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '节省计划抵扣目录总价',
  `savings_plan_instance_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '节省计划实例ID',
  `primary_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '主键',
  `supplier_billing_id` int unsigned NOT NULL COMMENT '所属供应商账单id,管理字段',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间,管理字段',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间,管理字段',
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间,管理字段',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_supplier_bill_id` (`supplier_billing_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for supplier_x86_billing_info
-- ----------------------------
DROP TABLE IF EXISTS `supplier_x86_billing_info`;
CREATE TABLE `supplier_x86_billing_info` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id,管理字段',
  `billing_period` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '账期',
  `financial_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '财务单元',
  `account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '账号ID',
  `account_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '账号',
  `owner_account_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT 'Owner账号ID',
  `owner_account_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT 'Owner账号',
  `product_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '产品Code',
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '产品',
  `product_detail_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '产品明细Code',
  `product_detail_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '产品明细',
  `consumption_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '消费类型',
  `consumption_time` datetime DEFAULT NULL COMMENT '消费时间',
  `bill_start_time` datetime DEFAULT NULL COMMENT '账单开始时间',
  `bill_end_time` datetime DEFAULT NULL COMMENT '账单结束时间',
  `service_duration` decimal(10,2) DEFAULT NULL COMMENT '服务时长',
  `order_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '订单号/账单号',
  `related_order_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '关联订单号/账单号',
  `bill_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '账单类型',
  `billing_method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费方式',
  `instance_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '实例ID',
  `instance_nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '实例昵称',
  `resource_group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '资源组',
  `instance_tag` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '实例标签',
  `instance_configuration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '实例配置',
  `instance_specification` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '实例规格',
  `public_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '公网IP',
  `private_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '私网IP',
  `region` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '地域',
  `availability_zone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '可用区',
  `billing_item` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费项',
  `unit_price` decimal(10,2) DEFAULT NULL COMMENT '单价',
  `unit_price_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '单价单位',
  `usage` decimal(10,2) DEFAULT NULL COMMENT '用量',
  `usage_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '用量单位',
  `resource_package_deduction` decimal(10,2) DEFAULT NULL COMMENT '资源包抵扣',
  `official_price` decimal(10,2) DEFAULT NULL COMMENT '官网价',
  `discount_amount` decimal(10,2) DEFAULT NULL COMMENT '优惠金额',
  `coupon_deduction` decimal(10,2) DEFAULT NULL COMMENT '优惠券抵扣',
  `payable_amount` decimal(10,2) DEFAULT NULL COMMENT '应付金额',
  `cash_payment` decimal(10,2) DEFAULT NULL COMMENT '现金支付',
  `voucher_deduction` decimal(10,2) DEFAULT NULL COMMENT '代金券抵扣',
  `stored_value_card_payment` decimal(10,2) DEFAULT NULL COMMENT '储值卡支付金额',
  `arrears_amount` decimal(10,2) DEFAULT NULL COMMENT '欠费金额',
  `currency` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '币种',
  `duration_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '时长单位',
  `deduction_including_ri` decimal(10,2) DEFAULT NULL COMMENT '抵扣量（含RI）',
  `discount_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '优惠名称',
  `single_product_discount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '单品优惠',
  `combined_discount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '组合优惠',
  `billing_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费编号',
  `savings_plan_deduction_amount` decimal(10,2) DEFAULT NULL COMMENT '节省计划抵扣金额',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '备注',
  `business_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '业务类型',
  `credit_refund_deduction` decimal(10,2) DEFAULT NULL COMMENT '信用额度退款抵扣',
  `billing_item_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费项Code',
  `billing_rule_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费规则说明',
  `unit_price_factor` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '单价因子',
  `billing_factor` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费因子',
  `billing_formula` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费公式',
  `deduction_resource_package_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '抵扣资源包ID',
  `deduction_resource_package_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '抵扣资源包名称',
  `resource_package_deduction_amount` decimal(10,2) DEFAULT NULL COMMENT '资源包抵扣量',
  `pre_deduction_usage` decimal(10,2) DEFAULT NULL COMMENT '抵扣前用量',
  `post_deduction_usage` decimal(10,2) DEFAULT NULL COMMENT '抵扣后用量',
  `discount_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '优惠ID',
  `discount_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '优惠类型',
  `discount_content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '优惠内容',
  `contract_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '合同编号',
  `usage_duration` decimal(10,2) DEFAULT NULL COMMENT '使用时长',
  `billing_cycle` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费周期',
  `general_usage` decimal(10,2) DEFAULT NULL COMMENT '广义用量',
  `billing_process` varchar(2550) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '计费过程',
  `savings_plan_total_deduction` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '节省计划抵扣目录总价',
  `savings_plan_instance_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '节省计划实例ID',
  `primary_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '主键',
  `supplier_billing_id` int unsigned NOT NULL COMMENT '所属供应商账单id,管理字段',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间,管理字段',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间,管理字段',
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间,管理字段',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for system_image
-- ----------------------------
DROP TABLE IF EXISTS `system_image`;
CREATE TABLE `system_image` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '租户账号',
  `system_image_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '系统盘镜像uid',
  `type` int NOT NULL COMMENT '镜像类型：0：公共镜像，1：私有镜像',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` int NOT NULL COMMENT '状态，0：有效，1：无效，2：已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_system_image_uid` (`system_image_uid`),
  KEY `idx_tenant_account` (`tenant_account`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=29830 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'tag名字',
  `tag_type` tinyint NOT NULL COMMENT 'tag类型，0：实例tag',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tag_scope_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT 'tag作用类型，0：租户tag,1:系统tag',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '租户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_name` (`tag_type`,`tag_scope_type`,`tenant_account`,`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=375 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for task_info
-- ----------------------------
DROP TABLE IF EXISTS `task_info`;
CREATE TABLE `task_info` (
  `id` int NOT NULL AUTO_INCREMENT,
  `task_id` varchar(128) DEFAULT NULL,
  `trace_id` varchar(128) DEFAULT NULL,
  `task_type` varchar(256) DEFAULT NULL,
  `total_count` int DEFAULT NULL,
  `success_count` int DEFAULT NULL,
  `failed_count` int DEFAULT NULL,
  `state` varchar(128) DEFAULT NULL,
  `err_msg` text,
  `task_params` json DEFAULT NULL,
  `is_close` tinyint(1) DEFAULT NULL,
  `start_time` datetime(6) DEFAULT NULL,
  `create_time` datetime(6) DEFAULT NULL,
  `end_time` datetime(6) DEFAULT NULL,
  `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `manager_task_key_unique` (`task_id`),
  KEY `trace_id` (`trace_id`),
  KEY `task_type` (`task_type`),
  KEY `state` (`state`)
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for tenant_discount_info
-- ----------------------------
DROP TABLE IF EXISTS `tenant_discount_info`;
CREATE TABLE `tenant_discount_info` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `discount_info_id` int unsigned NOT NULL COMMENT '折扣信息id',
  `tenant_account` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '用户账号信息',
  `discount_origin` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '优惠来源，枚举值',
  `used` tinyint NOT NULL DEFAULT '0' COMMENT '是否已经使用，0：未使用，1：已经使用',
  `balance` decimal(65,15) NOT NULL COMMENT '余额,单位分',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_tenant_account` (`tenant_account`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10420 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for tenant_idc_storage_quota
-- ----------------------------
DROP TABLE IF EXISTS `tenant_idc_storage_quota`;
CREATE TABLE `tenant_idc_storage_quota` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键编码',
  `tenant_account` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL,
  `idc_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL,
  `system_image_size` int DEFAULT '0' COMMENT '系统镜像配额大小，单位MB',
  `data_image_size` int DEFAULT '0' COMMENT '数据镜像配额大小，单位MB',
  `system_image_size_used` int DEFAULT '0' COMMENT '系统镜像使用容量，单位MB',
  `data_image_size_used` int DEFAULT '0' COMMENT '数据镜像使用容量，单位MB',
  `system_image_snapshot_size_used` int DEFAULT '0' COMMENT '系统镜像快照使用容量，单位MB',
  `data_image_snapshot_size_used` int DEFAULT '0' COMMENT '数据镜像快照使用容量，单位MB',
  `system_cloud_disk_size` int DEFAULT '0' COMMENT '系统云盘配额大小，单位MB',
  `data_cloud_disk_size` int DEFAULT '0' COMMENT '数据云盘配额大小，单位MB',
  `system_cloud_disk_size_used` int DEFAULT '0' COMMENT '系统云盘使用容量，单位MB',
  `data_cloud_disk_size_used` int DEFAULT '0' COMMENT '数据云盘使用容量，单位MB',
  `system_cloud_disk_snapshot_size_used` int DEFAULT '0' COMMENT '系统云盘快照使用容量，单位MB',
  `data_cloud_disk_snapshot_size_used` int DEFAULT '0' COMMENT '数据云盘快照使用容量，单位MB',
  `create_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '最近更新时间',
  `modify_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '最后修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tenant_idc_unq` (`tenant_account`,`idc_id`)
) ENGINE=InnoDB AUTO_INCREMENT=228 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for tenant_instance_stop_task
-- ----------------------------
DROP TABLE IF EXISTS `tenant_instance_stop_task`;
CREATE TABLE `tenant_instance_stop_task` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL,
  `countdown_start_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '倒计时开始时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for tenant_order
-- ----------------------------
DROP TABLE IF EXISTS `tenant_order`;
CREATE TABLE `tenant_order` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '订单id',
  `tenant_order_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '唯一标识',
  `shopping_cart_list` json NOT NULL COMMENT '购物车清单列表',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '订单状态，枚举值',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '租户账号',
  `order_type` int NOT NULL COMMENT '订单的类型，比如：新购，退货，续费等',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '程序修改时间',
  `message` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '如果订单失败，这里写入失败原因',
  `request_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '防止重放攻击，同一次请求只能下一次订单',
  `comment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '备注',
  `charge_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '付费类型，PrePaid：按时间付费，PostPaid：按流量付费',
  `usage_based_billing_method` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL COMMENT '选择后付费时，这里记录按量计费方式',
  `period` int NOT NULL COMMENT '时长，单位由 PeriodUnit 决定；只有 ChargeType 为 PrePaid 才必填/有意义',
  `period_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '时长单位，只有 ChargeType为PrePaid才有意义，默认为Month，可选值Month:月，Week:周,Day:日',
  `auto_renewal` int NOT NULL DEFAULT '0' COMMENT '是否自动续签，0：是，1：否，默认是0',
  `trace_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT 'trace_id',
  `purchase_order_id` int unsigned DEFAULT NULL COMMENT '如果这一单发生了采购，这里填入采购单id',
  `chargeable` tinyint unsigned DEFAULT NULL COMMENT '这一单是否需要付费，付费为1，付费失败，则订单不会创建，不付费为0',
  `pay_info` json DEFAULT NULL COMMENT '支付信息',
  `discount_coupon_id_list` varchar(255) COLLATE utf8mb4_0900_as_cs NOT NULL DEFAULT '' COMMENT '如果使用了优惠券下单，这里记录优惠价信息，多张优惠券id以逗号分隔',
  `discount_duration` int NOT NULL DEFAULT '0' COMMENT '使用优惠券下单时，优惠时长，单位小时',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_tenant_order_uid` (`tenant_order_uid`),
  KEY `idx_tenant_account` (`tenant_account`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=291624 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for tenant_resource_quota
-- ----------------------------
DROP TABLE IF EXISTS `tenant_resource_quota`;
CREATE TABLE `tenant_resource_quota` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs NOT NULL COMMENT '租户账号',
  `quota` json NOT NULL COMMENT '配额详情,字典列表',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_tenant_account` (`tenant_account`)
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Table structure for tenant_storage_quota
-- ----------------------------
DROP TABLE IF EXISTS `tenant_storage_quota`;
CREATE TABLE `tenant_storage_quota` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键编码',
  `tenant_account` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_as_cs DEFAULT NULL,
  `system_image_quota` int DEFAULT NULL,
  `data_image_quota` int DEFAULT NULL,
  `system_snapshot_quota` int DEFAULT NULL,
  `data_snapshot_quota` int DEFAULT NULL,
  `system_image_used` int DEFAULT NULL,
  `data_image_used` int DEFAULT NULL,
  `system_snapshot_used` int DEFAULT NULL,
  `data_snapshot_used` int DEFAULT NULL,
  `create_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '最近更新时间',
  `modify_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '最后修改时间',
  `system_cloud_disk` int DEFAULT '0' COMMENT '系统云盘配额数量',
  `data_cloud_disk` int DEFAULT '0' COMMENT '数据云盘配额数量',
  `system_image_size` int DEFAULT '0' COMMENT '系统镜像配额大小，单位MB',
  `data_image_size` int DEFAULT '0' COMMENT '数据镜像配额大小，单位MB',
  `system_image_size_used` int DEFAULT '0' COMMENT '系统镜像使用容量，单位MB',
  `data_image_size_used` int DEFAULT '0' COMMENT '数据镜像使用容量，单位MB',
  `system_cloud_disk_size` int DEFAULT '0' COMMENT '系统云盘配额大小，单位MB',
  `data_cloud_disk_size` int DEFAULT '0' COMMENT '数据云盘配额大小，单位MB',
  `system_cloud_disk_used` int DEFAULT '0' COMMENT '系统云盘配额使用数量',
  `data_cloud_disk_used` int DEFAULT '0' COMMENT '数据云盘配额使用数量',
  `system_cloud_disk_size_used` int DEFAULT '0' COMMENT '系统云盘使用容量，单位MB',
  `data_cloud_disk_size_used` int DEFAULT '0' COMMENT '数据云盘使用容量，单位MB',
  `system_cloud_disk_snapshot` int DEFAULT '0' COMMENT '每个系统云盘快照数量配额',
  `data_cloud_disk_snapshot` int DEFAULT '0' COMMENT '每个数据云盘快照数量配额',
  `system_cloud_disk_snapshot_used` int DEFAULT '0' COMMENT '每个系统盘快照数量已使用配额',
  `data_cloud_disk_snapshot_used` int DEFAULT '0' COMMENT '每个数据盘快照数量已使用配额',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_tenant_storage_quota_tenant_account` (`tenant_account`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_as_cs;

-- ----------------------------
-- Triggers structure for table instance
-- ----------------------------
DROP TRIGGER IF EXISTS `update_last_modify_time`;
delimiter ;;
CREATE TRIGGER `update_last_modify_time` BEFORE UPDATE ON `instance` FOR EACH ROW BEGIN
    IF NEW.modify_time <> OLD.modify_time THEN
        SET NEW.last_modify_time = OLD.modify_time;
END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table instance
-- ----------------------------
DROP TRIGGER IF EXISTS `update_last_tenant_order_id`;
delimiter ;;
CREATE TRIGGER `update_last_tenant_order_id` BEFORE UPDATE ON `instance` FOR EACH ROW BEGIN
    IF NEW.tenant_order_id <> OLD.tenant_order_id THEN
        SET NEW.last_tenant_order_id = OLD.tenant_order_id;
END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table instance
-- ----------------------------
DROP TRIGGER IF EXISTS `update_last_tenant_account`;
delimiter ;;
CREATE TRIGGER `update_last_tenant_account` BEFORE UPDATE ON `instance` FOR EACH ROW BEGIN
    IF OLD.tenant_account <> NEW.tenant_account THEN
    SET NEW.last_tenant_account = OLD.tenant_account;
END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
