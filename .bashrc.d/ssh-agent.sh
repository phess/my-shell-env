#!/bin/bash

## If $XDG_RUNTIME_DIR is not set, set it with a default value.
#if [ -z "${XDG_RUNTIME_DIR}" ] ; then
#	XDG_RUNTIME_DIR="/run/user/${EUID}"
#fi
#
## Try to set a decent ssh-agent.socket path
#for DIR in ${XDG_RUNTIME_DIR} /tmp/private /tmp/.private ; do
#	trying=${DIR}/ssh-agent.socket
#	if [ -S "${trying}" ] ; then
#		SSH_AUTH_SOCK="${trying}"
#	fi
#done


SSH_AUTH_SOCK=${XDG_RUNTIME_DIR}/ssh-agent.socket
if [ -S ${SSH_AUTH_SOCK} ] ; then
	export SSH_AUTH_SOCK
else
	echo "***ERROR: failed to find SSH AUTH socket at ${SSH_AUTH_SOCK}" >&2
fi

SSH_AGENT_PIDFILE=${XDG_RUNTIME_DIR}/ssh-agent.pid
if [ -s ${SSH_AGENT_PIDFILE} ] ; then
	export SSH_AGENT_PID=$(< ${SSH_AGENT_PIDFILE} )
else
	echo "***ERROR: failed to find SSH AGENT PID in file ${SSH_AGENT_PIDFILE}. File is empty or does not exist. Take a look at ssh-agent-write-pidfile.service user-session unit file." >&2
fi

