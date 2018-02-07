#!/usr/bin/env python

import sys
import lxml.etree as etree

parser = etree.XMLParser(remove_blank_text=True)
doc = etree.parse(sys.argv[1], parser)

for elem in doc.iter():
    if elem.text is not None:
        elem.text = elem.text.strip()

FILE = open(sys.argv[1],"w")
FILE.writelines(etree.tostring(doc, pretty_print=True))
FILE.close()
