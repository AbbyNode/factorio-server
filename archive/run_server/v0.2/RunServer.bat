@echo off

SET world=%1

ECHO Starting server: %world%

SET dir=E:\Games\Servers\Factorio

SET save=%dir%\saves\%world%.zip
SET configDir=%dir%\config\%world%

SET config=%configDir%\config.ini
SET settings=%configDir%\server-settings.json
SET whitelist=%configDir%\server-whitelist.json
SET mapsettings=%configDir%\map-setting.json
SET mapgetnsettings=%configDir%\map-gen-settings.json

"E:\Games\SteamLibrary\steamapps\common\Factorio\bin\x64\factorio.exe" --start-server %save% -c %config% --server-settings %settings% --use-server-whitelist true --server-whitelist %whitelist%

pause
