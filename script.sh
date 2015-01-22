#!/bin/bash
reset
if [ $# -eq 0 ]; then 
  echo "You need to specify in argument the name of the directory (without / at the end)"
  exit 1
fi

echo ""
echo "Testing the DTD...."

if xmllint --noout --dtdvalid src/gedcom.dtd $1/$1.xml; then
  echo "SUCCESS! DTD is OK."
else
  echo "ERROR: gedcom.dtd should be valid under the DTD!"
  exit 1
fi

echo ""
echo "Testing the Schema..."

if xmllint --schema src/gedcom.xsd --noout $1/$1.xml; then
  echo -n ""
  echo "SUCCESS! Schema is OK."
else
  echo "ERROR: gedcom.xsd should be valid under the XML schema!"
  exit 1
fi

echo ""
echo "Transformation to HTML..."

if xsltproc src/xml2html.xsl $1/$1.xml > $1/$1.html; then
  echo -n ""
  echo "SUCCESS! HTML is generated in $1/$1.html"
else
  echo "ERROR: xml2html.xsl should be valid"
  exit 1
fi
