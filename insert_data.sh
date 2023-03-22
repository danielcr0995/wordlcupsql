#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPP0NENT_GOALS
do
# skip first line
  if [[ $YEAR != 'year' ]]
  then
  # get team id
    WINNER_TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    OPPONENT_TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
# if not found
    if [[ -z $WINNER_TEAM_ID ]]
    then
    # save team on teams table
      # echo $WINNER
      INSERT_WINNER_TEAM=$($PSQL "insert into teams(name) values('$WINNER')")
      if [[ $INSERT_WINNER_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi 
      
      WINNER_TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    fi
    if [[ -z $OPPONENT_TEAM_ID ]]
    then
    # save team on teams table
      # echo $OPPONENT
      INSERT_OPPONENT_TEAM=$($PSQL "insert into teams(name) values('$OPPONENT')")
      if [[ $INSERT_OPPONENT_TEAM == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi 
      OPPONENT_TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    fi
    # echo $OPPONENT_TEAM_ID $WINNER_TEAM_ID

    # save game in games table
    # INSERT_GAMES=$($PSQL "insert into games(year, round, winner_id, oppenent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPP0NENT_GOALS)")
    # echo $YEAR $ROUND $WINNER_TEAM_ID $OPPONENT_TEAM_ID $WINNER_GOALS $OPP0NENT_GOALS
    
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPP0NENT_GOALS
do
# skip first line
  if [[ $YEAR != 'year' ]]
  then
  # get team id
    WINNER_TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    OPPONENT_TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")    

    # save game in games table
    INSERT_GAME=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPP0NENT_GOALS)")
    echo $YEAR $ROUND $WINNER_TEAM_ID $OPPONENT_TEAM_ID $WINNER_GOALS $OPP0NENT_GOALS
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
      then
        echo Inserted into games, the $ROUND between $WINNER and $OPPONENT
      fi
  fi
done


# if found


