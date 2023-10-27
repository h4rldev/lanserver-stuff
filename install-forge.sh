#!/usr/bin/env bash

forge_version="1.19.2-43.3.2"
java="$(java --version)"

check_java() {
	if echo "${java}" | grep "openjdk 17"; then
		echo "Java version is correct"
	else
		echo "Java version is incorrect. Please install openjdk 17 and try again"
		exit 1
	fi
}

check_installation() {
	if [[ -f "run.sh" ]]; then
		echo "Seems like forge-${forge_version} is already installed. Want to reinstall? [Y/n]"
		read -r answer
		if [[ ${answer} == "${answer#[Yy]}" ]]; then
			rm -fr libraries
			rm -fr run.bat
			rm -fr run.sh
			if [[ -f "forge-${forge_version}-installer.jar" ]]; then
				rm -rf "forge-${forge_version}-installer.jar"
			fi
		fi
	fi
}
check_if_installer_exists() {
	if ! [[ -f "forge-${forge_version}-installer.jar" ]]; then
		echo "Downloading forge-${forge_version}-installer.jar"
		if curl -O "https://maven.minecraftforge.net/net/minecraftforge/forge/${forge_version}/forge-${forge_version}-installer.jar" -eq 1; then
			echo "Downloaded forge-${forge_version}-installer.jar"
		else
			echo "Failed to download forge-${forge_version}-installer.jar"
			exit 1
		fi
	fi
}

install_forge() {
	if java -jar "forge-${forge_version}-installer.jar" --installServer; then
		echo "Installed forge-${forge_version} successfully"
		rm -fr "forge-${forge_version}-installer.jar" >/dev/null 2>&1
		rm -fr "run.bat" >/dev/null 2>&1
		rm -fr "run.sh" >/dev/null 2>&1
		mv user_jvm_args.txt settings.txt >/dev/null 2>&1
	else
		echo "Failed to install forge-${forge_version}"
		exit 1
	fi
}

if curl -O "https://raw.githubusercontent.com/h4rldev/lanserver-stuff/main/run.sh"; then
	echo "Downloaded run.sh"
	chmod +x run.sh
else
	echo "Failed to download run.sh"
	exit 1
fi

echo -e "Done. Edit settings.txt and run run.sh to start the server."
echo -e "You may also want to change the server.properties file after generation."
