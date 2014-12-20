#!/bin/sh
## Makefile.sh for  in /home/veyrie_f/rendu/Piscine_C_J11/do-op
## 
## Made by fernand veyrier
## Login   <veyrie_f@epitech.net>
## 
## Started on  Mon Oct 20 13:05:25 2014 fernand veyrier
## Last update Sat Dec 20 13:32:16 2014 fernand veyrier
##

REVISION=1.5

function generate_makefile
{
    if [ "$2" = "y" ] ; then
	rm -f ./Makefile
	touch ./Makefile
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
    if [ ! -f ./include ]
    then
        mkdir include
    fi
    if [[ $2="y" ]]
    then
        echo "#ifndef MY_H_" > ./include/my.h
        echo "# define MY_H_" >> ./include/my.h
        echo >> ./include/my.h
	#grep -h "^#" *.c > ./to_del.txt
	#sort ./to_del.txt | uniq >> ./include/my.h #useless
	#rm ./to_del.txt
	echo >> ./include/my.h
        grep -h "^[void||int||char||double||float]" *.c | sed "s/$/;/g" >> ./include/my.h #ne gere pas proto multiligne
        echo >> ./include/my.h
        echo "#endif /* !MY_H_ */" >> ./include/my.h
    fi
}

if [ $# -eq 0 ]
then
    echo "Please enter your executable name, or -update to check for updates."
else if [[ $1 == "-update" ]] ; then
    echo "Checking for updates..."
    path=$(find ~/ -name "Makefile.sh")
    echo "Makefile .sh found at location : $path"
    mv $path ./
    res=$(wget https://raw.githubusercontent.com/FernandVEYRIER/Public/master/Makefile.sh)
    if [ $? -ne 0 ] ; then
        echo "Failed to read from repository, check internet connexion."
        mv ./Makefile.sh $path
    else
        echo "Your Maker is up to date version $REVISION !"
	mv ./Makefile.sh.1 $path
       	chmod 755 $path
        r m ./Makefile.sh
    fi
    exit 0
else
    echo "#####################################"
    echo "# Welcome to the Maker revision $REVISION #"
    echo "#           by veyrie_f             #"
    printf "#\e[31m DO NOT FORGET TO ADD YOUR HEADER \e[0m #\n"
    printf "#\e[31m AND STRUCTURES IN MY.H IF NEEDED \e[0m #\n"
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
