#!/bin/bash

PSQL="psql --dbname=number_guess -t --no-align -c"

echo -e "\n~~~ Number Guessing Game ~~~\n"

RANDOM_NUMBER=$(( $RANDOM % 1000 + 1 ))

echo "Enter your username:"
read USERNAME

USERNAME_QUERY_RESULT=$($PSQL "SELECT username FROM users WHERE username='$USERNAME';")

if [[ -z $USERNAME_QUERY_RESULT ]]
then
  INSERT_RESULT=$($PSQL "INSERT INTO users(username, games_played) VALUES('$USERNAME', 0);")
  echo "Welcome, $USERNAME! It looks like this is your first time here." 
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

GUESS_COUNT=0

echo -e "\nGuess the secret number between 1 and 1000:"
read GUESS
(( GUESS_COUNT++ ))

if [[ ! -z $GUESS ]]
then
  GAMES_PLAYED_UPDATE_RESULT=$($PSQL "UPDATE users SET games_played = games_played + 1 WHERE username='$USERNAME';")
fi

until [[ $RANDOM_NUMBER == $GUESS ]]
do
  if [[ $GUESS =~ ^[0-9]+$ ]]
  then
    if [[ $GUESS -lt $RANDOM_NUMBER ]]
    then
      echo "It's higher than that, guess again:"
      read GUESS
      (( GUESS_COUNT++ ))
    else
      echo "It's lower than that, guess again:"
      read GUESS
      (( GUESS_COUNT++ ))
    fi
  else
    echo "That is not an integer, guess again:"
    read GUESS
    (( GUESS_COUNT++ ))
  fi
done

if [[ $GUESS_COUNT == 1 ]]
then
  echo -e "\nYOU GUESSED IT WITH ONLY ONE TRY!!!\nThe secret number was $RANDOM_NUMBER. AMAZING!!!"
else
  echo -e "\nYou guessed it in $GUESS_COUNT tries.\nThe secret number was $RANDOM_NUMBER. Nice job!"
fi

if [[ -z $BEST_GAME ]]
then
  UPDATE_BEST_GAME=$($PSQL "UPDATE users SET best_game=$GUESS_COUNT WHERE username='$USERNAME';")
elif [[ $BEST_GAME -gt $GUESS_COUNT ]]
then
  UPDATE_BEST_GAME=$($PSQL "UPDATE users SET best_game=$GUESS_COUNT WHERE username='$USERNAME';")
fi
