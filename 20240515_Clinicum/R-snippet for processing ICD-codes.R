library(tidyverse)

# Skapa ett syntetiskt dataset
data <- tibble(
  pseudo_id = c("Tolvan Tolvansson", "Tolvan Tolvansson", "Tolvan Tolvansson", "John Doe", "John Doe"),
  indexdatum = as.Date(c("2019-01-07", "2019-01-07", "2019-01-07", "2019-03-04", "2019-03-04")), # Manuellt satta till det tidigaste datumet för varje person
  besoksdatum = as.Date(c("2019-06-13", "2019-01-29", "2019-01-07", "2019-03-12", "2019-03-04")),
  icd_raw = c("F100,F200,F300", "F101", "F100, F200", "F150", "F190")
)

data # kika på tabellen 


# Kod för att gå från fyr- eller femställig ICD-diagnos till treställig sjukdomskategori 
data |> 
  filter(indexdatum==besoksdatum) |> # Filtrera vårdhändelser som motsvarar indexbesöket 
  mutate(first_icd = str_extract(icd_raw, "^[^,]+")) |> # Prim diagnos: Extrahera alla tecken innan det första kommatecknet i icd_raw 
  mutate(icd_tre = str_extract(first_icd, "^.{3}")) # Treställig kod: extrahera de tre första tecken i first_icd 


# Kod för att omformatera alla diagnoser till en kolumn-lista och därefter hämta ut primär diagnos, sekundär diagnos etc. 
data |> 
  filter(indexdatum==besoksdatum) |> # Filtrera vårdhändelser som motsvarar indexbesöket 
  mutate(icd_list = str_extract_all(icd_raw, "\\b[^,]+\\b")) |> # skapa en kolumn-lista med alla ICD-diagnoser
  mutate(first_icd = map_chr(icd_list, ~ .x[1])) |> # Extrahera primär diagnos 
  mutate(second_icd = map_chr(icd_list, ~ .x[2])) # Extrahera sekundär diagnos 


