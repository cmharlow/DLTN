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

testValidityofFarnsworth() {
    ${SAXON} ${SAMPLEDATA}/Rhodes/Farnsworth.xml ${STYLESHEETS}/rhodes_dspace_xoai_to_mods_farnsworth.xsl 2>&1 2>/dev/null 1>${TESTFILE}
    STERNBERG=$(xmllint --noout --schema ${DLTNMODS} ${TESTFILE} 2>&1 1>/dev/null | cat)
    assertEquals "${STERNBERG}" "${TESTFILE} validates"
}

# This unit test expects all records in Sample_Data/Crossroads to use rhodes_dspace_xoai_to_mods.xsl
testValidityOfCrossroadsXOAItoMODS() {
    for filename in ${SAMPLEDATA}/Crossroads_xoai_default/*.xml; do
        ${SAXON} ${filename} ${STYLESHEETS}/rhodes_dspace_xoai_to_mods.xsl 2>&1 2>/dev/null 1>${TESTFILE}
        RESPONSE=$(xmllint --noout --schema ${DLTNMODS} ${TESTFILE} 2>&1 1>/dev/null | cat)
        assertEquals "${RESPONSE}" "${TESTFILE} validates"
    done
}

. shunit2