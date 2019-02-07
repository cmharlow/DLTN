# DLTN XSLT and Repox Config


## About Sample Data

The sample data here is useful for testing transformation modifications outside of Repox.

## About XSLT

All XSL transformations currently used by the Digital Library of Tennessee are stored here.  For more information about
writing new XSL transformations, please review our [XSL style guide](https://dltn-technical-docs.readthedocs.io/en/latest/style/xsl.html).

## About Repox Config

This section includes configuration files with all incoming metadata schemas currently supported by the Digital Library
of Tennessee.

## Documentation

For more information, check out our [technical docs](https://dltn-technical-docs.readthedocs.io/en/latest/).

```
|-- repox_config
    |-- metadataSchemas.xml
|-- Sample_Data
    |-- provider_name_1
        |-- sample_record_1.xml
        |-- sample_record_2.xml
    |-- provider_name_2
        |-- sample_record_1.xml
        |-- sample_record_2.xml
|-- XSLT
    |-- catalogs
        |-- provider1_catalog.xsl
    |-- provider1dctomods.xsl
    |-- provider2qdctomods.xsl

```

## Helpful Resources

 - DPLA MAP v.4: http://dp.la/info/wp-content/uploads/2015/03/MAPv4.pdf
 - DPLA MAP v.4 - Existing Hubs Mappings: https://docs.google.com/spreadsheets/d/1BzZvDOf4fgas3TD21xF40lu2pk2XW0k2pTGJKIt6438/edit#gid=102934983
 - MODS 3.5 Elements Guidelines: http://www.loc.gov/standards/mods/userguide
