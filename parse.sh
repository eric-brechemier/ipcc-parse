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

echo 'Parse Total Contributions'
parse total-contributions-categories

echo 'Parse Roles'
parse role-categories

echo 'Parse Working Group Categories'
parse working-group-categories

echo 'Parse Assessment Report Categories'
parse assessment-report-categories

echo 'Parse Institution Categories'
parse institution-categories

echo 'Parse Country Categories'
parse country-categories

echo 'Parse Cumulated Working Group Categories'
parse cumulated-working-group-categories

echo 'Parse Cumulated Working Group in Assessment Report Categories'
parse cumulated-working-group-in-assessment-report-categories

echo 'Parse Chapter in Working Group in Assessment Report Categories'
parse chapter-in-working-group-in-assessment-report-categories

echo 'Parse Country and Working Group Categories'
parse country-and-working-group-categories

echo 'Parse Role in Working Group Categories'
parse role-in-working-group-categories

echo 'Parse Discipline in Working Group Categories'
parse discipline-in-working-group-categories

echo 'Parse Type of Institution in Working Group Categories'
parse institution-type-in-working-group-categories

echo 'Parse Years of Assessment Reports'
parse assessment-report-years

echo 'Parsing Complete'
