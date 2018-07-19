#!/usr/bin/env bash

git pull origin master --force
composer install
mysql db < db/schema.sql
mysql db < db/data.sql
