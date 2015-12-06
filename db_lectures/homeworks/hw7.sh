#!/bin/sh
mysql --user=itmo -pctd --verbose ctd < batch.sql
mysql --user=itmo -pctd --verbose ctd < homework7.sql
