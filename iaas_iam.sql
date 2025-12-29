/*
 Navicat Premium Data Transfer

 Source Server         : IaaS pro
 Source Server Type    : MySQL
 Source Server Version : 80034 (8.0.34)
 Source Host           : iaas-center.mysql.rds.aliyuncs.com:3306
 Source Schema         : iaas_iam

 Target Server Type    : MySQL
 Target Server Version : 80034 (8.0.34)
 File Encoding         : 65001

 Date: 29/12/2025 11:06:07
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for action
-- ----------------------------
DROP TABLE IF EXISTS `action`;
CREATE TABLE `action` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '该接口的描述',
  `classify` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '接口分类',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '程序修改时间',
  `state` int NOT NULL COMMENT '状态，0：有效，1：无效，2：已删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_url` (`url`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1288 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for invitation_register_record
-- ----------------------------
DROP TABLE IF EXISTS `invitation_register_record`;
CREATE TABLE `invitation_register_record` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '邀请用户',
  `invited_tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '被邀请用户',
  `revenue_amount` decimal(65,15) NOT NULL COMMENT '邀请收益金额',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `discount_coupon_list` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '邀请获取的优惠券id列表,以逗号分隔',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_tenant_account_create_time` (`tenant_account` DESC,`create_time` DESC) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3664 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for login_log
-- ----------------------------
DROP TABLE IF EXISTS `login_log`;
CREATE TABLE `login_log` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'tenant还是staff',
  `uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '用户唯一标识',
  `origin_ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '访问iP',
  `message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=780515 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for main_account
-- ----------------------------
DROP TABLE IF EXISTS `main_account`;
CREATE TABLE `main_account` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键编码',
  `account` varchar(128) DEFAULT NULL COMMENT '主账号account',
  `name` varchar(128) DEFAULT NULL COMMENT '主账号名称',
  `alias` varchar(128) DEFAULT NULL COMMENT '主账号别名',
  `description` varchar(255) DEFAULT NULL COMMENT '主账号描述',
  `active` tinyint(1) DEFAULT '1' COMMENT '激活状态',
  `create_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `update_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) COMMENT '最近更新时间',
  `modify_time` datetime(3) DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '最后修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_account` (`account`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Table structure for menu
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'directory(无页面),menu(有页面)',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '节点名称',
  `parent_id` int NOT NULL COMMENT '上级节点id,根目录上级节点id为0',
  `order_number` int NOT NULL COMMENT '同级节点内部排序',
  `page_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '前端页面url',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '图标',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` int NOT NULL COMMENT '状态，0：有效，1：无效，2：已删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for menu_operation
-- ----------------------------
DROP TABLE IF EXISTS `menu_operation`;
CREATE TABLE `menu_operation` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `menu_id` int unsigned NOT NULL COMMENT '菜单id',
  `operation_id` int unsigned NOT NULL COMMENT '权限(操作)id',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_menu_operation` (`menu_id`,`operation_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=868 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for open_api_auth_info
-- ----------------------------
DROP TABLE IF EXISTS `open_api_auth_info`;
CREATE TABLE `open_api_auth_info` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `tenant_id` int unsigned NOT NULL COMMENT '租户id',
  `access_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'ak',
  `access_secret` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'sk',
  `state` int NOT NULL COMMENT '状态，0：启用，1：禁用，2：已删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_access_key` (`access_key`) USING BTREE COMMENT 'ak不能重复',
  KEY `idx_tenant_id` (`tenant_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for operation
-- ----------------------------
DROP TABLE IF EXISTS `operation`;
CREATE TABLE `operation` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '唯一标识,unique_identification',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '显示名字',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` int NOT NULL COMMENT '状态，0：有效，1：无效，2：已删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_uid` (`uid`) USING BTREE,
  KEY `idx_name` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1818 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for operation_action
-- ----------------------------
DROP TABLE IF EXISTS `operation_action`;
CREATE TABLE `operation_action` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `operation_id` int unsigned NOT NULL,
  `action_id` int unsigned NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `type` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_operation_action` (`operation_id`,`action_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=556 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '角色名',
  `role_uid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '角色唯一标识',
  `state` int NOT NULL COMMENT '状态，0：有效，1：无效，2：已删除',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `admission_control` json NOT NULL COMMENT '准入控制约束字典列表',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_role_uid` (`role_uid`) USING BTREE COMMENT '唯一标识符唯一'
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for role_action
-- ----------------------------
DROP TABLE IF EXISTS `role_action`;
CREATE TABLE `role_action` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `action_id` int unsigned NOT NULL COMMENT '接口id',
  `role_id` int unsigned NOT NULL COMMENT '角色id',
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_role_action` (`role_id`,`action_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18255 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for tenant
-- ----------------------------
DROP TABLE IF EXISTS `tenant`;
CREATE TABLE `tenant` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `company_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '公司名称',
  `alias` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '别名',
  `account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '账号',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '密码',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '联系电话',
  `father_account_id` int unsigned NOT NULL DEFAULT '0' COMMENT '父账号id',
  `state` int NOT NULL COMMENT '状态，0：有效，1：无效，2：已删除',
  `comment` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `request_limit` int NOT NULL DEFAULT '1000' COMMENT '每秒钟url请求限制',
  `expired_instance_shutdown` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '用户实例到期后是否关机，默认值关机：1，不关机：0',
  `expired_instance_release` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '用户实例到期超过阈值后是否释放，默认释放：1，不释放：0',
  `tenant_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '租户类型',
  `chargeable` tinyint NOT NULL DEFAULT '0' COMMENT '是否纳入当前的计费策略',
  `origin_platform` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '用户来源',
  `invitation_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '个人专属邀请码',
  `invited_by_tenant_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '该用户是被谁邀请创建的',
  `wechat_official_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '[实名认证]关注的微信公众号,由微信消息通知传入',
  `wechat_open_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '[实名认证]用户在公众号下的 Open ID,由微信消息通知传入。微信公众号系统限制，每个用户针对每个公众号会产生一个安全的 OpenID，无法获得真实的用户微信号',
  `wechat_authentication_time` datetime DEFAULT NULL COMMENT '[实名认证]微信认证时间',
  `post_pay_time` datetime(6) DEFAULT NULL COMMENT '后付费最后付费的时间',
  `post_interval_minute` bigint DEFAULT '0' COMMENT '后付费账单计费周期(分钟)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_account` (`account`) USING BTREE,
  KEY `idx_company_name` (`company_name`) USING BTREE,
  KEY `idx_alias` (`alias`) USING BTREE,
  KEY `idx_father_account_id` (`father_account_id`) USING BTREE,
  KEY `idx_invitation_code` (`invitation_code`) USING BTREE,
  KEY `idx_invited_by_tenant_account` (`invited_by_tenant_account`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5783 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '用户名',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '昵称',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '电话',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '邮箱',
  `state` int NOT NULL DEFAULT '0' COMMENT '状态，0：有效，1：无效，2：已删除',
  `comment` varchar(2048) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `admission_control` json NOT NULL COMMENT '准入控制约束字典列表',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_username` (`username`) USING BTREE COMMENT '用户名唯一',
  UNIQUE KEY `idx_email` (`email`) USING BTREE COMMENT '邮箱唯一',
  KEY `idx_phone` (`phone`) USING BTREE COMMENT '电话'
) ENGINE=InnoDB AUTO_INCREMENT=267 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for user_action
-- ----------------------------
DROP TABLE IF EXISTS `user_action`;
CREATE TABLE `user_action` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '用户id',
  `action_id` int NOT NULL,
  `type` int NOT NULL COMMENT '1:exclusion,2:inclusion',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_user_action` (`user_id`,`type`,`action_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `role_id` int unsigned NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `modify_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_user_role` (`user_id`,`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=342 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

SET FOREIGN_KEY_CHECKS = 1;
