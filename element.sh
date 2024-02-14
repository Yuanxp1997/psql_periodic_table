#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

if [[ -z $1 ]]; then
echo "Please provide an element as an argument."
else
  QUERY_RESULT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name = '$1'")
  if [[ -z $QUERY_RESULT ]]; then
    QUERY_RESULT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol = '$1'")
    if [[ -z $QUERY_RESULT ]]; then
      if [[ $1 =~ ^[0-9]+$ ]]; then
        QUERY_RESULT=$($PSQL "SELECT * FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number = '$1'")
      fi
    fi
  fi
  if [[ -z $QUERY_RESULT ]]; then
    echo "I could not find that element in the database."
  else
    echo $QUERY_RESULT | while read TYPE_ID BAR ATOM_NUM BAR SYMBOL BAR NAME BAR MASS BAR MELT BAR BOIL BAR TYPE; do
    echo "The element with atomic number $ATOM_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
fi