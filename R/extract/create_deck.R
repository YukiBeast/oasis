create_deck <- function(data, codebook, scales) {
  card_list <- list()
  
  for (i in seq_len(nrow(codebook))) {
    row <- codebook[i, ]
    item_code <- as.character(row$item)
    
    # Skip if the variable does not exist in the loaded data
    if (!any(grepl(item_code, names(data)))) next 
    
    card <- list(name = item_code, label = row$label)
    
    # 1. For MULTIPLE CHOICE items
    if (row$class == "multiple") {
      card$prefix <- paste0("^", item_code, "_")
      class(card) <- c("multiple_choice", "categorical")
      
      # 2. For SINGLE CHOICE items
    } else if (row$class == "single") {
      
      if (!is.na(row$scale) && row$scale %in% names(scales)) {
        # CASE 1: Ordinal Scale (e.g., freq, intens)
        card$levels <- scales[[row$scale]]
        class(card) <- c("ordinal", "single_choice")
        
      } else if (!is.na(row$scale) && row$scale == "categorical") {
        # CASE 2: Categorical (e.g., Geschlecht / Gender)
        class(card) <- c("single_choice", "categorical")
        
      } else if (!is.na(row$scale) && (row$scale == "numerical" || row$scale == "numeric")) {
        # CASE 3: Numeric (e.g., Alter / Age)
        
        if (is.na(row$breaks)) {
          # Pure continuous variable (no breaks provided)
          class(card) <- c("numeric", "single_choice")
          
        } else {
          # Binned variable (breaks provided)
          # 1. Remove any blank spaces from the string (e.g., "59, 69" -> "59,69")
          breaks_clean <- gsub(" ", "", as.character(row$breaks))
          
          # 2. Split the string and convert it into a numeric vector
          card$breaks <- as.numeric(strsplit(breaks_clean, ",")[[1]])
          
          # 3. Assign the ordinal class so it behaves like standard single choice
          class(card) <- c("ordinal", "single_choice")
        }
      }
    }
    
    # Save the card to the deck
    card_list[[item_code]] <- card
  }
  
  return(card_list)
}
