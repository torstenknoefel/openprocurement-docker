#!/bin/bash
#su openp
#mkdir /home/openp
#cd home/openp/
git clone https://github.com/openprocurement/openprocurement.buildout.git
cd openprocurement.buildout
git checkout 2.4.19
cp buildout.cfg.example buildout.cfg
#chown -R openp.openp /home/openp/openprocurement.buildout/
python bootstrap.py
bin/buildout -N

