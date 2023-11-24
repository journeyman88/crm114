cmake_minimum_required(VERSION 3.15)

project(crm114 VERSION 1.0.0)

find_package(PkgConfig REQUIRED)
pkg_check_modules(LIBTRE REQUIRED tre)

include(CMakeFiles.txt)
configure_file(config/crm114_config.h.in crm114_config.h)
foreach(manpage ${manual_pages})
    configure_file(${manpage}.in ${manpage})
endforeach()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -lm")

add_executable(cssutil ${cssutil_src})
target_include_directories(cssutil PUBLIC include)
target_include_directories(cssutil PUBLIC ${PROJECT_BINARY_DIR})
target_link_libraries(cssutil ${LIBTRE_LIBRARIES})
target_include_directories(cssutil PUBLIC ${LIBTRE_INCLUDE_DIRS})
target_compile_options(cssutil PUBLIC ${LIBTRE_CFLAGS_OTHER})

add_executable(cssdiff ${cssdiff_src})
target_include_directories(cssdiff PUBLIC include)
target_include_directories(cssdiff PUBLIC ${PROJECT_BINARY_DIR})
target_link_libraries(cssdiff ${LIBTRE_LIBRARIES})
target_include_directories(cssdiff PUBLIC ${LIBTRE_INCLUDE_DIRS})
target_compile_options(cssdiff PUBLIC ${LIBTRE_CFLAGS_OTHER})

add_executable(cssmerge ${cssmerge_src})
target_include_directories(cssmerge PUBLIC include)
target_include_directories(cssmerge PUBLIC ${PROJECT_BINARY_DIR})
target_link_libraries(cssmerge ${LIBTRE_LIBRARIES})
target_include_directories(cssmerge PUBLIC ${LIBTRE_INCLUDE_DIRS})
target_compile_options(cssmerge PUBLIC ${LIBTRE_CFLAGS_OTHER})

add_executable(osbf-util ${osbf_util_src})
target_include_directories(osbf-util PUBLIC include)
target_include_directories(osbf-util PUBLIC ${PROJECT_BINARY_DIR})
target_link_libraries(osbf-util ${LIBTRE_LIBRARIES})
target_include_directories(osbf-util PUBLIC ${LIBTRE_INCLUDE_DIRS})
target_compile_options(osbf-util PUBLIC ${LIBTRE_CFLAGS_OTHER})

add_executable(crm ${crm_src})
target_include_directories(crm PUBLIC include)
target_include_directories(crm PUBLIC ${PROJECT_BINARY_DIR})
target_link_libraries(crm ${LIBTRE_LIBRARIES})
target_include_directories(crm PUBLIC ${LIBTRE_INCLUDE_DIRS})
target_compile_options(crm PUBLIC ${LIBTRE_CFLAGS_OTHER})

# Installation
# bin
install(TARGETS cssutil DESTINATION ${CMAKE_INSTALL_BINDIR})
install(TARGETS cssdiff DESTINATION ${CMAKE_INSTALL_BINDIR})
install(TARGETS cssmerge DESTINATION ${CMAKE_INSTALL_BINDIR})
install(TARGETS osbf-util DESTINATION ${CMAKE_INSTALL_BINDIR})
install(TARGETS crm DESTINATION ${CMAKE_INSTALL_BINDIR})

# man pages
foreach(manpage ${manual_pages})
	install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${manpage} DESTINATION ${CMAKE_INSTALL_MANDIR}/man1)
endforeach()

# scripts
foreach(crm_script ${crm_scripts})
	install(FILES ${crm_script} DESTINATION ${CMAKE_INSTALL_LIBDIR}/crm114)
endforeach()

# emacs
install(FILES ext/crm114-mode.el DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/emacs/site-lisp/)

# docs & examples
foreach(crm_doc ${crm_docs})
	install(FILES ${crm_doc} DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/doc/crm114)
endforeach()
install(DIRECTORY examples DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/doc/crm114)

# conf file
install(FILES config/mailfilter.cf DESTINATION ${CMAKE_INSTALL_SYSCONFDIR}/crm114)
