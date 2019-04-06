# Make a directory in assets for a post

FILE=$1
if test -e "../assets/${FILE%.md}"
then
    echo "../assets/${FILE%.md}" already exists!
elif test -e $1
then
    mkdir "../assets/${FILE%.md}"
    echo Successfully make directory ../assets/${FILE%.md}!
else
    echo No such file $FILE
fi
