@echo off

SET world=Solo


SET dir=E:\Games\Standalone\Factorio\Factorio_Server

SET save=%dir%\saves\%world%.zip
SET configDir=%dir%\config\%world%

SET config=%configDir%\config.ini
SET settings=%configDir%\server-settings.json
SET whitelist=%configDir%\server-whitelist.json

"E:\Games\SteamLibrary\steamapps\common\Factorio\bin\x64\factorio.exe" --start-server %save% -c %config% --server-settings %settings% --use-server-whitelist true --server-whitelist %whitelist%

pause