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

function _equal {
	declare     operation="${1}"
	declare expect_result="${2}"
	declare   description="${3}"
	declare      operator="${4}"
	declare result

	result=$( echo "${operation}" | bc -l )

	if [ ${expect_result} ${operator} ${result} ]; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
		print_verbose_result "${result}" "${expect_result}" "${description}"
	fi
}

function is_true {
	_boolean "${1}" "${2}"
}

function is_false {
	_boolean "${1}" "${2}" "!"
}

function _boolean {
	declare   operation="${1}"
	declare description="${2}"
	declare        bool="${3}"

	if ${bool} ${operation} 2>/dev/null 1>&2; then
		print_ok "${description}"
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
	declare operator="${4}"

	if [ "${given}" ${operator} "${expected}" ]; then
		print_ok "${description}"
	else 
		print_not_ok "${description}"
	fi
}

function is_file {
	_file "${1}" "${2}"
}

function is_not_file {
	_file "${1}" "${2}" !
}

function _file {
	declare        file="${1}"
	declare description="${2}"
	declare    operator="${3}"

	if [ ${operator} -e ${file} ]; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
	fi
}

function is_dir {
	_dir "${1}" "${2}" 
}

function is_not_dir {
	_dir "${1}" "${2}" "!"
}

function _dir {
	declare   directory="${1}"
	declare description="${2}"
	declare    operator="${3}"

	if [ ${operator} -d ${directory} ]; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
	fi
}

function is_executable {
	_executable "${1}" "${2}"
}

function is_not_executable {
	_executable "${1}" "${2}" "!"
}

function _executable {
	declare        file="${1}"
	declare description="${2}"
	declare    operator="${3}"

	if [ ${operator} -x ${file} ]; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
	fi
}

function is_symlink {
	_symlink "${1}" "${2}" 
}

function is_not_symlink {
	_symlink "${1}" "${2}" "!"
}

function _symlink {
	declare        file="${1}"
	declare description="${2}"
	declare    operator="${3}"

	if [ ${operator} -L ${file} ]; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
	fi
}

function is_process {
	_process "${1}" "${2}" 
}

function is_not_process {
	_process "${1}" "${2}" "!"
}

function _process {
	declare     process="${1}"
	declare description="${2}"
	declare     operator="${3}"

	if [ ${operator} -d /proc/${process} ]; then
		print_ok "${description}"
	else 
		print_not_ok "${description}"
	fi
}

function is_insmod {
	_insmod "${1}" "${2}"
}

function is_not_insmod {
	_insmod "${1}" "${2}" "!"
}

function _insmod {
	declare      module="${1}"
	declare description="${2}"
	declare    operator="${3}"

	if ${operator} grep -qe "${module}" /proc/modules; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
	fi
}




