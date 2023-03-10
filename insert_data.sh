#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE teams, games")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
	if [[ $OPPONENT != "opponent" && $WINNER != "winner" ]]
	then
		GET_OPPONENT=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
		GET_WINNER=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")

		if [[ $GET_OPPONENT != $OPPONENT && $GET_OPPONENT != $WINNER ]]
		then
			#insert opponent
			INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
		fi
		echo "Inserted: $INSERT_OPPONENT in teams"
		
		if [[ $GET_WINNER != $WINNER && $GET_WINNER != $OPPONENT ]]
		then
			#insert winner
			INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
		fi
		echo "Inserted: $INSERT_WINNER in teams"

		#get the opponent id
		OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

		#get winner_id
		WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
		
		INSERT_INTO_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

		echo "Inserted: Into games"

	fi
done

