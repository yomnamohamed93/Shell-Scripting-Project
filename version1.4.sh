

#!/bin/bash

# -------------------create database-----------------------

function createDB () {

  if [ -d "$1" ]; then
    echo "database already exists";
  else
  mkdir $1;
      fi
}

#-------------------------use database------------------------------

function useDB () {

  if [ -d "$1" ]; then
    cd $1;
  else
    echo "database not exists";
    break
      fi

}

#--------------------------- createTable----------------------------

function createTable () {
  #
  PS3='choose datatype: '
  touch $1
  echo "enter number of columns: "
  read colNum;
  for (( i = 0; i < colNum; i++ )); do

    select colType in int string
    do
      case $colType in
      int)

        if [[ i -eq $colNum-1 ]]; then
          printf "int\n" >> $1
        else
          printf "int:" >> $1
        fi
        break
      ;;
      string)
          if [[ i -eq $colNum-1 ]]; then
            printf "str\n" >> $1
          else
            printf "str:" >> $1
          fi
          break
      ;;
      *) print $REPLY is not one of the choices.
      ;;
      esac
    done
  done
  for (( i = 0; i < colNum; i++ )); do
    echo "enter name of columns: "
    read colName;
    if [[ i -eq $colNum-1 ]]; then
      printf "$colName\n" >> $1
    else
      printf "$colName:" >> $1
    fi

  done

}


#---------------------insert data into table----------------------------------

function insert () {
   tableName=$1
  #array of fieldnames
    headers=($(awk -F: '{if(NR==2){for(i=1;i<=NF;i++){print $i}}}' $tableName))
    colTypes=($(awk -F: '{if(NR==2){for(i=1;i<=NF;i++){print $i}}}' $tableName))
    #number of fields
    NOF=$(awk -F: '{if(NR==2){print NF}}' $tableName)
     for (( i = 0; i <${#headers[@]} ; i++ )); do
    echo "enter:" ${headers[i]}
    read val
    if [[ i -eq $NOF-1 ]]; then
#       case "$val" in
#         +([[:alnum:]])   ) echo "string";;
#         +([0-9]) ) echo "Digit";;
#
#   * ) echo "Nothing";;
# esac
      printf  "$val\n" >> $tableName
    else
      printf  "$val:" >> $tableName
    fi
    done
    }

#-------------------------SelectByID---------------
function selectByColName() {
  #statements
  colName=$1
  tableName=$2

  fieldNum=$(awk -F: '{if(NR==2){for(i=1;i<=NF;i++){if($i=="'$colName'") print i}}}' $tableName)
        printf "\n"
       awk -v tmp="$fieldNum" -F: '{if(FNR>=2)print $tmp}' $tableName;

}
#---------------SelectWhere-----------------------------------

function selectWhere() {

  colName=$1
  tableName=$2
  echo "enter value: "
  read val
  fieldNum=$(awk -F: '{if(NR==2){for(i=1;i<=NF;i++){if($i=="'$colName'") print i}}}' $tableName)
        printf "\n"
       awk -v tmp="$fieldNum" -F: '{if($tmp=='$val')print $0}' $tableName;
}
#------------------selectAll----------------------------------------

function selectAll () {
    tableName=$1
    printf "\n"
  awk -F: '{if(FNR>=2)print $0}' $tableName
}
#===========================drop_table================================
DropT()
{

  if [  -f "$1" ];then
    rm $filename;
    echo "table deleted";
  else
    echo "table not exist";
  fi
}
#========================delete_from-table============================
DeleteT()
{
  read -p "enter table name : " tablename;
  filename=$tablename
  if [  -f "$filename" ];then

      read -p "enter number of column you want to select " col;
      awk -F: '{print $'$col'}'  $filename
      read -p "enter the value " val;
      row=$(awk -F":" '$'$col' == '$val' { print NR }' $filename)

      v=''$row''d
      sed -i "$v" $filename;
      echo "column deleted successfully";

  else
    echo "table not exist";
  fi
}
#==============================update_table=============
UpdateT()
{
  read -p "enter table name : " tablename;
  filename=$tablename
  if [  -f "$filename" ];then

      # echo $(head -1 $filename)
      awk -F: '{if(NR==2){for(i=1;i<=NF;i++){print i,$i}}}' $filename
      read -p "enter the field number :" fieldnum
      printf "\n"
      # awk -F: '{if(FNR>=2)print $'$fieldnum'}' $filename
      read -p "enter the id to update its column:" idvalue;
     rnum=$(awk -F":" '$'$fieldnum'=='$idvalue' {print NR}' $filename)
     read -p "enter number of fields to update them:" fieldsNum;
     for (( i = 0; i < $fieldsNum; i++ ));
      do
      read -p "enter old field to update:" oldField;
       read -p "enter new field:" newField;
       var=''$rnum's/'$oldField'/'$newField'/g'
      sed -i -e $var $filename;

    done



  else
    echo "table not exist";
  fi


}
#========================rename_database==============================
renameDB()
{
      read -p "enter database name : " dbname;
      if [ -d "$dbname" ]; then
        read -p "enter  new database name : " newdbname;
          if [ ! -d "$newdbname" ];then
          mv $dbname $newdbname;
          else
            echo "database already exist choose another name plz";
          fi

          else
          echo " database not exist";
      fi

}
#==========================delete_database============================
deleteDB()
{
  read -p "enter database name : " ;
  rm -R $REPLY;

}

#------------------------------------------------------------
PS3='Select an option and press Enter: '
options=("create database" "use database" "delete database" "rename database")
select opt in "${options[@]}"
do
  case $opt in
        "create database")
          printf  "\nenter database name "
          read dbname
          createDB $dbname
          break
          ;;
        "use database")
          printf "\nchoose database name "
          read dbname
          useDB $dbname
          PS3='Select an option and press Enter: '
          options=("create table" "insert" "SelectByColName" "SelectWhere" "selectAll" "drop_table" "update_table" "delete_from_table")
          select opt in "${options[@]}"
          do
              case $opt in
                  "create table")
                  printf "\nenter table name "
                  read tableName
                  createTable $tableName
                  break
                    ;;
                    "insert")
                    printf "\nchoose table name "
                    read tableName
                    insert $tableName
                    break
                      ;;
                    "SelectByColName")
                    printf "\nchoose table name "
                    read tableName
                    echo "enter colName  "
                    read var
                    selectByColName $var $tableName
                      break
                        ;;
                    "SelectWhere")
                    printf "\nchoose table name "
                    read tableName
                    echo "enter colName  "
                    read var
                    selectWhere $var $tableName
                        break
                          ;;
                    "selectAll")
                    echo "enter table name "
                    read tableName
                    selectAll $var $tableName
                      break
                          ;;
                    "drop_table")
                    read -p "enter table name : " tablename;
                    filename=$tablename;
                    DropT $filename
                    break
                    ;;
                    "update_table")
                    UpdateT
                    break
                     ;;
                    "delete_from_table")
                    DeleteT
                    break
                    ;;

                  *) echo "invalid option"
                  break
                  ;;
            esac
          done
            break
          ;;
        "delete database")
      	deleteDB
       break
          ;;
        "rename database")
    	renameDB
          break
            ;;
        *) echo "invalid option";;
  esac
done
