#!/usr/bin/env bash

for version in 1.14.9 1.15.8; do
  tfenv install ${version}
done

tfenv use 1.15.8
