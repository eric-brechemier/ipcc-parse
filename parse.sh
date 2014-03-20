#! /bin/sh
# Convert TSV data from ipcc-acquire and export to ipcc.projetmedea.fr
#
# Usage:
# parse.sh
#
# Configuration:
# through property files located in 'config' folder

# change to the script's directory
cd $(dirname $0)

parse()
{
  ant -f ant/parse.xml -propertyfile "config/$1.properties"
}

echo 'Parse Authors'
parse authors

echo 'Parse Working Group Categories'
parse working-group-categories

echo 'Parsing Complete'
