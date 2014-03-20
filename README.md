# IPCC Parse
Parse and convert data for IPCC tool from CSV to JSON

## Languages

* XSLT
* Ant
* Shell

## Included Software

* Saxon XSLT Processor

## Requirements

* Java
* Ant
* ipcc-acquire project at the same level
* 'giec' MySQL database (to generate TSV files in ipcc-acquire)
* ipcc.projetmedea.fr project at the same level

## Run

    # run test transformation (possibly customized in ant/user.properties)
    $ ant -f ant/parse.xml

    # convert output data from ipcc-acquire and export to ipcc.projetmedea.fr
    $ parse.sh

The input and output path for parse.sh are configured in separate property
files located in the folder 'config'.
