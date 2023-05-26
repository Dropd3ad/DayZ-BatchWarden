:: ================================================================================================================================ ::
@ECHO OFF
:: =============================================== ::
::                EDIT THIS SECTION                ::
::             -----------------------             ::
::                GENERAL SETTINGS                 ::
:: =============================================== ::
:: BatchWarden created by: FlakeZ
:: Link: https://github.com/SFlakeZ/DayZ-BatchWarden

:: DEFAULT -> DEBUG=false
SET DEBUG=true

:: Command window name (optional)
:: DEFAULT -> WINDOW_NAME="DayZ-BatchWarden"
SET WINDOW_NAME=""

:: Path to the DayZ-Standalone-Server folder (optional)
SET SERVER_PATH=""

:: Name of executable (optional)
:: DEFAULT -> DAYZ_EXE="DayZServer_x64.exe"
SET DAYZ_EXE=""

:: Logical CPU cores (optional)
:: DEFAULT -> CPU_CORES="%NUMBER_OF_PROCESSORS%"
SET CPU_CORES=""

:: Set the port of the DayZ-Standalone-Server (optional)
:: DEFAULT -> PORT="2302"
SET PORT=""

:: Set the DayZ config file (optional)
:: DEFAULT -> CONFIG="serverDZ.cfg"
SET CONFIG=""

:: Set a path for your profiles folder
:: DEFAULT -> PROFILE="X:\YourServerLocation\1-Profiles"
SET PROFILE=""

:: Set FPS limit for the server. (max is 200)
:: DEFAULT -> FPS_LIMIT="200"
SET FPS_LIMIT=""

:: Set to true to enable, false to disable
SET USE_MODS=true
	:: Path to the modlist.txt
	SET MODLIST_PATH=""

:: Set to true to enable, false to disable
SET USE_MODS_SERVER=false
	:: Path to the modlist_server.txt
	SET MODLIST_SERVER_PATH=""

:: Extra launch parameters
:: For more info see: https://community.bistudio.com/wiki/DayZ:Server_Configuration
:: In general, these parameters do not need to be adjusted
SET ADDITIONAL_PARAMETERS="-doLogs -adminLog -netLog -freezeCheck -filePatching"

:: =============================================== ::
::           Server - Automatic Restart            ::
:: =============================================== ::
:: Set specific times when the server should be restarted.
:: BattlEye-Extended-Controls can be used for alerting + shutting down the server at a specific time!
:: If you use the BEC scheduler, please set DO_RESTARTS to false
SET DO_RESTARTS=true
    :: Set specific times when the server should be restarted.
	:: If no restart is desired, it should look like this: RTIME_1=""
	SET RTIME_1="04:00"
	SET RTIME_2="10:00"
	SET RTIME_3="16:00"
	SET RTIME_4="22:00"

:: =============================================== ::
::           BattlEye-Extented-Controls            ::
:: =============================================== ::
:: BEC created by: nuxil/Stian Mikalsen
:: GITHUB: https://github.com/TheGamingChief/BattlEye-Extended-Controls
:: If you are using BEC, go to "Config.cfg" (line 22) and change
:: BePath = C:\dayz\1-Profiles\BattlEye
:: You also have to create a "bans.txt" file inside the BattlEye folder

:: Enable/Disable BattlEye-Extented-Controls to monitor the server
SET USE_BEC=false

:: Path to the BattlEye-Extended-Controls folder (optional)
SET BEC_PATH=""

:: Name of the executable (optional)
SET BEC_EXE="Bec.exe"

:: =============================================== ::
::           SteamCMD - Automatic Updater          ::
:: =============================================== ::
:: SteamCMD created by: valvesoftware
:: LINK: https://developer.valvesoftware.com/wiki/SteamCMD

:: SteamCMD - Automatic Updater for server files and mods
:: To many login requests result in an error: "Rate Limit Exceeded"
:: We slowed the update process down, to avoid a 30 min cooldown.
:: If you get that message, please disable this feature.
:: Any request within this cooldown will reset the timer back to 30 min.
:: Set to true to enable, false to disable
SET USE_STEAMCMD=true

:: Path to the SteamCMD folder (required)
SET STEAMCMD_PATH="C:\Program Files\steamcmd"

:: Name of the executable (optional)
SET STEAMCMD_EXE="SteamCMD.exe"

:: Name of the Steam account that SteamCMD uses (required)
:: It is highly advised that you use a separate Steam account
:: for the DayZ server if you choose to use this feature
SET ACCOUNT_NAME=""

:: Path to the Update/Download folder (optional)
:: The download folder is only used to download mods
:: and synchronize them with the existing server files
SET DOWNLOAD_PATH="C:\dayz\0-updates"


:: =============================================== ::
::                 DayZ SA Launcher                ::
:: =============================================== ::
:: xxxx
:: LINK: https://dayzsalauncher.com/#/tools

:: Set to true to enable, false to disable
SET USE_DZSAL=false

:: Path to the DZSAL folder (optional)
SET DZSAL_PATH=""

:: Name of DayZ SA Launcher Mod Server exe (optional)
:: DEFAULT -> DZSAL_EXE="DZSALModServer.exe"
SET DZSAL_EXE=""

:: Extra launch parameters (optional)
:: For more info see command line parameters
:: section of: https://dayzsalauncher.com/#/tools
SET DZSAL_PARAMETERS=""

:: =============================================== ::
::            Server - Automatic BackUp            ::
:: =============================================== ::
:: Will be added soon
::
:: This will be the section for the backup tool
:: Dependencies:
::   - Fortfiles: http://ss64.com/nt/forfiles.html
::   - 7zip: http://www.7-zip.org
::
:: METHOD 1 - BackUp after every restart (not recommended)
:: METHOD 2 - BackUp after a specific restart (recommended)
:: METHOD 3 - BackUp on launching the script (not recommended)

:: ================================================================================================================================ ::

:: =============================================== ::
::     DO NOT CHANGE ANYTHING BELOW THIS POINT     ::
::       UNLESS YOU KNOW WHAT YOU ARE DOING        ::
:: =============================================== ::

:: DelayedExpansion will cause variables to be expanded
:: at execution time rather than at parse time
SETLOCAL EnableExtensions EnableDelayedExpansion
>NUL CHCP 65001

:: Used for color text output
FOR /F "tokens=1,2 delims=#" %%a IN ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') DO (
  SET "DEL=%%a"
)

:: Checked config [true/false]
SET CFG_CHECKED=false
:: Updated server [true/false]
SET UTD_SERVER=false
:: Updated mods [true/false]
SET UTD_MODS=false
:: Updated server mods [true/false]
SET UTD_MODS_SERVER=false
:: Ready for start up [true/false]
SET RDY_START=false
:: Variables to save restart-counts
SET SCHEDULED_RESTARTS=0
SET UNSCHEDULED_RESTARTS=0

:: Print logo - no other use
:PRINT_LOGO
TITLE %WINDOW_NAME%
CLS
ECHO.
ECHO  =========================================================
ECHO  "    _____     _       _   _ _ _           _            "
ECHO  "   | __  |___| |_ ___| |_| | | |___ ___ _| |___ ___    "
ECHO  "   | __ -| .'|  _|  _|   | | | | .'|  _| . | -_|   |   "
ECHO  "   |_____|__,|_| |___|_|_|_____|__,|_| |___|___|_|_|   "
ECHO  "                                                       "
ECHO  =========================================================
ECHO.
IF %UTD_MODS% == false (
	IF %UTD_SERVER% == false (
		IF %CFG_CHECKED% == true (
			ECHO [STATUS] Configuration:
			@ TIMEOUT 1 >NUL
			CALL :COLOR 0a "  OKAY"
			ECHO.
			IF %USE_STEAMCMD% == true (
				@ TIMEOUT 1 >NUL
				ECHO [STATUS] Updating server files:
				GOTO UPDATE_SERVER
			)
		)
	) ELSE (
			ECHO [STATUS] Configuration:
			CALL :COLOR 0a "  OKAY"
			ECHO.
			ECHO [STATUS] Updating server files:
			CALL :COLOR 0a "  DONE"
			ECHO.
			@ TIMEOUT 1 >NUL
			IF %USE_MODS% == true (
				ECHO [STATUS] Updating mods:
				GOTO UPDATE_MODS
			) ELSE IF %USE_MODS_SERVER% == true (
					ECHO [STATUS] Updating mods:
					GOTO UPDATE_MODS_SERVER
			)
			GOTO PRINT_LOGO
	)
) ELSE (
		IF %RDY_START% == false (
			ECHO [STATUS] Configuration:
			CALL :COLOR 0a "  OKAY"
			ECHO.
			ECHO [STATUS] Updating server files:
			CALL :COLOR 0a "  DONE"
			ECHO.
			ECHO [STATUS] Updating mods:
			CALL :COLOR 0a "  DONE"
			ECHO.
			SET RDY_START=true
			@ TIMEOUT 4 >NUL
			GOTO PRINT_LOGO
		)
		GOTO START_SERVER
)

:: Remove all quotes from mentioned variables
:DEQUOTE
:: General - variables
SET WINDOW_NAME=%WINDOW_NAME:"=%
SET SERVER_PATH=%SERVER_PATH:"=%
SET DAYZ_EXE=%DAYZ_EXE:"=%
SET CPU_CORES=%CPU_CORES:"=%
SET PORT=%PORT:"=%
SET CONFIG=%CONFIG:"=%
SET PROFILE=%PROFILE:"=%
SET FPS_LIMIT=%FPS_LIMIT:"=%
SET MODLIST_PATH=%MODLIST_PATH:"=%
SET MODLIST_SERVER_PATH=%MODLIST_SERVER_PATH:"=%
SET ADDITIONAL_PARAMETERS=%ADDITIONAL_PARAMETERS:"=%
:: BattlEye-Extented-Controls
SET BEC_PATH=%BEC_PATH:"=%
SET BEC_EXE=%BEC_EXE:"=%
:: SteamCMD - variables
SET STEAMCMD_PATH=%STEAMCMD_PATH:"=%
SET ACCOUNT_NAME=%ACCOUNT_NAME:"=%
SET DOWNLOAD_PATH=%DOWNLOAD_PATH:"=%
:: DZSAL - variables
SET DZSAL_PATH=%DZSAL_PATH:"=%
SET DZSAL_EXE=%DZSAL_EXE:"=%

:: Variables checked (?)
IF %CFG_CHECKED% == true (
	GOTO PRINT_LOGO
)

:: Check/Fix settings + use automatic path detection
:CONFIG_CHECK
:: Checking variable: WINDOW_NAME
IF ["%WINDOW_NAME%"] == [""] (
	SET WINDOW_NAME="DayZ-Standalone-Server"
	ECHO [INFO] No value has been defined for "WINDOW_NAME".
	ECHO [INFO] Fallback: (!WINDOW_NAME!^)
	@ TIMEOUT 1 >NUL
	ECHO.
)
:: Checking variable: SERVER_PATH
IF ["%SERVER_PATH%"] == [""] (
	SET "SERVER_PATH=%~dp0"
	ECHO [INFO] No value has been defined for "SERVER_PATH".
	ECHO [INFO] Fallback: ("!SERVER_PATH!"^)
	@ TIMEOUT 1 >NUL
	ECHO.
)
:: Checking variable: DAYZ_EXE
IF ["%DAYZ_EXE%"] == [""] (
	SET DAYZ_EXE="DayZServer_x64.exe"
	ECHO [INFO] No value has been defined for "DAYZ_EXE".
	ECHO [INFO] Fallback: (!DAYZ_EXE!^)
	@ TIMEOUT 1 >NUL
	ECHO.
)
:: Checking variable: CPU_CORES
IF ["%CPU_CORES%"] == [""] (
	SET CPU_CORES=%NUMBER_OF_PROCESSORS%
	ECHO [INFO] No value has been defined for "CPU_CORES".
	ECHO [INFO] Fallback: ("!CPU_CORES!"^)
	@ TIMEOUT 1 >NUL
	ECHO.
)
IF %CPU_CORES% GTR %NUMBER_OF_PROCESSORS% (
	SET CPU_CORES="%NUMBER_OF_PROCESSORS%"
	ECHO [INFO] The value is greater than the maximum for "CPU_CORES".
	ECHO [INFO] Fallback: (!CPU_CORES!^)
	@ TIMEOUT 1 >NUL
	ECHO.
) ELSE IF %CPU_CORES% LEQ 1 (
	SET CPU_CORES="1"
	ECHO [INFO] The value is lower than the minimum for "CPU_CORES".
	ECHO [INFO] Fallback: (!CPU_CORES!^)
	@ TIMEOUT 1 >NUL
	ECHO.
)
:: Checking variable: PORT
IF ["%PORT%"] == [""] (
	SET PORT="2302"
	ECHO [INFO] No value has been defined for "PORT".
	ECHO [INFO] Fallback: (!PORT!^)
	@ TIMEOUT 1 >NUL
	ECHO.
)
:: Checking variable: CONFIG
IF ["%CONFIG%"] == [""] (
	SET CONFIG="serverDZ.cfg"
	ECHO [INFO] No value has been defined for "CONFIG".
	ECHO [INFO] Fallback: (!CONFIG!^)
	@ TIMEOUT 1 >NUL
	ECHO.
)
:: Checking variable: PROFILE
IF ["%PROFILE%"] == [""] (
	SET PROFILE="1-Profiles"
	ECHO [INFO] No value has been defined for "PROFILE".
	ECHO [INFO] Fallback: (!PROFILE!^)
	@ TIMEOUT 1 >NUL
	ECHO.
)
:: Checking variable: FPS_LIMIT
IF ["%FPS_LIMIT%"] == [""] (
	SET FPS_LIMIT=200
	ECHO [INFO] No value has been defined for "FPS_LIMIT".
	ECHO [INFO] Fallback: ("!FPS_LIMIT!"^)
	@ TIMEOUT 1 >NUL
	ECHO.
)
IF %FPS_LIMIT% GTR 200 (
	SET FPS_LIMIT="200"
	ECHO [INFO] The value is greater than the maximum for "FPS_LIMIT".
	ECHO [INFO] Fallback: (!FPS_LIMIT!^)
	@ TIMEOUT 1 >NUL
	ECHO.
)
IF %FPS_LIMIT% LEQ 1 (
	SET FPS_LIMIT="200"
	ECHO [INFO] The value is lower than the minimum for "FPS_LIMIT".
	ECHO [INFO] Fallback: (!FPS_LIMIT!^)
	@ TIMEOUT 1 >NUL
	ECHO.
)
:: Checking variable: MODLIST_PATH
IF %USE_MODS% == true (
	IF ["%MODLIST_PATH%"] == [""] (
		SET "MODLIST_PATH=%~dp0"
		SET MODLIST_PATH="!MODLIST_PATH!modlist.txt"
		ECHO [INFO] No value has been defined for "MODLIST_PATH".
		ECHO [INFO] Fallback: (!MODLIST_PATH!^)
		@ TIMEOUT 1 >NUL
		ECHO.
	)
)
:: Checking variable: MODLIST_SERVER_PATH
IF %USE_MODS_SERVER% == true (
	IF ["%MODLIST_SERVER_PATH%"] == [""] (
		SET "MODLIST_SERVER_PATH=%~dp0"
		SET MODLIST_SERVER_PATH="!MODLIST_SERVER_PATH!modlist_server.txt"
		ECHO [INFO] No value has been defined for "MODLIST_SERVER_PATH".
		ECHO [INFO] Fallback: (!MODLIST_SERVER_PATH!^)
		@ TIMEOUT 1 >NUL
		ECHO.
	)
)
:: Checking variable: BEC_PATH
IF %USE_BEC% == true (
	IF ["%BEC_PATH%"] == [""] (
		FOR /d %%i IN (%SERVER_PATH%*) DO (
			SET DIR=%%i
  			IF EXIST "!DIR:\\=\!\bec.exe" (
				SET BEC_PATH=%%i
			)
		)
		IF ["!BEC_PATH!"] == [""] (
			ECHO [WARN] Could not find "bec.exe" in "!SERVER_PATH!" and subfolders.
			ECHO [INFO] Temporarly disabling BEC startup.
			SET USE_BEC=false
			@ TIMEOUT 1 >NUL
			ECHO.
		)
	)
)
:: Checking variable: STEAMCMD_PATH
IF %USE_STEAMCMD% == true (
	IF ["%STEAMCMD_PATH%"] == [""] (
		ECHO [INFO] No value has been defined for "STEAMCMD_PATH".
		ECHO [INFO] Disabling SteamCMD feature.
		SET USE_STEAMCMD=false
		@ TIMEOUT 1 >NUL
		ECHO.
	) ELSE (
		IF NOT EXIST "!STEAMCMD_PATH:\\=\!\steamcmd.exe" (
			ECHO [WARN] Could not find "steamcmd.exe" in "!STEAMCMD_PATH!".
			ECHO [INFO] Temporarly disabling SteamCMD startup.
			SET USE_STEAMCMD=false
			@ TIMEOUT 1 >NUL
			ECHO.
		)
	)
)
:: Checking variable: DZSAL_EXE
IF %USE_DZSAL% == true (
		IF ["%DZSAL_EXE%"] == [""] (
		SET DZSAL_EXE="DZSALModServer.exe"
		ECHO [INFO] No value has been defined for "DZSAL_EXE".
		ECHO [INFO] Fallback: (!DZSAL_EXE!^)
		@ TIMEOUT 1 >NUL
		ECHO.
	)
)
:: Checking variable: DZSAL_PATH
IF %USE_DZSAL% == true (
	IF ["%DZSAL_PATH%"] == [""] (
		IF NOT EXIST "!SERVER_PATH:\\=\!\!DZSAL_EXE!" (
			ECHO [WARN] Could not find "!DZSAL_EXE!" in "!SERVER_PATH!".
			ECHO [INFO] Temporarly disabling DZSAL-Modserver startup.
			SET USE_DZSAL=false
			@ TIMEOUT 1 >NUL
			ECHO.
		) ELSE (
			SET DZSAL_PATH="!SERVER_PATH!"
			ECHO [INFO] No value has been defined for "DZSAL_PATH".
			ECHO [INFO] Fallback: (!DZSAL_PATH!^)
			@ TIMEOUT 1 >NUL
			ECHO.
		)
	)
)
SET CFG_CHECKED=true
GOTO DEQUOTE


:: STEAMCMD - Update/Install DayZ-Standalone-Server
:UPDATE_SERVER
CD %STEAMCMD_PATH%
%STEAMCMD_EXE% +force_install_dir %SERVER_PATH% +login %ACCOUNT_NAME% +"app_update 223350" validate +quit >NUL
SET UTD_SERVER=true
GOTO PRINT_LOGO


:: STEAMCMD - Update/Install Mods
:UPDATE_MODS
SET MOD_IDS=
FOR /f "tokens=1,2 delims=," %%g IN (%MODLIST_PATH%) DO (
	SET MOD_IDS=!MOD_IDS!+workshop_download_item 221100 "%%g" 
)
%STEAMCMD_EXE% +force_install_dir %DOWNLOAD_PATH% +login %ACCOUNT_NAME% !MOD_IDS! +quit >NUL
FOR /f "tokens=1,2 delims=," %%g IN (%MODLIST_PATH%) DO (
	robocopy "%DOWNLOAD_PATH%\steamapps\workshop\content\221100\%%g" "%SERVER_PATH%\%%h" *.* /mir >NUL
)
SET SEARCH_PATH=%MODLIST_PATH%
:: This part generates the modlist string which is used for a start up flag
SET MODLIST="-mod=
FOR /f "tokens=1,2 delims=," %%g IN (%MODLIST_PATH%) DO (
	SET MODLIST=!MODLIST!%%h;
)
SET MODLIST=!MODLIST!"
GOTO SYNC_KEYS


:: STEAMCMD - Update/Install Server Mods
:UPDATE_MODS_SERVER
IF %USE_MODS_SERVER% == false (
	SET UTD_MODS=true
	GOTO PRINT_LOGO
)
SET MOD_SERVER_IDS=
FOR /f "tokens=1,2 delims=," %%g IN (%MODLIST_SERVER_PATH%) DO (
	SET MOD_SERVER_IDS=!MOD_SERVER_IDS!+workshop_download_item 221100 "%%g" 
)
%STEAMCMD_EXE% +force_install_dir %DOWNLOAD_PATH% +login %ACCOUNT_NAME% !MOD_SERVER_IDS! +quit >NUL
FOR /f "tokens=1,2 delims=," %%g IN (%MODLIST_SERVER_PATH%) DO (
	robocopy "%DOWNLOAD_PATH%\steamapps\workshop\content\221100\%%g" "%SERVER_PATH%\%%h" *.* /mir >NUL
)
SET SEARCH_PATH=%MODLIST_SERVER_PATH%
:: This part generates the server modlist string which is used for a start up flag
SET MODLIST_SERVER="-serverMod=
FOR /f "tokens=1,2 delims=," %%g IN (%MODLIST_SERVER_PATH%) DO (
	SET MODLIST_SERVER=!MODLIST_SERVER!%%h;
)
SET MODLIST_SERVER=!MODLIST_SERVER!"
SET UTD_MODS_SERVER=true
GOTO SYNC_KEYS


:: BatchWarden - Sync *.bikey(s) from each mod/server mod with the servers keys folder (robocopy ... /NFL /NDL /NJH /NJS /nc /ns /np)
:SYNC_KEYS
FOR /f "tokens=1,2 delims=," %%g IN (%SEARCH_PATH%) DO (
	ROBOCOPY "%SERVER_PATH%\%%h\keys" "%SERVER_PATH%\keys" *.bikey >NUL
	IF !ERRORLEVEL! EQU 16 (
		ROBOCOPY "%SERVER_PATH%\%%h\key" "%SERVER_PATH%\keys" *.bikey >NUL
		IF !ERRORLEVEL! EQU 16 (
			ECHO [WARN] It seems that %%h has no "keys" or "key" folder.
			ECHO [INFO] Please check the mod folder. Maybe it is only used for repacking purposes.
			ECHO.
		)
	)

	IF !ERRORLEVEL! EQU 2 (
		ECHO [INFO] Successfully synced keys for "%%h"! >NUL
		ECHO [INFO] Some extra files or directories were detected. No files were copied. >NUL
	) ELSE IF !ERRORLEVEL! EQU 3 (
			ECHO [INFO] Successfully synced keys for "%%h"! >NUL
			ECHO [INFO] Some files were copied. Additional files were present. >NUL
	)
)
IF %UTD_MODS_SERVER% == false (
	GOTO UPDATE_MODS_SERVER
)
:: Both mods and server mods are updated!
SET UTD_MODS=true
GOTO PRINT_LOGO


:: DayZ Standalone Server start up
:START_SERVER

TASKLIST /FI "IMAGENAME eq %DAYZ_EXE%" 2>NUL | find /I /N "%DAYZ_EXE%" >NUL
IF %ERRORLEVEL% == 0 GOTO LOOP

IF %USE_DZSAL% == false (
	CD %SERVER_PATH%
	START "%WINDOW_NAME%" /MIN /D %SERVER_PATH% %DAYZ_EXE% -profiles=%PROFILE% -config=%CONFIG% -port=%PORT% -cpuCount=%CPU_CORES% -limitFPS=%FPS_LIMIT% %MODLIST% %MODLIST_SERVER% %ADDITIONAL_PARAMETERS%
	@ TIMEOUT 2 >NUL
	ECHO [INFO] The server has been started.
) ELSE (
	CD %DZSAL_PATH%
	START "%WINDOW_NAME%" /MIN %DZSAL_EXE% -config=%CONFIG% -port=%PORT% %MODLIST%
	@ TIMEOUT 2 >NUL
	ECHO [INFO] DZSAL-Modserver has been started.
)

ECHO [INFO] Scheduled restarts: %SCHEDULED_RESTARTS%
ECHO [INFO] Unscheduled restarts: %UNSCHEDULED_RESTARTS%
ECHO [INFO] To stop the server please close this task then the other tasks, otherwise it will restart.

IF %USE_BEC% == true (
	@ TIMEOUT 5 >NUL
	ECHO [INFO] BattlEye-Extended-Controls has been started.
	CD %BEC_PATH%
	START %BEC_EXE% -f Config.cfg --dsc
)
GOTO START_SERVER


:LOOP
FOR /L %%x IN (1,1,15) DO (
	TASKLIST /FI "IMAGENAME eq %DAYZ_EXE%" 2>NUL | find /I /N "%DAYZ_EXE%" >NUL
	IF !ERRORLEVEL! == 1 (
		ECHO [WARN] The server has crashed or been shut down.
		SET /A UNSCHEDULED_RESTARTS+=1
		@ TIMEOUT 2 >NUL
		GOTO PRINT_LOGO
		)
	@ TIMEOUT 2 >NUL
)

FOR /f "tokens=1-2 delims=/:" %%a IN ('TIME /t') DO (SET CTIME=%%a:%%b)

IF "%CTIME%"==%RTIME_1% (
	GOTO RESTART
)
IF "%CTIME%"==%RTIME_2% (
	GOTO RESTART
)
IF "%CTIME%"==%RTIME_3% (
	GOTO RESTART
)
IF "%CTIME%"==%RTIME_4% (
	GOTO RESTART
)
GOTO LOOP


:RESTART
TASKKILL /im "%DAYZ_EXE%" /F
IF %USE_BEC% == true (
	TASKKILL /im "%BEC_EXE%" /F
)
IF %USE_DZSAL% == true (
	TASKKILL /im "%DZSAL_EXE%" /F
)
ECHO [RESTART] Shutting down DayZ Standalone server...
SET /A SCHEDULED_RESTARTS+=1
@ TIMEOUT 4 >NUL
GOTO PRINT_LOGO

EXIT
:: Color text in console output
:COLOR
ECHO OFF
<NUL SET /p ".=%DEL%" > "%~2"
FINDSTR /v /a:%1 /R "^$" "%~2" NUL
DEL "%~2" > NUL 2>&1i

:: ================================================================================================================================ ::