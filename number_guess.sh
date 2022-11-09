#!/bin/bash

PSQL="psql --dbname=number_guess -t --no-align -c"

RANDOM_NUMBER=$(( $RANDOM % 1000 + 1 ))
