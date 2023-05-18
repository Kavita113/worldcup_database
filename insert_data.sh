#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo -e "$($PSQL "TRUNCATE games,teams" )"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
    then
    #get team_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams  WHERE name='$WINNER'")

    #if not found
    if [[ -z $WINNER_ID ]]
     then

     #insert teams
     INSERT_WINNER_ID=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
     if [[ $INSERT_WINNER_ID == "INSERT 0 1" ]]
      then
      echo INSERTED INTO teams , $WINNER
      fi

      #get new team_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams  WHERE name='$WINNER'")
   fi
 fi

 #inserting into opponent
  if [[ $OPPONENT != "opponent" ]]
    then

     #get opponent_id
     OPPONENT_ID=$($PSQL "SELECT team_id FROM teams  WHERE name='$OPPONENT'") 
     #if not found
     if [[ -z $OPPONENT_ID ]]
        then
        GET_OPPONENT_ID=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $GET_OPPONENT_ID == "INSERT  0 1" ]]
          then
          echo INSERTED INTO opponent,$OPPONENT
        fi
        #get new opponent_id
         OPPONENT_ID=$($PSQL "SELECT team_id FROM teams  WHERE name='$OPPONENT'")
      fi
 fi

 if [[ $YEAR != "year" && $OPPONENT != "opponent" && $WINNER != "winner" ]]
    then
          INSERT_GAME_ID=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$YEAR','$ROUND','$WINNER_ID','$OPPONENT_ID','$WINNER_GOALS','$OPPONENT_GOALS')")
          if [[ $INSERT_GAME_ID == "INSERT 0 1" ]]
            then
               echo INSERTED INTO games
            
          fi
  fi
done
