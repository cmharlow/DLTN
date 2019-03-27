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

# Rhodes and Crossroads to Freedom
testValidityOfSternberg() {
    ${SAXON} ${SAMPLEDATA}/Rhodes/sternberg.xml ${STYLESHEETS}/rhodes_sternberg_xoai_to_mods.xsl 2>&1 2>/dev/null 1>${TESTFILE}
    STERNBERG=$(xmllint --noout --schema ${DLTNMODS} ${TESTFILE} 2>&1 1>/dev/null | cat)
    assertEquals "${STERNBERG}" "${TESTFILE} validates"
}

testValidityofFarnsworth() {
    ${SAXON} ${SAMPLEDATA}/Rhodes/Farnsworth.xml ${STYLESHEETS}/rhodes_dspace_xoai_to_mods_farnsworth.xsl 2>&1 2>/dev/null 1>${TESTFILE}
    RESPONSE=$(xmllint --noout --schema ${DLTNMODS} ${TESTFILE} 2>&1 1>/dev/null | cat)
    assertEquals "${RESPONSE}" "${TESTFILE} validates"
}

testValidityOfCrossroadsXOAItoMODS() {
    for filename in ${SAMPLEDATA}/Crossroads_xoai_default/*.xml; do
        ${SAXON} ${filename} ${STYLESHEETS}/rhodes_dspace_xoai_to_mods.xsl 2>&1 2>/dev/null 1>${TESTFILE}
        RESPONSE=$(xmllint --noout --schema ${DLTNMODS} ${TESTFILE} 2>&1 1>/dev/null | cat)
        assertEquals "${RESPONSE}" "${TESTFILE} validates"
    done
}

# Country Music Hall of Fame Tests
testValidityOfCountryMusicHallofFame() {
    ${SAXON} ${SAMPLEDATA}/Country/countryqdc.xml ${STYLESHEETS}/countryqdctomods.xsl 2>&1 2>/dev/null 1>${TESTFILE}
    RESPONSE=$(xmllint --noout --schema ${DLTNMODS} ${TESTFILE} 2>&1 1>/dev/null | cat)
    assertEquals "${RESPONSE}" "${TESTFILE} validates"
}

# TSLA Tests

testValidityOfTSLAqdctoMODS() {
    TSLA="test_data/tsla_qdc.txt"
    cat $TSLA | while read line; do
        OAIPMH=$(curl "https://dpla.lib.utk.edu/repox/OAIHandler?verb=ListRecords&metadataPrefix=oai_qdc&set=$line" | cat)
        ${SAXON} ${OAIPMH} ${STYLESHEETS}/tslaqdctomods.xsl 2>&1 2>/dev/null 1>${TESTFILE}
        RESPONSE=$(xmllint --noout --schema ${DLTNMODS} ${TESTFILE} 2>&1 1>/dev/null | cat)
        assertEquals "${RESPONSE}" "${TESTFILE} validates"
    done
}

# UTC Tests
testValidityOfUTCQDCtoMODS() {
    for filename in ${SAMPLEDATA}/UTC/qdc/*.xml; do
        ${SAXON} ${filename} ${STYLESHEETS}/utcqdctomods.xsl 2>&1 2>/dev/null 1>${TESTFILE}
        RESPONSE=$(xmllint --noout --schema ${DLTNMODS} ${TESTFILE} 2>&1 1>/dev/null | cat)
        assertEquals "${RESPONSE}" "${TESTFILE} validates"
    done
}

. shunit2