@echo off
color 0a
cd ..
echo Installing dependencies...
echo This might take a few moments depending on your internet speed.
haxelib install hmm --quiet
haxelib run hmm install --quiet
echo Finished!
pause
