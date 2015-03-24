#DPLA Metadata, Tech, and Content Information form
As filled out for the DLTN

##CONTACT INFORMATION
1) What is the name of your Hub as you wish it to appear in the DPLA metadata, on the website, and in publicity and marketing? *
Digital Library of Tennessee

2) TECHNICAL CONTACT *
Please provide the name, title, email address, and phone number for the person(s) responsible for maintaining the repository and the data feed from which DPLA will harvest your metadata.
 Mark Baggett
 
3) METADATA CONTACT *
Please provide the name, title, email address, and phone number for the person(s) responsible for managing and performing updates and remediation to your metadata.
 Christina Harlow, Cataloging & Metadata Librarian, charlow@utk.edu, 865-974-0029
 
4) LEAD CONTACT *
Please provide the name, title, email address, and phone number of the individual with administrative responsibilities for the Hub.
Holly Mercer
 
##COLLECTION INFORMATION
5) How many records (exactly, if possible) should we expect in our initial harvest? And, at what rate of change do you anticipate this number grow? *

 
6) At this time, DPLA limits the type of content that can be harvested. Please confirm that you will *not* be sharing any of the following items. *
Check those that you will *not* be sharing. If any box is unchecked, we will discuss with you options for blacklisting that content.
 - Records that do not resolve to digital objects
 - Items at the page level (e.g., newspaper and book pages)
 - Restricted content (e.g., firewall, paywall, IP restricted)
 - Finding aids/EADs
 - IR content
 
7) Please provide a list of the three to five collections (and links to them on your site, if possible) that you would like us to highlight in our initial publicity and marketing. *
Holly is doing this.
 
METADATA INFORMATION
8) In what metadata standard will you share your data with DPLA? *
OAI-MODS
 
9) Are there additional metadata standards that your data could be harvested in? *
OAI-DC
 
10) Provide links to any documentation about your metadata or repository that will assist DPLA staff in understanding the technologies you use. *
https://github.com/cmh2166/DLTN/
 
11) Please review the DPLA crosswalks so you'll know how we will be mapping your metadata fields: 
https://github.com/cmh2166/DLTN/blob/master/Documentation/DLTN_MAP_MODS.csv
 
12) Are elements (such as publisher and date) applied consistently across all of your sets/collections? *
Yes. For two given examples, publisher is physical object publisher, digitizing instituion is in recordSource element. Date has date text (free text, dateCreation without attribute keyDate) and key date (free text, dateCreation with attribute keyDate). Key date will always be EDTF, thus including ranges and date qualifiers in one element.
 
13) Do you describe your place values, in part or in whole, with coordinates and/or bounding boxes? Please explain how those values are expressed and provide examples, even if these values appear in only some of your records. *
In subject geographic, there are a few coordinates. They will appear in
<subject><geographic><cartographics><coordinates>, will only represent approximate points (no bounding boxes), and use decimal degrees followed by N/S, E/W. Example:
   <subject>
      <geographic authority="naf"
                  valueURI="http://id.loc.gov/authorities/names/n81139865">Rhea County (Tenn.)</geographic>
      <cartographics>
         <coordinates>35.63334N, 84.93333W</coordinates>
      </cartographics>
   </subject>

14) Do you use controlled vocabularies for some of your fields? *
Please provide the element in which the vocabulary is used, the name of the vocabulary, and how you indicate it. For example, Yes, see our MAP documentation for recommended vocabularies. Any vocabularies reconciled against will be captured in the element's authority attribute following MODS authority codes. Any URIs for the element within that vocabulary will also be captured in an element's valueURI attribute.
 
15) Please estimate the percentage of your collection that is marked Public Domain or contains a Creative Commons license. *
(e.g., Public domain, 10%; Creative Commons, 25%)
Based off of dates: 

REPOSITORY TECHNOLOGY INFORMATION
16) What repository system do you use for your digital objects? *

 
17) What type of data source do you employ? *

 
18) Provide the primary link to your data feed that DPLA will use to harvest your content. *
 
19) How will links to your thumbnails be provided? *
<location><url access="preview">
 
20) If you are using OAI-PMH, what is the metadata prefix we should use? *
oai_mods
 
21) If you are using OAI-PMH, are your collections divided into sets? *
  Yes, we use sets, and sets should be physical collection names (or derived from such).
  
22) If you are using OAI-PMH, are there sets that need to be blacklisted from the initial harvest? *
No.
 
23) What else do we need to know to harvest your data successfully?
 
