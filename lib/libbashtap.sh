#!/bin/bash
#===============================================================================
#
#          FILE:  libtap.sh
# 
#         USAGE:  ./libtap.sh 
# 
#   DESCRIPTION:  TAP implementation in Bash
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Thomas Maier (Bashunit), hayzer@gmail.com
#       COMPANY:  GNU
#       VERSION:  1.0
#       CREATED:  01/08/2008 10:45:19 PM IST
#      REVISION:  ---
#===============================================================================

TESTCOUNTER=0
WITHCOUNTER=true
WITHDESCRIP=true
TODO=false
SKIP=false
SKIP_ALL=false
TRUE=0
FALSE=1
FAILCOUNTER=0


trap on_trap EXIT

function on_trap {
	declare msg_head="# Looks like you failed ${FAILCOUNTER}"
	declare tests
	if [ ${FAILCOUNTER} -eq 1 ]; then
		test='test'
	elif [ ${FAILCOUNTER} -gt 1 ]; then
		test='tests'
	else
		return
	fi

	msg_head="${msg_head} ${test} of ${TESTCOUNTER}"
	echo ${msg_head}
}
		
#-------------------------------------------------------------------------------
#   TAP functions
#-------------------------------------------------------------------------------
function diag {
	declare diagnostic="${*}"
	echo -en "# ${diagnostic}\n"
}

function skip_all {
	SKIP_ALL_DESCRIPTION="${*}"
	SKIP_ALL=true
}

function testplan() {
	declare test="${1}"
	declare postfix
	
	if [ ! ${test} -gt 0 ]; then
		echo "Test plan cannot be ${test}"
		exit 1
	fi

	if ${SKIP_ALL}; then
		postfix=" # Skipped: ${SKIP_ALL_DESCRIPTION}"
		   test=0
	fi

	echo -en "1..${test}${postfix}\n"
}

function todo_on {
	TODO=true
}

function todo_off {
	TODO=false
}

function skip_on {
	SKIP=true
}

function skipp_off {
	SKIP=false
}

function bail_out {
	declare description="${*}"

	echo -en "Bail out! ${description}\n";
	exit 1
} 

function print_verbose_result {
	declare         got="${1}"
	declare    expected="${2}"
	declare description="${3}"

	cat <<END_RESULT
#   Failed test '${description}'
#         got: '${got}'
#    expected: '${expected}'
END_RESULT
}

function print_counter {
	TESTCOUNTER=$(( ${TESTCOUNTER} + 1 ))
	if ${WITHCOUNTER}; then
		echo -en "${TESTCOUNTER}"
	fi
}

function print_todo {
	declare msg=''
	
	if ${TODO}; then
		msg=" # TODO"
	elif ${SKIP}; then
		msg=" # SKIP"
	fi

	echo "${msg}"
}

function print_description {
	if ${WITHDESCRIP}; then
		echo -en "${prefix} ${description}"
	fi
}

function print_ok {
	declare description="${*}"
	declare prefix

	echo -en "ok "
	
	print_counter
	prefix="$( print_todo )"
	print_description "${prefix}" "${description}"

	echo -en "\n"
	return ${TRUE}
}
typeset -fx

function print_not_ok {
	declare description="${*}"

	FAILCOUNTER=$(( ${FAILCOUNTER} + 1 ))

	echo -en "not ok "

	print_counter
	prefix="$( print_todo )"
	print_description "${prefix}" "${description}"

	echo -en "\n"
	return ${FALSE}
}
typeset -fx
