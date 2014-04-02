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
mkdir config

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

echo 'Parse Working Group Categories'
parse working-group-categories

echo 'Parse Working Group in Assessment Report Cateogies'
parse working-group-in-assessment-report-categories

echo 'Parsing Complete'
