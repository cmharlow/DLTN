#!/bin/bash

DLTNMODS="testSchemas/DLTN_oai_mods.xsd"
SAMPLEDATA="../Sample_Data"
STYLESHEETS="../XSLT"
TESTFILE="../working_directory/test.xml"


testValidityOfSternberg() {
    saxon87 ${SAMPLEDATA}/Rhodes/sternberg.xml ${STYLESHEETS}/rhodes_sternberg_xoai_to_mods.xsl 2>&1 2>/dev/null 1>${TESTFILE}
    STERNBERG=$(xmllint --noout --schema ${DLTNMODS} ../delete/stern_example.xml 2>&1 1>/dev/null | cat)
    assertEquals "${STERNBERG}" "../delete/stern_example.xml validates"
}
. shunit2