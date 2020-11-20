
@echo off
:check
spotify_dl -h
if %ERRORLEVEL% NEQ 0 (goto downsp) else cls
ffmpeg -h
if %ERRORLEVEL% NEQ 0 (cls & goto downffmpeg) else cls

:restart
echo *************************************************************
echo *                   Welcome to Spotify_dl GUI               *
echo *************************************************************



set /p link="Playlist link: " link:

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
IF ERRORLEVEL 2 GOTO stop
IF ERRORLEVEL 1 cls & GOTO restart

:stop
stop


:downsp
pip3 install spotify_dl
goto check
:downffmpeg
powershell -Command "Invoke-WebRequest https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.7z -OutFile ffmpeg.zip"
7zip\7za.exe e ffmpeg.zip
del *.html & del ffmpeg.zip & del *.ffpreset & del README.txt & del LICENSE & del *.css
@RD /S /Q bin & @RD /S /Q doc & @RD /S /Q presets
goto check