if [ "$IN_CONTAINER" = "true" ]; then
	#PSPREFIX="\xe2\x9a\xaf"
	#PSPREFIX=$'\u26af '
	PSPREFIX=$'\u26d4 '
fi

# Assign color to PSPREFIX
if [ ! -z "${PSPREFIX}" ]; then
	PSPREFIX='\[\e[01;31m\]'${PSPREFIX}'\[\e[0m\]'
fi


if [ "$PS1" ]; then
	#PS1='[\u@\h \w]\n\$ '
	if [ "$EUID" -ne 0 ]; then
		PS1='\[\e[00;33m\][\t] [\D{%a %d/%m}]\[\e[0m\] \[\e[40;00;32m\]\u\[\e[0m\]\[\e[40;01;94m\]@\h\[\e[0m\] [\[\e[00;34m\]\w\[\e[0m\]]\n\[\e[01;34m\]\$\[\e[0m\]'
	else
		PS1='\[\e[00;33m\][\t] [\D{%a %d/%m}]\[\e[0m\] \[\e[40;01;31m\]\u\[\e[0m\]\[\e[40;01;94m\]@\h\[\e[0m\] [\[\e[00;34m\]\w\[\e[0m\]]\n\[\e[01;31m\]\$\[\e[0m\]'
	fi
	export PS1="${PSPREFIX}${PS1}${PSPREFIX} "
fi
