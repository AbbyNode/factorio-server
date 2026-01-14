@echo off

SET world=MapGen

SET name=FindIsland
SET seed=3503477909
SET scale=4
SET size=256

SET count=50

SET dir=E:\Games\Standalone\Factorio\Factorio_Server

SET save=%dir%\saves\%world%.zip
SET configDir=%dir%\config\%world%

SET config=%configDir%\config.ini
SET settings=%configDir%\server-settings.json
SET whitelist=%configDir%\server-whitelist.json

SET dir=%name%_scale-%scale%_size-%size%\

mkdir %dir%

"E:\Games\SteamLibrary\steamapps\common\Factorio\bin\x64\factorio.exe" -c %config% --generate-map-preview %dir% --generate-map-preview-random %count% --map-preview-scale %scale% --map-preview-size %size%

pause