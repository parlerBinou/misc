# Collection of R scripts

Simple R scripts that I wrote that might be reused.

* `get_annual_cpi.R`
    * Downloads annual CPI from Statistics Canada [Table: 18-10-0005-01](https://www150.statcan.gc.ca/t1/tbl1/en/cv.action?pid=1810000501)
    * Uses `getDataFromVectorsAndLatestNPeriods` method in Statistics Canada [Web Data Service](https://www.statcan.gc.ca/eng/developers/wds/user-guide)
    
* `download_table.R`
    * Downloads an entire table from Statistics Canada
    
* `format_number.R`
    * Format a number based on the locale (en / fr)
    * Add appropriate thousand separator and decimal point