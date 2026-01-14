@echo off

SET count=100

SET name=BruhOhMomentMoment
SET scale=4
SET size=512

SET dirServer=E:\Games\Servers\Factorio

SET world=MapGen

SET configDir=%dirServer%\config\%world%
SET config=%configDir%\config.ini

SET dirMap=%name%_scale-%scale%_size-%size%\

mkdir %dirMap%

"E:\Games\SteamLibrary\steamapps\common\Factorio\bin\x64\factorio.exe" -c %config% --generate-map-preview %dirMap% --generate-map-preview-random %count% --map-preview-scale %scale% --map-preview-size %size%

pause