library(rvest)
library(dplyr)


urls_df <- read.csv("FerrisburghAddress.txt", header = FALSE, col.names = "url")

# Function to safely extract text, handling missing elements (unchanged)
safe_extract <- function(node) {
        text <- node %>% html_text()
        if (length(text) == 0) {
                return(NA_character_)
        } else {
                return(text)
        }
}

# Function to scrape data from a single URL
scrape_page <- function(url) {
        tryCatch({  # Handle potential errors during scraping
                html_content <- read_html(url)
                
                parcel <- html_content %>% html_nodes("table.camaDetailTable:nth-child(1) .camaLabel:contains('Parcel') + td") %>% safe_extract()
                owner <- html_content %>% html_nodes("table.camaDetailTable:nth-child(1) .camaLabel:contains('Owner') + td") %>% safe_extract()
                location <- html_content %>% html_nodes("table.camaDetailTable:nth-child(1) .camaLabel:contains('Location') + td") %>% safe_extract()
                building_sf <- html_content %>% html_nodes("table.camaDetailTable:nth-child(1) .camaLabel:contains('Building SF') + td") %>% safe_extract()
                year_built <- html_content %>% html_nodes("table.camaDetailTable:nth-child(1) .camaLabel:contains('Year Built') + td") %>% safe_extract()
                style <- html_content %>% html_nodes("table.camaDetailTable:nth-child(1) .camaLabel:contains('Style') + td") %>% safe_extract()
                
                # Return as a data frame (important!)
                return(data.frame(
                        Parcel = parcel,
                        Owner = owner,
                        Location = location,
                        Building_SF = building_sf,
                        Year_Built = year_built,
                        Style = style,
                        URL = url # Include the URL!
                ))
                
        }, error = function(e) {
                print(paste("Error scraping", url, ":", e$message))
                return(data.frame( # Return an empty df with URL on error
                        Parcel = NA_character_,
                        Owner = NA_character_,
                        Location = NA_character_,
                        Building_SF = NA_character_,
                        Year_Built = NA_character_,
                        Style = NA_character_,
                        URL = url
                ))
        })
}


# Iterate and scrape
all_data <- data.frame() # Initialize an empty data frame

for (i in 1:nrow(urls_df)) {
        current_url <- urls_df$url[i]
        scraped_data <- scrape_page(current_url)
        all_data <- bind_rows(all_data, scraped_data) # Efficiently combine rows
        print(paste("Scraped", current_url))
        Sys.sleep(1) # Be polite!
}

print(all_data)

# Optional: Write to CSV
write.csv(all_data, "all_property_data.csv", row.names = FALSE)
