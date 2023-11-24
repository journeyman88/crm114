cmake_minimum_required(VERSION 3.15)

project(crm114 VERSION 1.0.0)

find_package(PkgConfig REQUIRED)
pkg_check_modules(LIBTRE REQUIRED tre)

configure_file(crm114_config.h.in crm114_config.h)


set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -lm")
set(HEADER_FILES crm114_sysincludes.h crm114_structs.h crm114_config.h crm114.h crm114_osbf.h crm_svm_matrix_util.h crm_svm_quad_prog.h crm_svm_matrix.h crm_svm_lib_fncts.h crm_svm.h crm_pca_lib_fncts.h crm_pca.h)


add_executable(cssutil cssutil.c crm_css_maintenance.c crm_util_errorhandlers.c crm_str_funcs.c)
target_include_directories(cssutil PUBLIC "${PROJECT_BINARY_DIR}")
target_link_libraries(cssutil ${LIBTRE_LIBRARIES})
target_include_directories(cssutil PUBLIC ${LIBTRE_INCLUDE_DIRS})
target_compile_options(cssutil PUBLIC ${LIBTRE_CFLAGS_OTHER})

add_executable(cssdiff cssdiff.c crm_util_errorhandlers.c crm_str_funcs.c)
target_include_directories(cssdiff PUBLIC "${PROJECT_BINARY_DIR}")
target_link_libraries(cssdiff ${LIBTRE_LIBRARIES})
target_include_directories(cssdiff PUBLIC ${LIBTRE_INCLUDE_DIRS})
target_compile_options(cssdiff PUBLIC ${LIBTRE_CFLAGS_OTHER})

add_executable(cssmerge cssmerge.c crm_util_errorhandlers.c crm_str_funcs.c)
target_include_directories(cssmerge PUBLIC "${PROJECT_BINARY_DIR}")
target_link_libraries(cssmerge ${LIBTRE_LIBRARIES})
target_include_directories(cssmerge PUBLIC ${LIBTRE_INCLUDE_DIRS})
target_compile_options(cssmerge PUBLIC ${LIBTRE_CFLAGS_OTHER})

add_executable(osbf-util osbf-util.c crm_osbf_maintenance.c crm_util_errorhandlers.c crm_str_funcs.c)
target_include_directories(osbf-util PUBLIC "${PROJECT_BINARY_DIR}")
target_link_libraries(osbf-util ${LIBTRE_LIBRARIES})
target_include_directories(osbf-util PUBLIC ${LIBTRE_INCLUDE_DIRS})
target_compile_options(osbf-util PUBLIC ${LIBTRE_CFLAGS_OTHER})

add_executable(crm114 crm_main.c crm_compiler.c crm_errorhandlers.c crm_math_exec.c crm_var_hash_table.c crm_expandvar.c crm_stmt_parser.c crm_vector_tokenize.c crm_expr_alter.c crm_expr_match.c crm_css_maintenance.c crm_markovian.c crm_osb_bayes.c crm_osb_hyperspace.c crm_correlate.c crm_osb_winnow.c crm_winnow_maintenance.c crm_osbf_bayes.c crm_osbf_maintenance.c crm_bit_entropy.c crm_neural_net.c crm_expr_clump.c crm_expr_window.c crm_expr_isolate.c crm_expr_file_io.c crm_expr_syscall.c crm_expr_classify.c crm_expr_translate.c crm_exec_engine.c crm_debugger.c crm_str_funcs.c crm_preprocessor.c crmregex_tre.c crm_stats.c crm_expr_sks.c crm_svm_matrix_util.c crm_svm_quad_prog.c crm_svm_matrix.c crm_svm_lib_fncts.c crm_svm.c crm_pca_lib_fncts.c crm_pca.c crm_fast_substring_compression.c)
target_include_directories(crm114 PUBLIC "${PROJECT_BINARY_DIR}")
target_link_libraries(crm114 ${LIBTRE_LIBRARIES})
target_include_directories(crm114 PUBLIC ${LIBTRE_INCLUDE_DIRS})
target_compile_options(crm114 PUBLIC ${LIBTRE_CFLAGS_OTHER})

