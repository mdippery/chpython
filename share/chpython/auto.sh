unset PYTHON_AUTO_VERSION

function chpython_auto() {
	local dir="$PWD/" version

	until [[ -z "$dir" ]]; do
		dir="${dir%/*}"

		if { read -r version < "$dir/.python-version"; } 2>/dev/null || [[ -n "$version" ]]; then
			version="${version%%[[:space:]]}"

			if [[ "$version" == "$PYTHON_AUTO_VERSION" ]]; then return
			else
				PYTHON_AUTO_VERSION="$version"
				chpython "$version"
				return $?
			fi
		fi
	done

	if [[ -n "$PYTHON_AUTO_VERSION" ]]; then
		chpython_reset
		unset PYTHON_AUTO_VERSION
	fi
}

if [[ -n "$ZSH_VERSION" ]]; then
	if [[ ! "$preexec_functions" == *chpython_auto* ]]; then
		preexec_functions+=("chpython_auto")
	fi
elif [[ -n "$BASH_VERSION" ]]; then
	trap '[[ "$BASH_COMMAND" != "$PROMPT_COMMAND" ]] && chpython_auto' DEBUG
fi
