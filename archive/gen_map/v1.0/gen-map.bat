@echo off

SET world=MapGen

SET name=FindIsland
SET seed=3881149764
SET scale=2
SET size=2048

SET dir=E:\Games\Standalone\Factorio\Factorio_Server

SET save=%dir%\saves\%world%.zip
SET configDir=%dir%\config\%world%

SET config=%configDir%\config.ini
SET settings=%configDir%\server-settings.json
SET whitelist=%configDir%\server-whitelist.json

SET file=%name%_seed-%seed%_scale-%scale%_size-%size%.png

"E:\Games\SteamLibrary\steamapps\common\Factorio\bin\x64\factorio.exe" -c %config% --generate-map-preview %file% --map-gen-seed %seed% --map-preview-scale %scale% --map-preview-size %size%

pause