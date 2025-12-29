/*
 Navicat Premium Data Transfer

 Source Server         : IaaS pro
 Source Server Type    : MySQL
 Source Server Version : 80034 (8.0.34)
 Source Host           : iaas-center.mysql.rds.aliyuncs.com:3306
 Source Schema         : iaas_wallet

 Target Server Type    : MySQL
 Target Server Version : 80034 (8.0.34)
 File Encoding         : 65001

 Date: 29/12/2025 11:05:09
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for recharge_order
-- ----------------------------
DROP TABLE IF EXISTS `recharge_order`;
CREATE TABLE `recharge_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '用户名',
  `amount` int NOT NULL DEFAULT '0' COMMENT '变更金额',
  `order_id` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '订单ID',
  `state` int NOT NULL DEFAULT '0' COMMENT '订单状态 0待支付 1支付成功 2已关闭',
  `wx_transaction_id` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '微信支付交易ID',
  `pay_platform` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '支付平台',
  `created_at` datetime DEFAULT (now()) COMMENT '创建时间',
  `updated_at` datetime DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `completed_at` datetime DEFAULT NULL COMMENT '完成时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `order_id_idx` (`order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for spec_price
-- ----------------------------
DROP TABLE IF EXISTS `spec_price`;
CREATE TABLE `spec_price` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `instance_spec` varchar(64) COLLATE utf8mb4_bin NOT NULL COMMENT '实例规格',
  `idc_id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '机房ID',
  `hour_price` int NOT NULL DEFAULT '0' COMMENT '预付费每小时价格',
  `day_price` int NOT NULL DEFAULT '0' COMMENT '预付费每日价格',
  `week_price` int NOT NULL DEFAULT '0' COMMENT '预付费每周价格',
  `month_price` int NOT NULL DEFAULT '0' COMMENT '预付费每月价格',
  `paying_for_healthy_usage_duration` int NOT NULL DEFAULT '0' COMMENT '健康使用时长每小时价格',
  `created_at` datetime DEFAULT (now()) COMMENT '创建时间',
  `updated_at` datetime DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `spec_price_idx` (`instance_spec`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for user_balance
-- ----------------------------
DROP TABLE IF EXISTS `user_balance`;
CREATE TABLE `user_balance` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT (now()) COMMENT '创建时间',
  `updated_at` datetime DEFAULT (now()) ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `user_id` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '用户名',
  `balance` int NOT NULL DEFAULT '0' COMMENT '用户余额',
  `gift_balance` int NOT NULL DEFAULT '0' COMMENT '赠送余额',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4634 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for user_balance_changes
-- ----------------------------
DROP TABLE IF EXISTS `user_balance_changes`;
CREATE TABLE `user_balance_changes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '用户名',
  `amount` int NOT NULL DEFAULT '0' COMMENT '变更金额',
  `balance_after` int NOT NULL DEFAULT '0' COMMENT '变更后余额',
  `type` int DEFAULT NULL COMMENT '变更类型 0充值 1消费 2退款',
  `description` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '变更说明',
  `source` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '变更来源',
  `bill_id` int DEFAULT NULL COMMENT '账单ID',
  `tenant_order_id` int DEFAULT NULL COMMENT '预付费订单ID',
  `created_at` datetime DEFAULT (now()) COMMENT '创建时间',
  `gift_balance_after` int NOT NULL DEFAULT '0' COMMENT '变更后赠送余额',
  `balance_change` int NOT NULL DEFAULT '0' COMMENT '余额变更',
  `gift_balance_change` int NOT NULL DEFAULT '0' COMMENT '赠送余额变更',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id_created_at` (`user_id`,`created_at` DESC)
) ENGINE=InnoDB AUTO_INCREMENT=432119 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

SET FOREIGN_KEY_CHECKS = 1;
