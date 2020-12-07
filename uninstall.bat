@echo off

pip uninstall spotify_dl
pip uninstall youtube_dl



setlocal EnableDelayedExpansion
set path
set $line=%path%
set $line=%$line: =#%
set $line=%$line:;= %
set $line=%$line:)=^^)%

for %%a in (%$line%) do echo %%a | find /i "SPOTIPY_CLIENT_ID" || set $newpath=!$newpath!;%%a
set $newpath=!$newpath:#= !
set $newpath=!$newpath:^^=!
set path=!$newpath:~1!

setlocal EnableDelayedExpansion
set path
set $line=%path%
set $line=%$line: =#%
set $line=%$line:;= %
set $line=%$line:)=^^)%

for %%a in (%$line%) do echo %%a | find /i "SPOTIPY_CLIENT_SECRET" || set $newpath=!$newpath!;%%a
set $newpath=!$newpath:#= !
set $newpath=!$newpath:^^=!
set path=!$newpath:~1!

cls 
echo finished uninstalling!
pause