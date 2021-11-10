__git_ps1() {
	BRANCHNAME=$(git branch 2>/dev/null | grep '^*' | colrm 1 2)
	[ ! -z "$BRANCHNAME" ] && echo -n " ($BRANCHNAME)"
}

__list_venvs() {
	VENV_DIR=${PYTHON_VENV_HOME:-~/venvs}
	/bin/ls -1v $VENV_DIR
}

venv() {
	if [ "$#" -ne "1" ]
	then
		__list_venvs
		return 0
	else
		activate=${VENV_DIR}/${1}/bin/activate
	fi

	if [ -f "$activate" ]
	then
		source $activate
	else
		__list_venvs
		return 1
	fi
	
}
