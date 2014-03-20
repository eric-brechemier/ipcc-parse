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

echo 'Parse Authors'
ant -f ant/parse.xml -propertyfile config/authors.properties

echo 'Parsing Complete'
