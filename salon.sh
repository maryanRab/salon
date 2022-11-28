#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU ()
{
  SERVICES=$($PSQL "select service_id,name from services")
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  echo -e "\nChoose service"
  read SERVICE_ID_SELECTED
  SELECTED_SERVICE_NAME=$($PSQL "select name from services WHERE service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SELECTED_SERVICE_NAME ]]
  then
    MAIN_MENU
  else
      echo -e "\nEnter phone number"
      read CUSTOMER_PHONE
      PHONE_NUMBER_ID=$($PSQL "select customer_id from customers WHERE phone='$CUSTOMER_PHONE'")
      if [[ -z $PHONE_NUMBER_ID ]]
      then
        echo -e "\nEnter name"
        read CUSTOMER_NAME
        R=$($PSQL "insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
      fi

      echo -e "\nEnter time"
      read SERVICE_TIME

      CUSTOMER_ID=$($PSQL "select customer_id from customers WHERE phone='$CUSTOMER_PHONE'")
      CUSTOMER_NAME=$($PSQL "select name from customers WHERE phone='$CUSTOMER_PHONE'")
      R=$($PSQL "insert into appointments(time,customer_id,service_id) values('$SERVICE_TIME',$CUSTOMER_ID,$SERVICE_ID_SELECTED)")
      echo "I have put you down for a$SELECTED_SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
  fi
}

MAIN_MENU
