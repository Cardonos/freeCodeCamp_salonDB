#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align  -c"

echo -e "\nWelcome to the Salon\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
  echo $1
  else
  echo -e "\nWhat service do you want?\n"
  fi
  echo $($PSQL "SELECT * FROM services;") | while IFS=" " read SERVICE_3 SERVICE_1 SERVICE_2
  do
  echo $SERVICE_1 | while IFS="|" read ID NAME
  do
  echo -e "\n$ID) $NAME"
  done
  echo $SERVICE_2 | while IFS="|" read ID NAME
  do
  echo -e "\n$ID) $NAME"
  done
    echo $SERVICE_3 | while IFS="|" read ID NAME
  do
  echo -e "\n$ID) $NAME"
  done
  done
  echo -e "\nEnter the number you want to book\n"
  read SERVICE_ID_SELECTED
  SERVICE_NAME_SELECTED="$($PSQL"SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED ;")"
  #if incorrect
  if [[ -z "$SERVICE_NAME_SELECTED" ]]
  then
    MAIN_MENU "Please select a correct ID"
    #send back
  else
    #call next func
    echo -e "\nYou want to book a $SERVICE_NAME_SELECTED"
    BOOKING
  fi
}

BOOKING(){
  #enter phone number
  echo -e "\nPlease enter your Phone Number:"
  read CUSTOMER_PHONE
  #if user doesnt exist
  CUSTOMER_NAME="$($PSQL"SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")"
  if [[ -z $CUSTOMER_NAME ]]
  then
  #create new user entry
  echo -e "\nPlease enter your name:"
  read CUSTOMER_NAME
  INSERT_CUSTOMER="$($PSQL"INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")"
  fi
  CUSTOMER_ID="$($PSQL"SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")"
  echo -e "\nWhat Time do you want to book?"
  read SERVICE_TIME
  RESULT_INSERT_TIME="$($PSQL"INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")"
  
  echo -e "\nI have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU

