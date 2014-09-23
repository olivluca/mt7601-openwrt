#
# Copyright (C) 2007-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mt7601

PKG_VERSION:=3.0.0.4_20130913
PKG_RELEASE:=1
PKG_SOURCE_URL:=http://www.mediatek.com/AmazonS3/Downloads/linux/
PKG_MD5SUM:=5f440dccc8bc952745a191994fc34699

PKG_SOURCE:=DPO_MT7601U_LinuxSTA_$(PKG_VERSION).tar.bz2
PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/DPO_MT7601U_LinuxSTA_$(PKG_VERSION)
PKG_BUILD_PARALLEL:=1

PKG_USE_MIPS16:=0

PKG_MAINTAINER:=Luca Olivetti <luca@ventoso.org>

include $(INCLUDE_DIR)/package.mk

WMENU:=Wireless Drivers

define KernelPackage/mt7601
	SUBMENU:=Wireless Drivers
	TITLE:=Driver for MT7601U wireless adapters
	FILES:=$(PKG_BUILD_DIR)/os/linux/mt7601Usta.$(LINUX_KMOD_SUFFIX)
	DEPENDS:=+wireless-tools +hostapd-common-old @USB_SUPPORT
#	AUTOLOAD:=$(call AutoLoad,50,mt7601Usta)
endef

define KernelPackage/mt7601/description
  This package contains a driver for usb wireless adapters based on the mediatek MT7601U
endef

ifneq ($(CONFIG_BIG_ENDIAN),)
  ENDIANOPTS:=-DRT_BIG_ENDIAN
else
  ENDIANOPTS:=
endif
    
define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) LINUX_DIR=$(LINUX_DIR) KERNEL_CROSS=$(KERNEL_CROSS) ARCH=$(LINUX_KARCH) ENDIANOPTS=$(ENDIANOPTS)
endef

define KernelPackage/mt7601/install
	$(INSTALL_DIR) $(1)/etc/Wireless/RT2870STA/
	$(INSTALL_DIR) $(1)/lib/modules/$(LINUX_VERSION)
	$(CP) $(PKG_BUILD_DIR)/RT2870STA.dat $(1)/etc/Wireless/RT2870STA/
endef

$(eval $(call KernelPackage,mt7601))
