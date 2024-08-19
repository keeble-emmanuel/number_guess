#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=games --tuples-only -c"

RANDOM_NUMBER=$(( RANDOM % 1000 + 1))

echo "Enter your username:"
read NAME

GET_NAME=$($PSQL "SELECT name FROM game WHERE name = '$NAME'")
if [[ -z $GET_NAME ]]
then
  echo "Welcome, $NAME! It looks like this is your first time here."
else
  GET_HIGH=$($PSQL "SELECT MIN(score) FROM game WHERE name = '$NAME'")
  HIGH_FORMT=$(echo $GET_HIGH | sed 's/ //g')
  GET_PLAYED=$($PSQL "SELECT COUNT(name) FROM game WHERE name = '$NAME'")
  PLAYED_FORMT=$(echo $GET_PLAYED | sed 's/ //g')
  NAME_FORMT=$(echo $GET_NAME | sed 's/ //g')
  echo "Welcome back, $NAME_FORMT! You have played $PLAYED_FORMT games, and your best game took $HIGH_FORMT guesses."
fi

echo "Guess the secret number between 1 and 1000:"
read GUESS
echo $RANDOM_NUMBER

COUNT=1
while [[ $RANDOM_NUMBER -ne $GUESS ]];
do
  if [[ $GUESS =~ ^[0-9]+$ ]];
    then
      if [[ $RANDOM_NUMBER -gt $GUESS ]];
        then
          echo "It's higher than that, guess again:"
      elif [[ $RANDOM_NUMBER -lt $GUESS ]];
        then
          echo "It's lower than that, guess again:"
        fi
    else
      echo "That is not an integer, guess again:"
    fi

  ((COUNT ++))
  read GUESS
done
if [[ $RANDOM_NUMBER -eq $GUESS ]];
then
  echo "You guessed it in $COUNT tries. The secret number was $RANDOM_NUMBER. Nice job!"
  INSERT_INFO=$($PSQL "INSERT INTO game(name, score) VALUES('$NAME', $COUNT)")
fi