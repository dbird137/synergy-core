cmake_minimum_required (VERSION 3.4)

#
# Synergy Version
#

set (SYNERGY_VERSION_MAJOR 1)
set (SYNERGY_VERSION_MINOR 13)
set (SYNERGY_VERSION_PATCH 0)
set (SYNERGY_VERSION_STAGE "rc2-test1")

#
# Version from CI
#

if (DEFINED ENV{SYNERGY_VERSION_MAJOR})
    set (SYNERGY_VERSION_MAJOR $ENV{SYNERGY_VERSION_MAJOR})
endif()

if (DEFINED ENV{SYNERGY_VERSION_MINOR})
    set (SYNERGY_VERSION_MINOR $ENV{SYNERGY_VERSION_MINOR})
endif()

if (DEFINED ENV{SYNERGY_VERSION_PATCH})
    set (SYNERGY_VERSION_PATCH $ENV{SYNERGY_VERSION_PATCH})
endif()

if (DEFINED ENV{SYNERGY_VERSION_STAGE})
    set (SYNERGY_VERSION_STAGE $ENV{SYNERGY_VERSION_STAGE})
endif()

if (NOT DEFINED SYNERGY_REVISION)
    if (DEFINED ENV{GIT_COMMIT})
        string (SUBSTRING $ENV{GIT_COMMIT} 0 8 SYNERGY_REVISION)
    elseif (SYNERGY_VERSION_STAGE STREQUAL "snapshot")
        execute_process (
            COMMAND git rev-parse --short=8 HEAD
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            OUTPUT_VARIABLE SYNERGY_REVISION
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
    endif()
endif()

if (DEFINED SYNERGY_REVISION)
    string(LENGTH ${SYNERGY_REVISION} SYNERGY_REVISION_LENGTH)
    if (NOT ((SYNERGY_REVISION MATCHES "^[a-f0-9]+") AND (SYNERGY_REVISION_LENGTH EQUAL "8")))
        message (FATAL_ERROR "SYNERGY_REVISION ('${SYNERGY_REVISION}') should be a short commit hash")
    endif()
    unset (SYNERGY_REVISION_LENGTH)
else()
	set (SYNERGY_REVISION "0badc0de")
endif()

if (DEFINED ENV{BUILD_NUMBER})
    set (SYNERGY_BUILD_NUMBER $ENV{BUILD_NUMBER})
else()
    set (SYNERGY_BUILD_NUMBER 1)
endif()

string (TIMESTAMP SYNERGY_BUILD_DATE "%Y%m%d" UTC)
set (SYNERGY_SNAPSHOT_INFO ".${SYNERGY_VERSION_STAGE}.${SYNERGY_REVISION}")

if (SYNERGY_VERSION_STAGE STREQUAL "snapshot")
    set (SYNERGY_VERSION_TAG "${SYNERGY_VERSION_STAGE}.b${SYNERGY_BUILD_NUMBER}-${SYNERGY_REVISION}")
else()
    set (SYNERGY_VERSION_TAG "${SYNERGY_VERSION_STAGE}")
endif()

set (SYNERGY_VERSION "${SYNERGY_VERSION_MAJOR}.${SYNERGY_VERSION_MINOR}.${SYNERGY_VERSION_PATCH}")
set (SYNERGY_VERSION_STRING "${SYNERGY_VERSION}-${SYNERGY_VERSION_TAG}")
message (STATUS "Full Synergy version string is '" ${SYNERGY_VERSION_STRING} "'")

add_definitions (-DSYNERGY_VERSION="${SYNERGY_VERSION}")
add_definitions (-DSYNERGY_VERSION_STRING="${SYNERGY_VERSION_STRING}")
add_definitions (-DSYNERGY_REVISION="${SYNERGY_REVISION}")
add_definitions (-DSYNERGY_BUILD_DATE="${SYNERGY_BUILD_DATE}")
add_definitions (-DSYNERGY_BUILD_NUMBER=${SYNERGY_BUILD_NUMBER})

if (SYNERGY_DEVELOPER_MODE)
    add_definitions (-DSYNERGY_DEVELOPER_MODE=1)
endif()

if (SYNERGY_ENTERPRISE)
    add_definitions (-DSYNERGY_ENTERPRISE=1)
endif()
