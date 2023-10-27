@echo off
SetLocal EnableDelayedExpansion
REM Forge requires a configured set of both JVM and program arguments.
REM Add custom JVM arguments to the user_jvm_args.txt
REM Add custom program arguments {such as nogui} to this file in the next line before the %* or
REM  pass them to this script directly

:start
if exist "install forge.bat" (
	echo do you want to delete install forge.bat?
	set /p choice=y/n:
	if !%choice%! == !y! (
		del "install forge.bat"
)


if not exist "eula.txt" (
	echo eula doesn't exist, will change it automatically.
	goto :eula_no_exist
) else (
	java @user_jvm_args.txt @libraries/net/minecraftforge/forge/1.19.2-43.3.2/win_args.txt nogui %*
	pause
	exit
)

:eula_no_exist
java @user_jvm_args.txt @libraries/net/minecraftforge/forge/1.19.2-43.3.2/win_args.txt nogui %* 1> nul
powershell.exe -Command "iwr https://github.com/h4rldev/eula/releases/latest/download/eula.exe -OutFile './eula.exe'"
eula.exe
if %errorlevel% EQU 0 (
	del eula.exe
	cls
) else (
	echo eula shat itself
	pause
	exit
)

goto :start