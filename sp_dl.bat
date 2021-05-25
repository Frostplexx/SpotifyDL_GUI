
@echo off
title Spotify_dl
:check
	pip3 -h
	if %ERRORLEVEL% NEQ 0 (goto downpy) else cls
	spotify_dl -h
	if %ERRORLEVEL% NEQ 0 (goto downsp) else cls
	ffmpeg -h
	if %ERRORLEVEL% NEQ 0 (cls & goto downffmpeg) else cls
:restart
	echo   _____             _   _  __       _____  _        _____ _    _ _____ 
	echo  ^/ ____^|           ^| ^| (_^)^/ _^|     ^|  __ \^| ^|      / ____^| ^|  ^| ^|_   _^|
	echo ^| (___  _ __   ___ ^| ^|_ _^| ^|_ _   _^| ^|  ^| ^| ^|     ^| ^|  __^| ^|  ^| ^| ^| ^|  
	echo  ^\___ \^| '_ ^\ ^/ _ \^| __^| ^|  _^| ^| ^| ^| ^|  ^| ^| ^|     ^| ^| ^|_ ^| ^|  ^| ^| ^| ^|  
	echo  ____^) ^| ^|_^) ^| ^(_^) ^| ^|_^| ^| ^| ^| ^|_^| ^| ^|__^| ^| ^|____ ^| ^|__^| ^| ^|__^| ^|_^| ^|_ 
	echo ^|_____/^| .__^/ ^\___/ \__^|_^|_^|  \__, ^|_____/^|______^| \_____^|\____/^|_____^|
	echo        ^| ^|                     __/ ^|           ______                  
	echo        ^|_^|                    ^|___/           ^|______^|  

	echo. 
	echo.
	set /p link=" Playlist/Song link: " link:
	For /F "Tokens=1 Delims=" %%I In ('cscript //nologo BrowseFolder.vbs') do set downpath=%%I

	spotify_dl -l %link% -o %downpath%

	ECHO.
	ECHO.
	ECHO 1. Download another one
	ECHO 2. Quit
	ECHO 3. Convert files to .ogg
	ECHO.

	CHOICE /C 123 /M "Enter your choice:"

	:: Note - list ERRORLEVELS in decreasing order
	IF ERRORLEVEL 3 cls & GOTO converter
	IF ERRORLEVEL 2 GOTO EOF
	IF ERRORLEVEL 1 cls & GOTO restart


:downsp
	copy options.txt %tmp%\options.txt
	if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)
	pip3 install spotify_dl
	cls
	for /F "tokens=2 delims==" %%a in ('findstr /I "Secret=" %tmp%\options.txt') do set "Secret=%%a"
	setx SPOTIPY_CLIENT_SECRET %Secret% /m
	for /F "tokens=2 delims==" %%a in ('findstr /I "ID=" %tmp%\options.txt') do set "ID=%%a"
	setx SPOTIPY_CLIENT_ID %ID% /m
	del /f /q %tmp%\options.txt
	echo Please restart SpotifyDL_GUI to apply the Path variables
	timeout /t 10 
	goto EOF 

:downffmpeg
	echo Downloading ffmpeg, please wait...
	powershell -Command "Invoke-WebRequest https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.7z -OutFile ffmpeg.zip"
	7zip\7za.exe e ffmpeg.zip
	del *.html & del ffmpeg.zip & del *.ffpreset & del README.txt & del LICENSE & del *.css
	rd /S /Q bin & rd /S /Q doc & rd /S /Q presets
	for /f "delims=" %%a in ('dir /b /ad /on "ffmpeg*"') do set ffmpeg=%%a
	rmdir %ffmpeg%
	goto check

:downpy
	cls
	if NOT exist python.exe (
		echo downloading python...
		powershell -Command "Invoke-WebRequest https://www.python.org/ftp/python/3.9.0/python-3.9.0-amd64.exe -OutFile python.exe"
	)
	start python.exe
	pause
	goto check

:converter
	for /F "Tokens=1 Delims=" %%I In ('cscript //nologo BrowseFolder.vbs') do set downpath=%%I
	for %%a in ("%downpath%\*.mp3") do ffmpeg -i "%%a" "%downpath%\%%~na.ogg"
	for %%a in ("%downpath%\*.mp3") do del "%%~a"
	echo Finished!
	timeout /t 2
	cls
	goto restart