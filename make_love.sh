#!/bin/bash

rm -f build/ouroborosjump.love build/ouroborosjump.exe build/ouroborosjump-src.zip
zip /tmp/ouroborosjump.zip `find . |grep -v .git|grep -v screencapture|grep -v build`
cp /tmp/ouroborosjump.zip build/ouroborosjump-src.zip
mv /tmp/ouroborosjump.zip build/ouroborosjump.love
cat build/love/love.exe build/ouroborosjump.love > build/ouroborosjump.exe

cd build
cp love/* .
rm love.exe

rm -rf ouroborosjump
mkdir -p ouroborosjump
mv *.exe *.dll *.txt ouroborosjump
rm -rf ouroborosjump.zip
zip ouroborosjump.zip ouroborosjump/*
rm -rf ouroborosjump
