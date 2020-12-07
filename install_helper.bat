@echo off
for /F "tokens=2 delims==" %%a in ('findstr "Secret=" options.txt') do set "Secret=%%a"
echo %Secret%
for /F "tokens=2 delims==" %%a in ('findstr "ID=" options.txt') do set "ID=%%a"
echo %ID%

setx SPOTIPY_CLIENT_ID %Secret% /m
setx SPOTIPY_CLIENT_SECRET %ID% /m

pause