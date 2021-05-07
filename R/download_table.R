library(tidyverse)

download_data <-
  function(table_number,
           coord_names,
           coord_prefix = "dim",
           file_name = NULL,
           RDS = TRUE) {
    # download an entire table from StatCan website and process it
    # All tables contain COORDINATE, indicating dimension structure.
    # To know the specific structure of the table's COORDINATE,
    # download its metadata.
    
    # by design, the first dimension of COORDINATE is GEO.
    # DON'T need to include the dimension. GEO will be augmented inside of
    # this function.
    coord_names_with_geo <- c("geo", coord_names)
    ind_coord <- paste0(coord_prefix, "_", coord_names_with_geo)
    
    temp <- tempfile()
    url <-
      paste0("https://www150.statcan.gc.ca/n1/tbl/csv/",
             table_number,
             "-eng.zip",
             sep = "")
    download.file(url, temp, mode = "wb")
    
    orig <- unz(temp, paste(table_number, ".csv", sep = "")) %>%
      read_csv(
        col_types = cols_only(
          REF_DATE = col_integer(),
          COORDINATE = col_character(),
          VALUE = col_number(),
          STATUS = col_character(),
          SYMBOL = col_character()
        )
      ) %>%
      filter(COORDINATE != "")
    unlink(temp)
    
    # split the COORDINATE into separate variables
    df <- orig %>%
      separate(col = COORDINATE, into = ind_coord)
    df[, ind_coord] <- sapply(df[, ind_coord], as.integer)
    
    # when file_name is provided, saves the output data.frame
    if (!is.null(file_name)) {
      # if RDS is TRUE (default), save it in RDS format (R native binary format)
      # https://csgillespie.github.io/efficientR/input-output.html#binary-file-formats
      if (RDS) {
        saveRDS(df, file = paste0(file_name, ".Rds"))
      } else {
        # otherwise, save it as a CSV file.
        write_csv(df, file = paste0(file_name, ".csv"))
      }
    }
    
    return(df)
  }


# Example: downloading Table 37-10-0204-01
# https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3710020401
# note that the last 01 is not included as the argument table_number.
#
# df <- download_data(
#   "37100204", c("trade", "mode", "time", "type", "to"))