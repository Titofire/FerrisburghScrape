library(rvest)
library(dplyr)

url <- "https://nemrc.info/web_data/vtferi/camadetailT.php?prop=09/01/13"
html_content <- read_html(url)

# Function to safely extract text, handling missing elements
safe_extract <- function(node) {
        text <- node %>% html_text()
        if (length(text) == 0) {
                return(NA_character_) # Return NA if element is not found
        } else {
                return(text)
        }
}

# Extract data using the safe_extract function
parcel <- html_content %>% html_nodes("table.camaDetailTable:nth-child(1) .camaLabel:contains('Parcel') + td") %>% safe_extract()
owner <- html_content %>% html_nodes("table.camaDetailTable:nth-child(1) .camaLabel:contains('Owner') + td") %>% safe_extract()
location <- html_content %>% html_nodes("table.camaDetailTable:nth-child(1) .camaLabel:contains('Location') + td") %>% safe_extract()
building_sf <- html_content %>% html_nodes("table.camaDetailTable:nth-child(1) .camaLabel:contains('Building SF') + td") %>% safe_extract()
year_built <- html_content %>% html_nodes("table.camaDetailTable:nth-child(1) .camaLabel:contains('Year Built') + td") %>% safe_extract()
style <- html_content %>% html_nodes("table.camaDetailTable:nth-child(1) .camaLabel:contains('Style') + td") %>% safe_extract()



# Create the data frame (using length of the longest vector as reference)
max_len <- max(length(parcel), length(owner), length(location), length(building_sf), length(year_built), length(style))

df <- data.frame(
        Parcel = rep(parcel, length.out = max_len),
        Owner = rep(owner, length.out = max_len),
        Location = rep(location, length.out = max_len),
        Building_SF = rep(building_sf, length.out = max_len),
        Year_Built = rep(year_built, length.out = max_len),
        Style = rep(style, length.out = max_len)
)

print(df)

# Optional: Write to CSV
#write.csv(df, "property_data.csv", row.names = FALSE)