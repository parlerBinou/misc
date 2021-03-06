format_number <-
  function(number,
           in_bracket = NULL,
           in_bracket_percent = TRUE,
           locale = "en") {
    # add thousand separator (, for "en": 1,234; a space for "fr": 1 234)
    # and decimal point (. for "en": 1.23; , for "fr": 1,23) based on the locale
    # when in_bracket, an optional argument, is provided, it also formats it
    # and paste it after the 'number' in bracket.
    
    if (locale == "fr") {
      k_delim <- " "
      d_delim <- ","
    } else {
      k_delim <- ","
      d_delim <- "."
    }
    
    out <- prettyNum(
      number,
      big.mark = k_delim,
      decimal.mark = d_delim,
      scientific = FALSE
    )
    
    if (!is.null(in_bracket)) {
      formatted_in_bracket <- prettyNum(
        in_bracket,
        big.mark = k_delim,
        decimal.mark = d_delim,
        scientific = FALSE
      )
      if (in_bracket_percent) {
        formatted_in_bracket <- paste(formatted_in_bracket, "%", sep = " ")
      }
      
      out <- paste0(out, " (", formatted_in_bracket, ")")
    }
    
    return(out)
  }
