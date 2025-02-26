poole_taxcard <- read_html('https://nemrc.info/web_data/vtferi/camadetailT.php?prop=23/20/01')
class(poole_taxcard)
poole_taxcard
poole_taxcard |> html_nodes('.camaLabel') |> html_text() ## this gets the column headers you want 
poole_taxcard |> html_nodes('.colspan') |> html_text()
