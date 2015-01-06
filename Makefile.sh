#!/bin/bash
## Makefile.sh for  in /home/veyrie_f/
## 
## Made by fernand veyrier
## Login   <veyrie_f@epitech.net>
## 
## Started on  Mon Oct 20 13:05:25 2014 fernand veyrier
## Last update Tue Jan  6 14:42:53 2015 fernand veyrier
##

REVISION=2.0

function include_header
{
    login=$(whoami)
    #name=$(cat /etc/passwd | grep `whoami` | grep -o -E ":[[:alpha:]' ']+:/" | tr -d ':' | tr -d '/')
    name=$(cat /etc/passwd | grep `whoami` | cut -d ':' -f5)
    #Credits goes to agor_m...
    date=$(date | grep -o -E "^[[:alpha:]' ']+[[:digit:]]+[[:digit:]' ':]+")
    year=$(date | grep -o -E "[[:digit:]]+$")
    echo "/*" >> ./include/my.h
    echo "** Makefile for  in $PWD" >> ./include/my.h
    echo "**" >> ./include/my.h
    echo "** Made by $name" >> ./include/my.h
    echo "** Login   <$login@epitech.net>" >> ./include/my.h
    echo "**" >> ./include/my.h
    echo "** Started on  $date$year $name" >> ./include/my.h
    echo "** Last update $date$year $name" >> ./include/my.h
    echo "*/" >> ./include/my.h
    echo >> ./include/my.h
}

function makefile_header
{
    login=$(whoami)
    #name=$(cat /etc/passwd | grep `whoami` | grep -o -E ":[[:alpha:]' ']+:/" | tr -d ':' | tr -d '/')
    name=$(cat /etc/passwd | grep `whoami` | cut -d ':' -f5)
    #Here to...
    date=$(date | grep -o -E "^[[:alpha:]' ']+[[:digit:]]+[[:digit:]' ':]+")
    year=$(date | grep -o -E "[[:digit:]]+$")
    echo "##" >> Makefile
    echo "## Makefile for  in $PWD" >> Makefile 
    echo "##" >> Makefile
    echo "## Made by $name" >> Makefile
    echo "## Login   <$login@epitech.net>" >> Makefile
    echo "##" >> Makefile
    echo "## Started on  $date$year $name" >> Makefile
    echo "## Last update $date$year $name" >> Makefile
    echo "##" >> Makefile
    echo >> Makefile
}

function generate_makefile
{
    if [ "$2" = "y" ] ; then
	rm -f ./Makefile
	touch ./Makefile
	makefile_header
	echo "CC		= gcc" >> Makefile
	echo >> Makefile
	echo "RM		= rm -f" >> Makefile
	echo >> Makefile
	echo "NAME		= $1" >> Makefile
	echo >> Makefile
	echo -n "SRCS		= " >> Makefile
	find ./ -name "*.c" | sed -e "s/\.\//$/g" | tr -d "$" > to_del
	if [[ `cat to_del` == "" ]] ; then
	    printf "\e[33mWarning : no .c files seems to be here.\e[0m\n"
	fi
	while read line
	do
	    if ! [ -z "$lastline" ] ; then
		echo -n $lastline >> Makefile
		echo " \\" >> Makefile
		echo -n "  		  " >> Makefile
	    fi
	    lastline=$line
	done < to_del
	echo $lastline >> Makefile
	echo >> Makefile
	rm to_del
	echo "OBJS		= \$(SRCS:.c=.o)" >> Makefile
	echo >> Makefile
	echo "CFLAGS		= -I./include -Wall -Wextra -W" >> Makefile
	echo >> Makefile
	if [ -f ./lib/libmy.a ] ; then
	    echo "LIB		= -L./lib -lmy" >> Makefile
	    echo >> Makefile
	fi
	echo "\$(NAME):	\$(OBJS)" >> Makefile
	echo >> Makefile
	echo "		\$(CC) -o \$(NAME) \$(OBJS) \$(LIB)" >> Makefile
	echo >> Makefile
	echo "all:		\$(NAME)" >> Makefile
	echo >> Makefile
	echo "clean:" >> Makefile
	echo "		\$(RM) \$(OBJS)" >> Makefile
	echo >> Makefile
	echo "fclean:		clean" >> Makefile
	echo "		\$(RM) \$(NAME)" >> Makefile
	echo >> Makefile
	echo "re:		fclean all" >> Makefile
	echo >> Makefile
	echo ".PHONY:		all clean fclean re" >> Makefile
    fi
}

function create_files
{
    generate_makefile $1 $3
    if [[ ! -d ./include ]]
    then
        mkdir include
    fi
    if [[ $2="y" ]]
    then
	rm ./include/my.h
	include_header
        echo "#ifndef MY_H_" >> ./include/my.h
        echo "# define MY_H_" >> ./include/my.h
	ls -1 ./include/ | sed "s/^/#include \"/g" | sed "s/$/\"/g" | sed "s/#include \"my.h\"/$/g" | tr -d "$" > ./to_del.txt
	sort ./to_del.txt | uniq >> ./include/my.h
	if [[ `cat ./to_del.txt` != "" ]] ; then
	    echo >> ./include/my.h
	fi
	rm ./to_del.txt
	grep -zo -h -E "^[[:alnum:]_]+[[:space:]*]+[[:alnum:]_]+[[:space:]]*\\([][[:alnum:]' '_*,]*[,)]*(|[[:space:]]*[[:alnum:]_*,)]+)*" *.c | sed "s/)$/);/g" >> ./include/my.h
	if [[ -d ./lib ]] ; then
	    grep -h -E "^[[:alnum:]_]+[[:space:]*]+[[:alnum:]_]+[[:space:]]*\\(" ./lib/*.c | sed "s/$/;/g" >> ./include/my.h
	fi
        echo >> ./include/my.h
        echo "#endif /* !MY_H_ */" >> ./include/my.h
    fi
}

if [ $# -eq 0 ]
then
    echo "Please enter your executable name, or -update to check for updates."
else if [[ $1 == "-update" ]] ; then
    echo "Checking for updates..."
    path=$(echo -n `find ~/ -name "Makefile.sh" | sed "s/\/Makefile.sh$/$/g" | tr -d '$'`)
    echo "Makefile .sh found at location : $path"
    res=$(wget https://raw.githubusercontent.com/FernandVEYRIER/Public/master/Makefile.sh -P "$path/test/")
    if [ $? -ne 0 ] ; then
        echo "Failed to read from repository, something went wrong."
    else
        echo "Your Maker is up to date version $REVISION !"
	mv "$path/test/Makefile.sh" $path
       	chmod 755 "$path/Makefile.sh"
        rm -r "$path/test"
    fi
    exit 0
else
    echo "#####################################"
    echo "# Welcome to the Maker revision $REVISION #"
    echo "#           by veyrie_f             #"
    printf "#\e[31m         AND SO BEGINS A          \e[0m #\n"
    printf "#\e[31m      NEW AGE OF KNOWLEDGE        \e[0m #\n"
    echo "#####################################"
    response_my="y"
    response_make="y"
    if [ -f ./include/my.h ] ; then
        read -p "A my.h file already exists. Overwrite it ? [y/n] " response_my
    fi
    if [ -f ./Makefile ] ; then
        read -p "A Makefile already exists. Overwrite it ? [y/n] " response_make
    fi
    create_files $1 $response_my $response_make
    echo -n "Succesfully created $1"
    if [[ "${response_my:0:1}" == "y" ]] ; then
        echo -n " Makefile"
    fi
    if [[ "${response_make:0:1}" == "y" ]] ; then
        echo -n " and include."
    fi
    echo
fi
fi
