#!/usr/bin/env bash

forge_version="1.19.2-43.3.2"

java="$(java --version)"
if echo "${java}" | grep "openjdk 17"; then
	echo "Java version is correct"
else
	echo "Java version is incorrect. Please install openjdk 17 and try again"
	exit 1
fi

if [[ -f "run.sh" ]]; then
	echo "Seems like forge-${forge_version} is already installed. Want to reinstall? [Y/n]"
	read -r answer
	if [[ ${answer} == "${answer#[Yy]}" ]]; then
		rm -rf libraries
		rm -rf run.bat
		rm -rf run.sh
		rm -rf "forge-${forge_version}-installer.jar"
	fi
fi

if ! [[ -f "forge-${forge_version}-installer.jar" ]]; then
	echo "Downloading forge-${forge_version}-installer.jar"
	if curl -O "https://maven.minecraftforge.net/net/minecraftforge/forge/${forge_version}/forge-${forge_version}-installer.jar" -eq 1; then
		echo "Downloaded forge-${forge_version}-installer.jar"
	else
		echo "Failed to download forge-${forge_version}-installer.jar"
		exit 1
	fi
fi

if java -jar "forge-${forge_version}-installer.jar" --installServer; then
	echo "Installed forge-${forge_version} successfully"
else
	echo "Failed to install forge-${forge_version}"
	exit 1
fi

if curl -O "https://raw.githubusercontent.com/h4rldev/lanserver-stuff/main/run.sh"; then
	echo "Downloaded run.sh"
	chmod +x run.sh
else
	echo "Failed to download run.sh"
	exit 1
fi

mv user_jvm_args.txt settings.txt

echo -e "Done. Edit settings.txt and run run.sh to start the server."
echo -e "You may also want to change the server.properties file after generation."
