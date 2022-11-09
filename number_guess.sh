#!/bin/bash

PSQL="psql --dbname=number_guess -t --no-align -c"

echo -e "\n~~~ Number Guessing Game ~~~\n"

RANDOM_NUMBER=$(( $RANDOM % 1000 + 1 ))

echo "Enter your username:"
read USERNAME

USERNAME_QUERY_RESULT=$($PSQL "SELECT username FROM users WHERE username='$USERNAME';")

if [[ -z $USERNAME_QUERY_RESULT ]]
then
  echo something # added to make the conditional work
else
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME';")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME';")

  if [[ -z $BEST_GAME ]]
  then
    if [[ $GAMES_PLAYED == 0 ]]
    then
      echo "Welcome back $USERNAME. You haven't played any games yet."
    else
      echo "Welcome back $USERNAME. You have played $GAMES_PLAYED games."
    fi
  else
    echo "Welcome back $USERNAME. You have played $GAMES_PLAYED games, and your best game \
    took $BEST_GAME guesses."
  fi
fi
