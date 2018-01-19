srcdir = /build/php-src-php-7.2.1/ext/opcache
builddir = /build/php-src-php-7.2.1/ext/opcache
top_srcdir = /build/php-src-php-7.2.1/ext/opcache
top_builddir = /build/php-src-php-7.2.1/ext/opcache
EGREP = /bin/grep -E
SED = /bin/sed
CONFIGURE_COMMAND = './configure'
CONFIGURE_OPTIONS =
SHLIB_SUFFIX_NAME = so
SHLIB_DL_SUFFIX_NAME = so
ZEND_EXT_TYPE = zend_extension
RE2C = exit 0;
AWK = nawk
shared_objects_opcache = ZendAccelerator.lo zend_accelerator_blacklist.lo zend_accelerator_debug.lo zend_accelerator_hash.lo zend_accelerator_module.lo zend_persist.lo zend_persist_calc.lo zend_file_cache.lo zend_shared_alloc.lo zend_accelerator_util_funcs.lo shared_alloc_shm.lo shared_alloc_mmap.lo shared_alloc_posix.lo Optimizer/zend_optimizer.lo Optimizer/pass1_5.lo Optimizer/pass2.lo Optimizer/pass3.lo Optimizer/optimize_func_calls.lo Optimizer/block_pass.lo Optimizer/optimize_temp_vars_5.lo Optimizer/nop_removal.lo Optimizer/compact_literals.lo Optimizer/zend_cfg.lo Optimizer/zend_dfg.lo Optimizer/dfa_pass.lo Optimizer/zend_ssa.lo Optimizer/zend_inference.lo Optimizer/zend_func_info.lo Optimizer/zend_call_graph.lo Optimizer/sccp.lo Optimizer/scdf.lo Optimizer/dce.lo Optimizer/compact_vars.lo Optimizer/zend_dump.lo
PHP_PECL_EXTENSION = opcache
PHP_MODULES =
PHP_ZEND_EX = $(phplibdir)/opcache.la
all_targets = $(PHP_MODULES) $(PHP_ZEND_EX)
install_targets = install-modules install-headers
prefix = /usr/local
exec_prefix = $(prefix)
libdir = ${exec_prefix}/lib
prefix = /usr/local
phplibdir = /build/php-src-php-7.2.1/ext/opcache/modules
phpincludedir = /usr/local/include/php
CC = cc
CFLAGS = -g -O2
CFLAGS_CLEAN = $(CFLAGS)
CPP = cc -E
CPPFLAGS = -DHAVE_CONFIG_H
CXX =
CXXFLAGS =
CXXFLAGS_CLEAN = $(CXXFLAGS)
EXTENSION_DIR = /usr/local/lib/php/20170718
PHP_EXECUTABLE = /usr/local/bin/php
EXTRA_LDFLAGS =
EXTRA_LIBS =
INCLUDES = -I/usr/local/include/php -I/usr/local/include/php/main -I/usr/local/include/php/TSRM -I/usr/local/include/php/Zend -I/usr/local/include/php/ext -I/usr/local/include/php/ext/date/lib
LFLAGS =
LDFLAGS =
SHARED_LIBTOOL =
LIBTOOL = $(SHELL) $(top_builddir)/libtool
SHELL = /bin/bash
INSTALL_HEADERS =
mkinstalldirs = $(top_srcdir)/build/shtool mkdir -p
INSTALL = $(top_srcdir)/build/shtool install -c
INSTALL_DATA = $(INSTALL) -m 644

DEFS = -DPHP_ATOM_INC -I$(top_builddir)/include -I$(top_builddir)/main -I$(top_srcdir)
COMMON_FLAGS = $(DEFS) $(INCLUDES) $(EXTRA_INCLUDES) $(CPPFLAGS) $(PHP_FRAMEWORKPATH)

all: $(all_targets)
	@echo
	@echo "Build complete."
	@echo "Don't forget to run 'make test'."
	@echo

build-modules: $(PHP_MODULES) $(PHP_ZEND_EX)

build-binaries: $(PHP_BINARIES)

libphp$(PHP_MAJOR_VERSION).la: $(PHP_GLOBAL_OBJS) $(PHP_SAPI_OBJS)
	$(LIBTOOL) --mode=link $(CC) $(CFLAGS) $(EXTRA_CFLAGS) -rpath $(phptempdir) $(EXTRA_LDFLAGS) $(LDFLAGS) $(PHP_RPATHS) $(PHP_GLOBAL_OBJS) $(PHP_SAPI_OBJS) $(EXTRA_LIBS) $(ZEND_EXTRA_LIBS) -o $@
	-@$(LIBTOOL) --silent --mode=install cp $@ $(phptempdir)/$@ >/dev/null 2>&1

libs/libphp$(PHP_MAJOR_VERSION).bundle: $(PHP_GLOBAL_OBJS) $(PHP_SAPI_OBJS)
	$(CC) $(MH_BUNDLE_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS) $(LDFLAGS) $(EXTRA_LDFLAGS) $(PHP_GLOBAL_OBJS:.lo=.o) $(PHP_SAPI_OBJS:.lo=.o) $(PHP_FRAMEWORKS) $(EXTRA_LIBS) $(ZEND_EXTRA_LIBS) -o $@ && cp $@ libs/libphp$(PHP_MAJOR_VERSION).so

install: $(all_targets) $(install_targets)

install-sapi: $(OVERALL_TARGET)
	@echo "Installing PHP SAPI module:       $(PHP_SAPI)"
	-@$(mkinstalldirs) $(INSTALL_ROOT)$(bindir)
	-@if test ! -r $(phptempdir)/libphp$(PHP_MAJOR_VERSION).$(SHLIB_DL_SUFFIX_NAME); then \
		for i in 0.0.0 0.0 0; do \
			if test -r $(phptempdir)/libphp$(PHP_MAJOR_VERSION).$(SHLIB_DL_SUFFIX_NAME).$$i; then \
				$(LN_S) $(phptempdir)/libphp$(PHP_MAJOR_VERSION).$(SHLIB_DL_SUFFIX_NAME).$$i $(phptempdir)/libphp$(PHP_MAJOR_VERSION).$(SHLIB_DL_SUFFIX_NAME); \
				break; \
			fi; \
		done; \
	fi
	@$(INSTALL_IT)

install-binaries: build-binaries $(install_binary_targets)

install-modules: build-modules
	@test -d modules && \
	$(mkinstalldirs) $(INSTALL_ROOT)$(EXTENSION_DIR)
	@echo "Installing shared extensions:     $(INSTALL_ROOT)$(EXTENSION_DIR)/"
	@rm -f modules/*.la >/dev/null 2>&1
	@$(INSTALL) modules/* $(INSTALL_ROOT)$(EXTENSION_DIR)

install-headers:
	-@if test "$(INSTALL_HEADERS)"; then \
		for i in `echo $(INSTALL_HEADERS)`; do \
			i=`$(top_srcdir)/build/shtool path -d $$i`; \
			paths="$$paths $(INSTALL_ROOT)$(phpincludedir)/$$i"; \
		done; \
		$(mkinstalldirs) $$paths && \
		echo "Installing header files:          $(INSTALL_ROOT)$(phpincludedir)/" && \
		for i in `echo $(INSTALL_HEADERS)`; do \
			if test "$(PHP_PECL_EXTENSION)"; then \
				src=`echo $$i | $(SED) -e "s#ext/$(PHP_PECL_EXTENSION)/##g"`; \
			else \
				src=$$i; \
			fi; \
			if test -f "$(top_srcdir)/$$src"; then \
				$(INSTALL_DATA) $(top_srcdir)/$$src $(INSTALL_ROOT)$(phpincludedir)/$$i; \
			elif test -f "$(top_builddir)/$$src"; then \
				$(INSTALL_DATA) $(top_builddir)/$$src $(INSTALL_ROOT)$(phpincludedir)/$$i; \
			else \
				(cd $(top_srcdir)/$$src && $(INSTALL_DATA) *.h $(INSTALL_ROOT)$(phpincludedir)/$$i; \
				cd $(top_builddir)/$$src && $(INSTALL_DATA) *.h $(INSTALL_ROOT)$(phpincludedir)/$$i) 2>/dev/null || true; \
			fi \
		done; \
	fi

PHP_TEST_SETTINGS = -d 'open_basedir=' -d 'output_buffering=0' -d 'memory_limit=-1'
PHP_TEST_SHARED_EXTENSIONS =  ` \
	if test "x$(PHP_MODULES)" != "x"; then \
		for i in $(PHP_MODULES)""; do \
			. $$i; $(top_srcdir)/build/shtool echo -n -- " -d extension=$$dlname"; \
		done; \
	fi; \
	if test "x$(PHP_ZEND_EX)" != "x"; then \
		for i in $(PHP_ZEND_EX)""; do \
			. $$i; $(top_srcdir)/build/shtool echo -n -- " -d $(ZEND_EXT_TYPE)=$(top_builddir)/modules/$$dlname"; \
		done; \
	fi`
PHP_DEPRECATED_DIRECTIVES_REGEX = '^(magic_quotes_(gpc|runtime|sybase)?|(zend_)?extension(_debug)?(_ts)?)[\t\ ]*='

test: all
	@if test ! -z "$(PHP_EXECUTABLE)" && test -x "$(PHP_EXECUTABLE)"; then \
		INI_FILE=`$(PHP_EXECUTABLE) -d 'display_errors=stderr' -r 'echo php_ini_loaded_file();' 2> /dev/null`; \
		if test "$$INI_FILE"; then \
			$(EGREP) -h -v $(PHP_DEPRECATED_DIRECTIVES_REGEX) "$$INI_FILE" > $(top_builddir)/tmp-php.ini; \
		else \
			echo > $(top_builddir)/tmp-php.ini; \
		fi; \
		INI_SCANNED_PATH=`$(PHP_EXECUTABLE) -d 'display_errors=stderr' -r '$$a = explode(",\n", trim(php_ini_scanned_files())); echo $$a[0];' 2> /dev/null`; \
		if test "$$INI_SCANNED_PATH"; then \
			INI_SCANNED_PATH=`$(top_srcdir)/build/shtool path -d $$INI_SCANNED_PATH`; \
			$(EGREP) -h -v $(PHP_DEPRECATED_DIRECTIVES_REGEX) "$$INI_SCANNED_PATH"/*.ini >> $(top_builddir)/tmp-php.ini; \
		fi; \
		TEST_PHP_EXECUTABLE=$(PHP_EXECUTABLE) \
		TEST_PHP_SRCDIR=$(top_srcdir) \
		CC="$(CC)" \
			$(PHP_EXECUTABLE) -n -c $(top_builddir)/tmp-php.ini $(PHP_TEST_SETTINGS) $(top_srcdir)/run-tests.php -n -c $(top_builddir)/tmp-php.ini -d extension_dir=$(top_builddir)/modules/ $(PHP_TEST_SHARED_EXTENSIONS) $(TESTS); \
		TEST_RESULT_EXIT_CODE=$$?; \
		rm $(top_builddir)/tmp-php.ini; \
		exit $$TEST_RESULT_EXIT_CODE; \
	else \
		echo "ERROR: Cannot run tests without CLI sapi."; \
	fi

clean:
	find . -name \*.gcno -o -name \*.gcda | xargs rm -f
	find . -name \*.lo -o -name \*.o | xargs rm -f
	find . -name \*.la -o -name \*.a | xargs rm -f
	find . -name \*.so | xargs rm -f
	find . -name .libs -a -type d|xargs rm -rf
	rm -f libphp$(PHP_MAJOR_VERSION).la $(SAPI_CLI_PATH) $(SAPI_CGI_PATH) $(SAPI_MILTER_PATH) $(SAPI_LITESPEED_PATH) $(SAPI_FPM_PATH) $(OVERALL_TARGET) modules/* libs/*

distclean: clean
	rm -f Makefile config.cache config.log config.status Makefile.objects Makefile.fragments libtool main/php_config.h main/internal_functions_cli.c main/internal_functions.c stamp-h buildmk.stamp Zend/zend_dtrace_gen.h Zend/zend_dtrace_gen.h.bak Zend/zend_config.h TSRM/tsrm_config.h
	rm -f php7.spec main/build-defs.h scripts/phpize
	rm -f ext/date/lib/timelib_config.h ext/mbstring/oniguruma/config.h ext/mbstring/libmbfl/config.h ext/oci8/oci8_dtrace_gen.h ext/oci8/oci8_dtrace_gen.h.bak
	rm -f scripts/man1/phpize.1 scripts/php-config scripts/man1/php-config.1 sapi/cli/php.1 sapi/cgi/php-cgi.1 ext/phar/phar.1 ext/phar/phar.phar.1
	rm -f sapi/fpm/php-fpm.conf sapi/fpm/init.d.php-fpm sapi/fpm/php-fpm.service sapi/fpm/php-fpm.8 sapi/fpm/status.html
	rm -f ext/iconv/php_have_bsd_iconv.h ext/iconv/php_have_glibc_iconv.h ext/iconv/php_have_ibm_iconv.h ext/iconv/php_have_iconv.h ext/iconv/php_have_libiconv.h ext/iconv/php_iconv_aliased_libiconv.h ext/iconv/php_iconv_supports_errno.h ext/iconv/php_php_iconv_h_path.h ext/iconv/php_php_iconv_impl.h
	rm -f ext/phar/phar.phar ext/phar/phar.php
	if test "$(srcdir)" != "$(builddir)"; then \
	  rm -f ext/phar/phar/phar.inc; \
	fi
	$(EGREP) define'.*include/php' $(top_srcdir)/configure | $(SED) 's/.*>//'|xargs rm -f

prof-gen:
	CCACHE_DISABLE=1 $(MAKE) PROF_FLAGS=-fprofile-generate all

prof-clean:
	find . -name \*.lo -o -name \*.o | xargs rm -f
	find . -name \*.la -o -name \*.a | xargs rm -f
	find . -name \*.so | xargs rm -f
	rm -f libphp$(PHP_MAJOR_VERSION).la $(SAPI_CLI_PATH) $(SAPI_CGI_PATH) $(SAPI_MILTER_PATH) $(SAPI_LITESPEED_PATH) $(SAPI_FPM_PATH) $(OVERALL_TARGET) modules/* libs/*

prof-use:
	CCACHE_DISABLE=1 $(MAKE) PROF_FLAGS=-fprofile-use all


.PHONY: all clean install distclean test prof-gen prof-clean prof-use
.NOEXPORT:
ZendAccelerator.lo: /build/php-src-php-7.2.1/ext/opcache/ZendAccelerator.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/ZendAccelerator.c -o ZendAccelerator.lo 
zend_accelerator_blacklist.lo: /build/php-src-php-7.2.1/ext/opcache/zend_accelerator_blacklist.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/zend_accelerator_blacklist.c -o zend_accelerator_blacklist.lo 
zend_accelerator_debug.lo: /build/php-src-php-7.2.1/ext/opcache/zend_accelerator_debug.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/zend_accelerator_debug.c -o zend_accelerator_debug.lo 
zend_accelerator_hash.lo: /build/php-src-php-7.2.1/ext/opcache/zend_accelerator_hash.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/zend_accelerator_hash.c -o zend_accelerator_hash.lo 
zend_accelerator_module.lo: /build/php-src-php-7.2.1/ext/opcache/zend_accelerator_module.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/zend_accelerator_module.c -o zend_accelerator_module.lo 
zend_persist.lo: /build/php-src-php-7.2.1/ext/opcache/zend_persist.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/zend_persist.c -o zend_persist.lo 
zend_persist_calc.lo: /build/php-src-php-7.2.1/ext/opcache/zend_persist_calc.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/zend_persist_calc.c -o zend_persist_calc.lo 
zend_file_cache.lo: /build/php-src-php-7.2.1/ext/opcache/zend_file_cache.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/zend_file_cache.c -o zend_file_cache.lo 
zend_shared_alloc.lo: /build/php-src-php-7.2.1/ext/opcache/zend_shared_alloc.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/zend_shared_alloc.c -o zend_shared_alloc.lo 
zend_accelerator_util_funcs.lo: /build/php-src-php-7.2.1/ext/opcache/zend_accelerator_util_funcs.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/zend_accelerator_util_funcs.c -o zend_accelerator_util_funcs.lo 
shared_alloc_shm.lo: /build/php-src-php-7.2.1/ext/opcache/shared_alloc_shm.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/shared_alloc_shm.c -o shared_alloc_shm.lo 
shared_alloc_mmap.lo: /build/php-src-php-7.2.1/ext/opcache/shared_alloc_mmap.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/shared_alloc_mmap.c -o shared_alloc_mmap.lo 
shared_alloc_posix.lo: /build/php-src-php-7.2.1/ext/opcache/shared_alloc_posix.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/shared_alloc_posix.c -o shared_alloc_posix.lo 
Optimizer/zend_optimizer.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/zend_optimizer.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/zend_optimizer.c -o Optimizer/zend_optimizer.lo 
Optimizer/pass1_5.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/pass1_5.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/pass1_5.c -o Optimizer/pass1_5.lo 
Optimizer/pass2.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/pass2.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/pass2.c -o Optimizer/pass2.lo 
Optimizer/pass3.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/pass3.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/pass3.c -o Optimizer/pass3.lo 
Optimizer/optimize_func_calls.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/optimize_func_calls.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/optimize_func_calls.c -o Optimizer/optimize_func_calls.lo 
Optimizer/block_pass.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/block_pass.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/block_pass.c -o Optimizer/block_pass.lo 
Optimizer/optimize_temp_vars_5.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/optimize_temp_vars_5.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/optimize_temp_vars_5.c -o Optimizer/optimize_temp_vars_5.lo 
Optimizer/nop_removal.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/nop_removal.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/nop_removal.c -o Optimizer/nop_removal.lo 
Optimizer/compact_literals.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/compact_literals.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/compact_literals.c -o Optimizer/compact_literals.lo 
Optimizer/zend_cfg.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/zend_cfg.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/zend_cfg.c -o Optimizer/zend_cfg.lo 
Optimizer/zend_dfg.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/zend_dfg.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/zend_dfg.c -o Optimizer/zend_dfg.lo 
Optimizer/dfa_pass.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/dfa_pass.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/dfa_pass.c -o Optimizer/dfa_pass.lo 
Optimizer/zend_ssa.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/zend_ssa.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/zend_ssa.c -o Optimizer/zend_ssa.lo 
Optimizer/zend_inference.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/zend_inference.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/zend_inference.c -o Optimizer/zend_inference.lo 
Optimizer/zend_func_info.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/zend_func_info.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/zend_func_info.c -o Optimizer/zend_func_info.lo 
Optimizer/zend_call_graph.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/zend_call_graph.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/zend_call_graph.c -o Optimizer/zend_call_graph.lo 
Optimizer/sccp.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/sccp.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/sccp.c -o Optimizer/sccp.lo 
Optimizer/scdf.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/scdf.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/scdf.c -o Optimizer/scdf.lo 
Optimizer/dce.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/dce.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/dce.c -o Optimizer/dce.lo 
Optimizer/compact_vars.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/compact_vars.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/compact_vars.c -o Optimizer/compact_vars.lo 
Optimizer/zend_dump.lo: /build/php-src-php-7.2.1/ext/opcache/Optimizer/zend_dump.c
	$(LIBTOOL) --mode=compile $(CC) -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -I. -I/build/php-src-php-7.2.1/ext/opcache $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS)  -c /build/php-src-php-7.2.1/ext/opcache/Optimizer/zend_dump.c -o Optimizer/zend_dump.lo 
$(phplibdir)/opcache.la: ./opcache.la
	$(LIBTOOL) --mode=install cp ./opcache.la $(phplibdir)

./opcache.la: $(shared_objects_opcache) $(OPCACHE_SHARED_DEPENDENCIES)
	$(LIBTOOL) --mode=link $(CC) $(COMMON_FLAGS) $(CFLAGS_CLEAN) $(EXTRA_CFLAGS) $(LDFLAGS) -o $@ -export-dynamic -avoid-version -prefer-pic -module -rpath $(phplibdir) $(EXTRA_LDFLAGS) $(shared_objects_opcache) $(OPCACHE_SHARED_LIBADD)

