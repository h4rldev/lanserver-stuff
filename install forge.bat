@echo off

set forge="forge-1.19.2-43.3.2-installer.jar"

:get_forge
if not exist %forge% (
    curl -O "https://maven.minecraftforge.net/net/minecraftforge/forge/1.19.2-43.3.2/%forge%"
)
if not exist "run.bat" (
	java -jar %forge% --installServer
)
del run.bat
del run.sh
ren user_jvm_args.txt settings.txt
curl -O https://raw.githubusercontent.com/h4rldev/lanserver-stuff/main/run.bat
if exist "*.log" (
	if not exist "logs\\" (
		mkdir logs
	)
	move *.log logs
)