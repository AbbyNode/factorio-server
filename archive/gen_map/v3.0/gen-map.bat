@echo off

SET /P seed=Seed: 
SET /P name=Name Prefix: 

SET scale=1
SET size=4096

SET world=MapGen

SET dirServer=E:\Games\Servers\Factorio
SET configDir=%dirServer%\config\%world%
SET config=%configDir%\config.ini
SET mapGenSettings=map-gen-settings.json

SET mapGenSettingsParam=
IF EXIST %mapGenSettings% (
	SET mapGenSettingsParam=--map-gen-settings %mapGenSettings%
)

SET file=%name%_seed-%seed%_scale-%scale%_size-%size%.png

"E:\Games\SteamLibrary\steamapps\common\Factorio\bin\x64\factorio.exe" -c %config% --generate-map-preview %file% %mapGenSettingsParam% --map-gen-seed %seed% --map-preview-scale %scale% --map-preview-size %size%

pause