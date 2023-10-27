#!/usr/bin/env bash

java="$(java --version)"

check_java() {
	if echo "${java}" | grep "openjdk 17"; then
		echo "Java version is correct"
	else
		echo "Java version is incorrect. Please install openjdk 17 and try again"
		exit 1
	fi
}

check_installer_file() {
	if [[ -f "install-forge.sh" ]]; then
		echo "Seems like install-forge.sh is still present. Want to remove it? [Y/n]"
		read -r answer
		if [[ ${answer} != "${answer#[Yy]}" ]]; then
			rm install-forge.sh
		fi
	fi

}

eula() {
	if ! [[ -f "eula.txt" ]]; then
		java @settings.txt @libraries/net/minecraftforge/forge/1.19.2-43.3.2/unix_args.txt nogui "$@" >/dev/null 2>&1
		echo "You need to accept the EULA to run the server. Accept? [Y/n]"
		read -r answer
		if [[ ${answer} == "${answer#[Yy]}" ]]; then
			curl -O "https://github.com/h4rldev/eula/releases/latest/download/eula"
			chmod +x eula
			if ./eula; then
				echo "EULA accepted successfully"
				rm eula
			else
				echo "EULA failed to accept. Please manually accept the eula by editing eula.txt and changing false to true"
				exit 1
			fi
		else
			echo "You need to accept the EULA to run the server. Exiting..."
			exit 1
		fi
	fi
}

case "$1" in
"--help")
	just run the server
	exit 0
	;;
*)
	echo "Starting server..."
	check_java
	check_installer_file
	eula "$@"
	run_server "$@"
	;;
esac

run_server() {
	java @settings.txt @libraries/net/minecraftforge/forge/1.19.2-43.3.2/unix_args.txt nogui "$@"
	case $? in
	0)
		echo "Server stopped successfully"
		;;
	1)
		echo "Server stopped with exit code 1. Restarting in 5 seconds..."
		sleep 5
		exec "$0" "$@"
		;;
	*)
		echo "Server stopped with exit code $?. Exiting..."
		exit 1
		;;
	esac
}
