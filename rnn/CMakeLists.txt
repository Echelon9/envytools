project(ENVYTOOLS C)
cmake_minimum_required(VERSION 2.6)

# <3 libxml2
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-pointer-sign")

find_package(LibXml2 REQUIRED)

find_path(LIBICONV_INCLUDE_DIR iconv.h)
include_directories(${LIBXML2_INCLUDE_DIR} ${LIBICONV_INCLUDE_DIR})

find_program (BASH_PROGRAM bash)

configure_file(rnn_path.h.in rnn_path.h ESCAPE_QUOTES)
include_directories(${PROJECT_BINARY_DIR})

add_library(rnn rnn.c rnndec.c)
add_library(seq seq.c)

add_executable(demmio demmio.c)
add_executable(headergen headergen.c)
add_executable(dedma dedma.c dedma_cache.c dedma_back.c)
add_executable(lookup lookup.c)
add_executable(rnncheck rnncheck.c)

target_link_libraries(rnn ${LIBXML2_LIBRARIES} envyutil)
target_link_libraries(demmio envy nvhw rnn seq)
target_link_libraries(headergen rnn)
target_link_libraries(dedma rnn)
target_link_libraries(lookup rnn)
target_link_libraries(rnncheck rnn)

install(TARGETS demmio headergen rnn dedma lookup
	RUNTIME DESTINATION bin
	LIBRARY DESTINATION lib${LIB_SUFFIX}
	ARCHIVE DESTINATION lib${LIB_SUFFIX})

add_test(check_rnndb rnncheck root.xml)
if (BASH_PROGRAM)
  add_test (validate_rnndb ${BASH_PROGRAM} ${CMAKE_CURRENT_SOURCE_DIR}/rnnvalidate.sh)
endif (BASH_PROGRAM)
