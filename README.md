# MTA_WaitTime
URPL 1620 Final Project about MTA Wait time by Route
Brian Scannell: Subway Upgrade Prioritization

Steps Taken in QGIS:
Base Borough Polygon Layer
Subway Routes
Pulled in Subway Route Line Layer.
Split each route into a separate layer. 
Used summary statistics to calculate length and wrote an expression to convert to miles.
Exported as CSV for R calculation.

Subway Zip Code
Pulled in NYC Zip Code Polygon Layer.
Joined with ASC 2023 Median Family Income Data.
Run Expression in Attribute Table to find mean income for overall route.
Selected by Attribute where Route Line intersected with Zip Code Polygon ro create Route Specific Zip Code Layers.
Dissolved Route Specific ZipCode into single polygon.

Steps Taken in R:
Read in two Wait-Time metric files.
Read in length by Zip Code from QGIS.
Ran simple regression with three variables to test significance.

Steps Taken in Datawrapper:
Created Chart comparing Rank of Routes with lowest reliability with MTA Priority Status (if prioritized in the Capital Plan).

Steps Taken in Powerpoint:
Created Image based “Superlatives” Table using Data from R and Subway Logos.

Steps Taken in Figma:
Cleaned Maps, Legends, Added Explanatory Descriptions.

All three CSVs needed to run the code have been included!

Route Line Data was pulled from 2016 NYU Data Repository: https://geo.nyu.edu/catalog/nyu-2451-34758
