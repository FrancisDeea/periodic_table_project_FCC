# Variables
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

GET_ELEMENT() {
  # Check if argument is passed into the funcion
  if [[ $1 ]]
  then
    # Check if argument is a <atomic_number>
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      # Check if <atomic_number> exists in database
      NAME_RESULT=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
      # if not found
      if [[ -z $NAME_RESULT ]]
      then
        echo "I could not find that element in the database."
      else
        # Set variables
        TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$1")
        AM=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1")
        MPC=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1")
        BPC=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1")
        SYM=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
        echo "The element with atomic number $1 is $NAME_RESULT ($SYM). It's a $TYPE, with a mass of $AM amu. $NAME_RESULT has a melting point of $MPC celsius and a boiling point of $BPC celsius."
      fi
    # Check if argument is a <symbol>
    elif [[ $1 =~ ^[A-Z]$|^[A-Z][a-z]$ ]]
    then
      # Check if <symbol> exists in database
      NAME_RESULT=$($PSQL "SELECT name FROM elements WHERE symbol='$1'")
      # If not found
      if [[ -z $NAME_RESULT ]]
      then
        echo "I could not find that element in the database."
      else
        # Set variables
        AN=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
        TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$AN")
        AM=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$AN")
        MPC=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$AN")
        BPC=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$AN")
        echo "The element with atomic number $AN is $NAME_RESULT ($1). It's a $TYPE, with a mass of $AM amu. $NAME_RESULT has a melting point of $MPC celsius and a boiling point of $BPC celsius."
      fi
    else
      # Check if <name> exists in database
      AN=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
      # If not found
      if [[ -z $AN ]]
      then
        echo "I could not find that element in the database."
      else
      # Set variables
        TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$AN")
        AM=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$AN")
        MPC=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$AN")
        BPC=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$AN")
        SYM=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$AN")
        echo "The element with atomic number $AN is $1 ($SYM). It's a $TYPE, with a mass of $AM amu. $1 has a melting point of $MPC celsius and a boiling point of $BPC celsius."
      fi
    fi

  else
    echo "Please provide an element as an argument."
  fi
}

GET_ELEMENT $1