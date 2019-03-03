#!/bin/bash

## Add Global Variables
DLTNMODS="testSchemas/DLTN_oai_mods.xsd"
SAMPLEDATA="../Sample_Data"
STYLESHEETS="../XSLT"
TESTFILE="../working_directory/test.xml"
SAXON="java -jar ../working_directory/saxon-8.7.jar"


testJavaInstalled() {
    assertNotNull $(which java)
}

testValidityOfSternberg() {
    ${SAXON} ${SAMPLEDATA}/Rhodes/sternberg.xml ${STYLESHEETS}/rhodes_sternberg_xoai_to_mods.xsl 2>&1 2>/dev/null 1>${TESTFILE}
    STERNBERG=$(xmllint --noout --schema ${DLTNMODS} ${TESTFILE} 2>&1 1>/dev/null | cat)
    assertEquals "${STERNBERG}" "${TESTFILE} validates"
}

. shunit2