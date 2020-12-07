
@echo off
:check
pip3 -h
if %ERRORLEVEL% NEQ 0 (goto angry) else cls
spotify_dl -h
if %ERRORLEVEL% NEQ 0 (goto downsp) else cls
ffmpeg -h
if %ERRORLEVEL% NEQ 0 (cls & goto downffmpeg) else cls

:restart
:::   _____             _   _  __       _____  _        _____ _    _ _____ 
:::  / ____|           | | (_)/ _|     |  __ \| |      / ____| |  | |_   _|
::: | (___  _ __   ___ | |_ _| |_ _   _| |  | | |     | |  __| |  | | | |  
:::  \___ \| '_ \ / _ \| __| |  _| | | | |  | | |     | | |_ | |  | | | |  
:::  ____) | |_) | (_) | |_| | | | |_| | |__| | |____ | |__| | |__| |_| |_ 
::: |_____/| .__/ \___/ \__|_|_|  \__, |_____/|______| \_____|\____/|_____|
:::        | |                     __/ |           ______                  
:::        |_|                    |___/           |______|                 
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A
echo.
echo.

set /p link=" Playlist link: " link:
For /F "Tokens=1 Delims=" %%I In ('cscript //nologo BrowseFolder.vbs') Do Set _FolderName=%%I
set downpath=%_foldername% 

spotify_dl -l %link% -o %downpath%

ECHO.
ECHO.
ECHO 1.Download another one
ECHO 2.Quit
ECHO.

CHOICE /C 12 /M "Enter your choice:"

:: Note - list ERRORLEVELS in decreasing order
IF ERRORLEVEL 2 GOTO EOF
IF ERRORLEVEL 1 cls & GOTO restart


:downsp
pip3 install spotify_dl
cls
for /F "tokens=2 delims==" %%a in ('findstr /I "Secret=" options.txt') do set "Secret=%%a"
SET SPOTIPY_CLIENT_ID=%Secret%
for /F "tokens=2 delims==" %%a in ('findstr /I "ID=" options.txt') do set "ID=%%a"
SET SPOTIPY_CLIENT_SECRET=%ID%

goto check

:downffmpeg
powershell -Command "Invoke-WebRequest https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.7z -OutFile ffmpeg.zip"
7zip\7za.exe e ffmpeg.zip
del *.html & del ffmpeg.zip & del *.ffpreset & del README.txt & del LICENSE & del *.css
@RD /S /Q bin & @RD /S /Q doc & @RD /S /Q presets

:angry
cls
echo PLEASE DOWNLOAD PYTHON FROM: https://python.org/

goto check
