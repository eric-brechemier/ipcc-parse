#! /bin/sh
# Convert TSV data from ipcc-acquire and export to ipcc.projetmedea.fr
#
# Usage:
# parse.sh
#

# Configuration

# relative path to the output of IPCC Acquire project (TSV files)
inputFolder='../ipcc-acquire/output'

# relative path to the input of IPCC Tool project (JSONP files)
outputFolder='../../web/ipcc.projetmedea.fr/data'

# change to the script's directory
cd $(dirname $0)

# create directories for generated configuration files
mkdir -p config

createConfig()
{
echo "Generate configuration file 'config/$1.properties'"
cat <<EOF > "config/$1.properties"
# relative path to input TSV data
input.file=$inputFolder/$1.tsv
input.file.type=tsv

# relative path for export of the JSONP script
export.jsonp=$outputFolder/$1.js

# start and end of wrapper code for JSONP output
jsonp.start=within("projetmedea.fr",function(publish){publish("$1",
jsonp.end=);});
EOF
}

parse()
{
  createConfig "$1"
  ant -f ant/parse.xml -propertyfile "config/$1.properties"
}

echo 'Parse Authors'
parse authors

echo 'Parse Total Contributions List'
parse total-contributions-list

echo 'Parse Total Contributions Categories'
parse total-contributions-categories

echo 'Parse Role List'
parse role-list

echo 'Parse Role Categories'
parse role-categories

echo 'Parse Working Group List'
parse working-group-list

echo 'Parse Working Group Categories'
parse working-group-categories

echo 'Parse Assessment Report List'
parse assessment-report-list

echo 'Parse Assessment Report Categories'
parse assessment-report-categories

echo 'Parse Years of Assessment Reports'
parse assessment-report-years

echo 'Parse Institution List'
parse institution-list

echo 'Parse Institution Categories'
parse institution-categories

echo 'Parse Institution Type List'
parse institution-type-list

echo 'Parse Institution Type Categories'
parse institution-type-categories

echo 'Parse Country List'
parse country-list

echo 'Parse Country Categories'
parse country-categories

echo 'Parse Country Group Categories'
parse country-group-categories

echo 'Parse Cumulated Working Group Categories'
parse cumulated-working-group-categories

echo 'Parse Cumulated Working Group in Assessment Report Categories'
parse cumulated-working-group-in-assessment-report-categories

echo 'Parse Cumulated Working Group in Country Group Categories'
parse cumulated-working-group-in-country-group-categories

echo 'Parse Cumulated Working Group in Institution Type Categories'
parse cumulated-working-group-in-institution-type-categories

echo 'Parse Cumulated Role in Assessment Report Categories'
parse cumulated-role-in-assessment-report-categories

echo 'Parse Cumulated Role in Country Group Categories'
parse cumulated-role-in-country-group-categories

echo 'Parsing Complete'
