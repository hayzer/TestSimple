#!/bin/bash
#===============================================================================
#
#          FILE:  TestSimple.sh
# 
#         USAGE:  source ./TestSimple.sh 
# 
#   DESCRIPTION:  Basic Bash testing library
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Thomas Maier, hayzer@gmail.com
#       VERSION:  0.01
#       CREATED:  06/15/2008 04:36:50 PM IDT
#      REVISION:  ---
#       LICENSE: GNU GPL
#===============================================================================
#
#===============================================================================
# This file is part of TestSimple.
# Copyright (C) 2008 - 2008 Thomas Maier
#
# TestSimple is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#===============================================================================

source lib/libbashtap.sh

#-------------------------------------------------------------------------------
#   Testing functions
#-------------------------------------------------------------------------------
function is_equal {
	_equal "${1}" "${2}" "${3}" '-eq'
}

function is_not_equal {
	_equal "${1}" "${2}" "${3}" '-ne'
}

function is_greater {
	_equal "${1}" "${2}" "${3}" '-gt'
}

function is_less {
	_equal "${1}" "${2}" "${3}" '-lt'
}

function is_greater_or_equal {
	_equal "${1}" "${2}" "${3}" '-le'
}

function is_less_or_equal {
	_equal "${1}" "${2}" "${3}" '-ge'
}

function _equal {
	declare     operation="${1}"
	declare expect_result="${2}"
	declare   description="${3}"
	declare      operator="${4}"
	declare result

	export START_TIME=$(current_time)
	result=$( echo "${operation}" | bc -l )
	export STOP_TIME=$(current_time)

	if [ ${expect_result} ${operator} ${result} ]; then
		print_ok             "${description}"
	else
		print_not_ok         "${description}"
		print_verbose_result "${result}"        \
                                     "${expect_result}" \
                                     "${description}"
	fi
	
	unset_time
	
}

function is_true {
	_boolean "${1}" "${2}"
}

function is_false {
	_boolean "${1}" "${2}" !
}

function _boolean {
	declare   operation="${1}"
	declare description="${2}"
	declare        bool="${3}"

	if ${bool} ${operation} 2>/dev/null 1>&2; then
		print_ok     "${description}"
	else
		print_not_ok "${description}"
	fi
}

function is_exact {
	_exact "${1}" "${2}" "${3}" '='
}

function is_not_exact {
	_exact "${1}" "${2}" "${3}" '!='
}

function _exact {
	declare       given="${1}"
	declare    expected="${2}"
	declare description="${3}"
	declare    operator="${4}"

	export START_TIME=$( current_time )

	if [ "${given}" ${operator} "${expected}" ]; then
		print_ok             "${description}"
	else 
		print_not_ok         "${description}"
		export STOP_TIME=$( current_time )
		print_verbose_result "${given}"       \
                                     "${expected}"    \
				     "${description}"
	fi

	unset_time
}

function is_file {
	_file "${1}" "${2}" -e
}

function is_not_file {
	_file "${1}" "${2}" -e !
}

function is_dir {
	_file "${1}" "${2}" -d
}

function is_not_dir {
	_file "${1}" "${2}" -d !
}

function is_executable {
	_file "${1}" "${2}" -x
}

function is_not_executable {
	_file "${1}" "${2}" -x !
}

function is_symlink {
	_file "${1}" "${2}" -L
}

function is_not_symlink {
	_file "${1}" "${2}" -L !
}

function _file {
	declare      target="${1}"
	declare description="${2}"
	declare    operator="${3}"
	declare    negative="${4}"

	if [ ${negative} ${operator} ${target} ]; then
		print_ok     "${description}"
	else
		print_not_ok "${description}"
	fi
}

function is_process_id {
	_process_id "${1}" "${2}" 
}

function is_not_process_id {
	_process_id "${1}" "${2}" "!"
}

function _process_id {
	declare     process="${1}"
	declare description="${2}"
	declare    operator="${3}"

	if [ ${operator} -d /proc/${process} ]; then
		print_ok     "${description}"
	else 
		print_not_ok "${description}"
	fi
}

function is_insmod {
	_insmod "${1}" "${2}" "-eq"
}

function is_not_insmod {
	_insmod "${1}" "${2}" "-ne"
}

function _insmod {
	declare      module="${1}"
	declare description="${2}"
	declare    operator="${3}"

	grep -qe "${module}" /proc/modules
	if [ $? ${operator} 0 ]; then
		print_ok     "${description}"
	else
		print_not_ok "${description}"
	fi
}

