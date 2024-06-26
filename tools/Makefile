#
# Copyright (C) 2006-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# Main makefile for the host tools
#
curdir:=tools

# subdirectories to descend into
tools-y :=

ifeq ($(CONFIG_EXTERNAL_TOOLCHAIN),)
  BUILD_TOOLCHAIN := y
endif
ifdef CONFIG_GCC_USE_GRAPHITE
  ifeq ($(CONFIG_GCC_USE_SYSTEM_PPL_CLOOG),)
    BUILD_PPL_CLOOG = y
  endif
endif
ifneq ($(CONFIG_PACKAGE_kmod-b43)$(CONFIG_PACKAGE_kmod-b43legacy)$(CONFIG_BRCMSMAC_USE_FW_FROM_WL),)
  BUILD_B43_TOOLS = y
endif

tools-$(BUILD_TOOLCHAIN) += gmp mpfr mpc libelf
tools-y += m4 libtool autoconf autoconf-archive automake flex bison pkgconf sed mklibs
tools-y += sstrip make-ext4fs e2fsprogs expat mtd-utils mkimage
tools-y += firmware-utils patch-image patch quilt yaffs2 flock padjffs2
tools-y += mm-macros meson missing-macros xz ninja cmake scons bc findutils gengetopt patchelf
tools-$(CONFIG_TARGET_orion_generic) += wrt350nv2-builder upslug2
#tools-y += ucl upx
tools-$(CONFIG_TARGET_x86) += qemu
tools-$(CONFIG_TARGET_mxs) += elftosb
# tools-$(CONFIG_TARGET_brcm2708)$(CONFIG_TARGET_sunxi)$(CONFIG_TARGET_mxs) += mtools dosfstools
tools-y += mtools dosfstools libressl
tools-$(CONFIG_TARGET_ar71xx) += lzma-old squashfs
tools-y += lzma squashfs4
tools-$(BUILD_B43_TOOLS) += b43-tools
tools-$(BUILD_PPL_CLOOG) += ppl cloog
tools-$(CONFIG_USE_SPARSE) += sparse

# builddir dependencies
#$(curdir)/upx/compile := $(curdir)/upx/install
$(curdir)/bison/compile := $(curdir)/flex/install
$(curdir)/flex/compile := $(curdir)/libtool/install
$(curdir)/pkgconf/compile := $(curdir)/sed/install
$(curdir)/libtool/compile := $(curdir)/sed/install $(curdir)/m4/install $(curdir)/autoconf/install $(curdir)/automake/install $(curdir)/missing-macros/install
$(curdir)/squashfs/compile := $(curdir)/lzma-old/install
$(curdir)/squashfs4/compile := $(curdir)/xz/install
$(curdir)/quilt/compile := $(curdir)/sed/install $(curdir)/autoconf/install $(curdir)/findutils/install
$(curdir)/autoconf/compile := $(curdir)/m4/install
$(curdir)/automake/compile := $(curdir)/m4/install $(curdir)/autoconf/install $(curdir)/pkgconf/install $(curdir)/xz/install
$(curdir)/gmp/compile := $(curdir)/libtool/install
$(curdir)/mpc/compile := $(curdir)/mpfr/install $(curdir)/gmp/install
$(curdir)/mpfr/compile := $(curdir)/gmp/install
$(curdir)/ppl/compile := $(curdir)/gmp/install
$(curdir)/cloog/compile := $(curdir)/ppl/install
$(curdir)/mtd-utils/compile := $(curdir)/e2fsprogs/install
$(curdir)/mkimage/compile := $(curdir)/sed/install
$(curdir)/mklibs/compile := $(curdir)/libtool/install
$(curdir)/qemu/compile := $(curdir)/e2fsprogs/install
$(curdir)/upslug2/compile := $(curdir)/libtool/install
$(curdir)/mm-macros/compile := $(curdir)/libtool/install
$(curdir)/missing-macros/compile := $(curdir)/autoconf/install
$(curdir)/e2fsprogs/compile := $(curdir)/libtool/install
$(curdir)/libelf/compile := $(curdir)/libtool/install
$(curdir)/sdcc/compile := $(curdir)/bison/install
$(curdir)/b43-tools/compile := $(curdir)/bison/install
$(curdir)/padjffs2/compile := $(curdir)/findutils/install
$(curdir)/cloog/compile := $(curdir)/ppl/install
$(curdir)/bc/compile := $(curdir)/bison/install
$(curdir)/findutils/compile := $(curdir)/bison/install
$(curdir)/gengetopt/compile := $(curdir)/libtool/install
$(curdir)/patchelf/compile := $(curdir)/libtool/install
$(curdir)/dosfstools/compile := $(curdir)/autoconf/install $(curdir)/automake/install
$(curdir)/meson/compile := $(curdir)/ninja/install
$(curdir)/libressl/compile := $(curdir)/pkgconf/install
$(curdir)/cmake/compile += $(curdir)/libressl/install $(curdir)/ninja/install

ifneq ($(CONFIG_CCACHE)$(CONFIG_SDK),)
$(foreach tool, $(filter-out patch ninja,$(tools-y)), $(eval $(curdir)/$(tool)/compile += $(curdir)/ccache/install))
tools-y += ccache
endif

# in case there is no patch tool on the host we need to make patch tool a
# dependency for tools which have patches directory
$(foreach tool, $(tools-y), $(if $(wildcard $(curdir)/$(tool)/patches),$(eval $(curdir)/$(tool)/compile += $(curdir)/patch/install)))

$(curdir)/builddirs := $(tools-y) $(tools-dep) $(tools-)
$(curdir)/builddirs-default := $(tools-y)

ifndef DUMP_TARGET_DB
define PrepareStaging
	@for dir in $(1); do ( \
		$(if $(QUIET),,set -x;) \
		mkdir -p "$$dir"; \
		cd "$$dir"; \
		mkdir -p bin lib include stamp; \
	); done
endef

# preparatory work
$(STAGING_DIR)/.prepared: $(TMP_DIR)/.build
	$(call PrepareStaging,$(STAGING_DIR))
	mkdir -p $(BUILD_DIR)/stamp
	touch $@

$(STAGING_DIR_HOST)/.prepared: $(TMP_DIR)/.build
	$(call PrepareStaging,$(STAGING_DIR_HOST))
	mkdir -p $(BUILD_DIR_HOST)/stamp $(STAGING_DIR_HOST)/include/sys
	$(INSTALL_DATA) $(TOPDIR)/tools/include/*.h $(STAGING_DIR_HOST)/include/
	$(INSTALL_DATA) $(TOPDIR)/tools/include/sys/*.h $(STAGING_DIR_HOST)/include/sys/
	ln -sf lib $(STAGING_DIR_HOST)/lib64
	touch $@

endif

$(curdir)//prepare = $(STAGING_DIR)/.prepared $(STAGING_DIR_HOST)/.prepared
$(curdir)//compile = $(STAGING_DIR)/.prepared $(STAGING_DIR_HOST)/.prepared

# prerequisites for the individual targets
$(curdir)/ := .config prereq
$(curdir)//install = $(1)/compile

tools_enabled = $(foreach tool,$(sort $(tools-y) $(tools-)),$(if $(filter $(tool),$(tools-y)),y,n))
$(eval $(call stampfile,$(curdir),tools,install,,_$(subst $(space),,$(tools_enabled))))
$(eval $(call subdir,$(curdir)))
