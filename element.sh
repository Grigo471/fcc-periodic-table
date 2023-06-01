#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
RESULT() {
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $1")
  MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $1")
  BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $1")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $1")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
  echo "The element with atomic number $1 is $3 ($2). It's a $TYPE, with a mass of $MASS amu. $3 has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
}
# if with argument
if [[ "$1" ]]
  then
    # if argument is a number
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $1")
      # if not found
      if [[ -z "$SYMBOL" ]]
      then
        echo I could not find that element in the database.
      else
        NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1")
        RESULT $1 $SYMBOL $NAME
      fi
    else
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1'")
      if [[ $SYMBOL ]]
      then
        NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$SYMBOL'")
        NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$SYMBOL'")
        RESULT $NUMBER $SYMBOL $NAME
      else 
        NAME=$($PSQL "SELECT name FROM elements WHERE name = '$1'")
        if [[ $NAME ]]
        then
          SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$1'")
          NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$SYMBOL'")
          RESULT $NUMBER $SYMBOL $NAME
        else
          echo I could not find that element in the database.
        fi
      fi
    fi
  else
    echo Please provide an element as an argument.
fi
