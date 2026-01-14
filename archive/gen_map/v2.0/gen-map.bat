@echo off

SET seed=0

SET name=SaltMines
SET scale=8
SET size=2048

SET dirServer=E:\Games\Servers\Factorio

SET world=MapGen

SET configDir=%dirServer%\config\%world%
SET config=%configDir%\config.ini

SET file=%name%_seed-%seed%_scale-%scale%_size-%size%.png

"E:\Games\SteamLibrary\steamapps\common\Factorio\bin\x64\factorio.exe" -c %config% --generate-map-preview %file% --map-gen-seed %seed% --map-preview-scale %scale% --map-preview-size %size%

pause