#!/bin/bash
# Script to fetch element info from periodic_table database

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#If no argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# If input is a number (atomic_number)
if [[ $1 =~ ^[0-9]+$ ]]
then
  CONDITION="atomic_number=$1"

# If input is one capital letter or one capital + one lowercase (symbol)
elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
then
  CONDITION="symbol='$1'"

# Otherwise treat as name
else
  CONDITION="name='$1'"
fi

ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
FROM elements 
INNER JOIN properties USING(atomic_number) 
INNER JOIN types USING(type_id)
WHERE $CONDITION;")

# If no result found
if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi

IFS="|" read NUMBER NAME SYMBOL TYPE MASS MELT BOIL <<< "$ELEMENT"

echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."

