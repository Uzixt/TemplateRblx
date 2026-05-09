:: Initialises a new Roblox Project
@echo off
setlocal

rokit init
rokit add "1Axen/Blink"
rokit add rojo
rokit add "UpliftGames/wally"
rokit add wally-package-types
rokit install

wally init
rojo init

del default.project.json
rmdir /s /q src

(
echo {
echo   "name": "NameHere",
echo   "emitLegacyScripts": false,
echo   "tree": {
echo     "$ignoreUnknownInstances": true,
echo     "$className": "DataModel",
echo.
echo     "ReplicatedStorage": {
echo       "$className": "ReplicatedStorage",
echo       "$ignoreUnknownInstances": true,
echo       "$path": "src/ReplicatedStorage",
echo       "Packages": {
echo                 "$path": "Packages"
echo             }
echo     },
echo.
echo     "ReplicatedFirst": {
echo       "$className": "ReplicatedFirst",
echo       "$ignoreUnknownInstances": true,
echo       "$path": "src/ReplicatedFirst"
echo     },
echo.
echo     "ServerScriptService": {
echo       "$className": "ServerScriptService",
echo       "$ignoreUnknownInstances": true,
echo       "$path": "src/ServerScriptService"
echo     },
echo.
echo     "ServerStorage": {
echo       "$className": "ServerStorage",
echo       "$ignoreUnknownInstances": true,
echo       "$path": "src/ServerStorage"
echo     },
echo.
echo     "StarterPlayer": {
echo       "$className": "StarterPlayer",
echo       "$ignoreUnknownInstances": true,
echo       "StarterPlayerScripts": {
echo         "$className": "StarterPlayerScripts",
echo         "$path": "src/StarterPlayer/StarterPlayerScripts",
echo         "$ignoreUnknownInstances": true
echo       },
echo       "StarterCharacterScripts" : {
echo         "$className": "StarterCharacterScripts",
echo         "$path": "src/StarterPlayer/StarterCharacterScripts",
echo         "$ignoreUnknownInstances": true
echo       }
echo     }
echo   }
echo }
) > default.project.json

mkdir src
mkdir scripts
mkdir scripts\serve
mkdir blink
mkdir assets
mkdir assets\build
mkdir assets\docs
mkdir assets\models
mkdir assets\images

mkdir src\ReplicatedStorage
mkdir src\ReplicatedFirst
mkdir src\ServerScriptService
mkdir src\ServerStorage
mkdir src\StarterPlayer
mkdir src\StarterPlayer\StarterPlayerScripts
mkdir src\StarterPlayer\StarterCharacterScripts

mkdir src\ReplicatedStorage\Client
mkdir src\ReplicatedStorage\Client\Entry
mkdir src\ReplicatedStorage\Client\Network
mkdir src\ReplicatedStorage\Shared

mkdir src\ServerScriptService\Server
mkdir src\ServerScriptService\Server\Entry
mkdir src\ServerScriptService\Server\Network

copy /y NUL src\ReplicatedStorage\Client\Entry\ClientDependencies.luau >NUL
copy /y NUL src\ReplicatedStorage\Client\Entry\init.luau >NUL
copy /y NUL src\ReplicatedStorage\Client\Network\init.luau >NUL
copy /y NUL src\ReplicatedStorage\Shared\Tween.luau >NUL

copy /y NUL src\ServerScriptService\Server\Entry\ServerDependencies.luau >NUL
copy /y NUL src\ServerScriptService\Server\Entry\init.luau >NUL
copy /y NUL src\ServerScriptService\Server\OnPlayerJoined.luau >NUL
copy /y NUL src\ServerScriptService\Server\Network\init.luau >NUL
copy /y NUL blink\main.blink >NUL
copy /y NUL .luaurc >NUL

copy /y NUL scripts\blink.bat >NUL
copy /y NUL scripts\serve\main.bat >NUL
copy /y NUL scripts\wally.bat >NUL

(
echo local ReplicatedStorage = game^:GetService^(^"ReplicatedStorage^"^)
echo local Client = ReplicatedStorage.Client
echo.
echo local dependencies^: ^{ModuleScript} = {}
echo.
echo return dependencies
echo.
) > src\ReplicatedStorage\Client\Entry\ClientDependencies.luau

(
echo -- Entry point for the client
echo local dependencies = require^(script.ClientDependencies^)
echo.
echo for i, v in dependencies do
echo     task.spawn^(function^(^)
echo         print^(^`Client^: Initialising {v.Name}^`^)
echo         require^(v^).Init^(^)
echo     end^)
echo end 
) > src\ReplicatedStorage\Client\Entry\init.luau

(
echo --// Abstraction for TweenService
echo --// Written by @Uzixt
echo.
echo local Tween = {}
echo local TweenService = game:GetService^("TweenService"^)
echo.
echo type Element = Instance
echo type RecordEntry = ^({[string ^| number]: any}^)
echo type Records = {[Element]: RecordEntry}
echo.
echo local function processTweenInfo^(Data: RecordEntry^): TweenInfo
echo     local TweenInformation;
echo     if typeof^(Data[#Data]^) ~= "TweenInfo" then
echo         TweenInformation = TweenInfo.new^(.2^)
echo     else
echo         TweenInformation = Data[#Data]
echo         Data[#Data] = nil
echo     end
echo     return TweenInformation
echo end
echo.
echo Tween.Play = function^(InstanceTbl: Records, elementToWaitFor: Element?^)
echo     local isThere = false;
echo     for Element, Data in pairs^(InstanceTbl^) do
echo         if Element == elementToWaitFor then
echo             isThere = true
echo             continue
echo         end
echo         TweenService:Create^(
echo             Element,
echo             processTweenInfo^(Data^),
echo             Data
echo         ^):Play^(^)
echo     end
echo.
echo     if isThere and elementToWaitFor then
echo         local Data = InstanceTbl[elementToWaitFor]
echo         local toReturn = TweenService:Create^(
echo             elementToWaitFor,
echo             processTweenInfo^(Data^),
echo             Data
echo         ^)
echo         toReturn:Play^(^)
echo         return toReturn
echo     end
echo.
echo     return
echo end
echo.
echo --[[
echo     USAGE:
echo.
echo     If no TweenInfo defined, it defaults to .2
echo.
echo     local myTween = Tween.Play^({
echo         [Element] = ^{
echo             Position = UDim2.new^(2,2,2,2^)
echo         ^}
echo     ^}, Element^)
echo.
echo     Tween.Play^({
echo         [Element] = ^{
echo             Size = ...,
echo             TweenInfo.new^(5^)
echo         ^},
echo.
echo         [AnotherElement] = ^{
echo             Position = ...,
echo         ^}
@REM echo     ^})
echo.
echo ]]
echo.
echo return Tween
) > src\ReplicatedStorage\Shared\Tween.luau

(
echo -- Entry point for the server
echo local dependencies = require^(script.ServerDependencies^)
echo. 
echo for i, v in dependencies do
echo     task.spawn^(function^(^)
echo         print^(^`Server^: Initialising {v.Name}^`^)
echo         require^(v^).Init^(^)
echo     end^)
echo end 
) > src\ServerScriptService\Server\Entry\init.luau

(
echo local ServerScriptService = game^:GetService^(^"ServerScriptService^"^)
echo local Server = ServerScriptService.Server
echo. 
echo type Dependencies = { ModuleScript }
echo. 
echo local dependencies^: Dependencies = {
echo     Server.OnPlayerJoined
echo }
echo.
echo return dependencies 
) > src\ServerScriptService\Server\Entry\ServerDependencies.luau


(
echo local ServerScriptService = game:GetService^(^"ServerScriptService^"^)
echo local Players = game^:GetService^(^"Players^"^)
echo. 
echo local function OnPlayerJoined^(Player: Player^)
echo     print^(^`{Player.Name} has connected to the server!^`^)
echo end
echo. 
echo return {
echo     Init = function^(^)
echo         Players.PlayerAdded:Connect^(OnPlayerJoined^)
echo     end
echo }
) > src\ServerScriptService\Server\OnPlayerJoined.luau

(
echo.
echo sourcemap.json
echo ^*.lock
echo Packages/
) >> .gitignore

(
echo Trove = "sleitnick/trove@1.5.1"
echo Signal = "sleitnick/signal@2.0.3"
echo promise = "evaera/promise@4.0.0"
echo cmdr = "evaera/cmdr@1.12.0"
echo react = "jsdotlua/react@17.2.1"
echo react-roblox = "jsdotlua/react-roblox@17.2.1"
) >> wally.toml

(
echo option ClientOutput = "../src/ReplicatedStorage/Client/Network/blink.luau"
echo option ServerOutput = "../src/ServerScriptService/Server/Network/blink.luau"
echo.  
echo event MyFirstEvent {
echo     from: Server,
echo     type: Reliable,
echo     call: SingleAsync,
echo     data: string
echo }
echo. 
) > blink\main.blink

::blink blink/main.blink


(
echo @echo off
echo blink blink/main
) > scripts\blink.bat

call scripts/blink

(
echo @echo off
echo rojo sourcemap default.project.json --output sourcemap.json
echo rojo serve default.project.json
) > scripts\serve\main.bat

(
echo {
echo 	"languageMode": "nonstrict",
echo 	"lint": { "LocalUnused": false, "FunctionUnused": false, "ImportUnused":false, "LocalShadow": false },
echo 	"lintErrors": true,
echo 	"globals": ["expect"]
echo }
) > .luaurc

(
echo @echo off
echo wally install
echo rojo sourcemap default.project.json --output sourcemap.json
echo wally-package-types --sourcemap sourcemap.json Packages/
) > scripts\wally.bat

call scripts/wally

powershell -Command "Write-Host 'DONE INITIALISING TEMPLATE' -ForegroundColor Green"
