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
#        AUTHOR:  hayzer, hayzer@gmail.com
#       COMPANY:  *
#       VERSION:  1.0
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
	# Wildcharacter [*] is automatically expand by the shell.
	# Cancel this behavior before evaluation.:w
	:
}

function is_not_equal {
	:
}

function is_true {
	declare   operation="${1}"
	declare description="${*}"

	if ${operation} 2>/dev/null 1>&2; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
	fi
}
		
function is_false {
	declare   operation="${1}"
	declare description="${2}"

	if ! ${operation} 2>/dev/null 1>&2; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
	fi
}

function is_exact {
	declare       given="${1}"
	declare    expected="${2}"
	declare description="${3}"

	if [ "${given}" = "${expected}" ]; then
		print_ok "${description}"
	else 
		print_not_ok "${description}"
	fi
}

function is_like {
	declare       given="${1}"
	declare    expected="${2}"
	declare description="${3}"

	declare oldshopt=$( shopt -p extglob )
	shopt -s extglob

	 search=${given}
	pattern="+(*${expected}*)"

	if [[ "${search}" = ${pattern} ]]; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
	fi

	eval ${oldshopt}
}

function is_file {
	declare        file="${1}"
	declare description="${2}"

	if test -e ${file}; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
	fi
}

function is_not_file {
	declare        file="${1}"
	declare description="${2}"

	if ! test -e ${file}; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
	fi
}

function is_dir {
	declare   directory="${1}"
	declare description="${2}"

	if test -d ${directory}; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
	fi
}

function is_not_dir {
	declare   directory="${1}"
	declare description="${2}"

	if ! test -d ${directory}; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
	fi
}

function is_executable {
	declare        file="${1}"
	declare description="${2}"

	if test -x ${file}; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
	fi
}

function is_not_executable {
	declare        file="${1}"
	declare description="${2}"

	if ! test -x ${file}; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
	fi
}

function is_symlink {
	declare        file="${1}"
	declare description="${2}"

	if test -L ${file}; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
	fi
}

function is_not_symlink {
	declare        file="${1}"
	declare description="${2}"

	if ! test -L ${file}; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
	fi
}

function is_process {
	declare     process="${1}"
	declare description="${2}"

	if test -d /proc/${process}; then
		print_ok "${description}"
	else 
		print_not_ok "${description}"
	fi
}

function is_not_process {
	declare     process="${1}"
	declare description="${2}"

	if ! test -d /proc/${process}; then
		print_ok "${description}"
	else 
		print_not_ok "${description}"
	fi
}

function is_insmod {
	declare      module="${1}"
	declare description="${2}"

	if grep -qe "${module}" /proc/modules; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
	fi
}

function is_not_insmod {
	declare      module="${1}"
	declare description="${2}"

	if ! grep -qe "${module}" /proc/modules; then
		print_ok "${description}"
	else
		print_not_ok "${description}"
	fi
}




