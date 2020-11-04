setwd("/home/agricolamz/for_work/HSE/students/2020_2021_Sinichkin_Botlikh/my_botlikh_transducer")
library(tidyverse)
library(tidytext)

# generate forms ----------------------------------------------------------
generate_without_twol <- function(file) {
  system(paste("lexd", file, "> adj.lexd.att;", 
               "hfst-txt2fst adj.lexd.att -o adj.lexd.hfst;",
               "hfst-fst2strings adj.lexd.hfst"), intern = TRUE)}

generate_with_twol <- function(file) {
  system(paste("lexd", file, "> adj.lexd.att;", 
               "hfst-txt2fst adj.lexd.att -o adj.lexd.hfst;",
               "hfst-twolc adj.twol > adj.twol.hfst;",
               "hfst-compose-intersect adj.lexd.hfst adj.twol.hfst > adj.hfst;",
               "hfst-fst2strings adj.hfst"), intern = TRUE)}

generate_without_twol("adj.lexd") %>%
  enframe() %>% 
  mutate(form = str_extract(value, ":.*"),
         form = str_remove(form, ":"),
         form = ifelse(is.na(form), value, form),
         gloss = str_extract(value, ".*:"),
         gloss = str_remove(gloss, ":")) %>% 
  select(name, form, gloss) %>% 
  View()

# extract alphabet from lexd ----------------------------------------------
lexd <- read_lines("adj.lexd")
split(seq_along(lexd), cumsum(grepl("LEXICON", lexd)))[-1] %>% 
  lapply(function(i){data.frame(lexd[i])}) %>% 
  do.call(rbind, .) %>% 
  rename(text = lexd.i.) %>% 
  filter(!str_detect(text, "LEXICON")) %>% 
  mutate(text = str_remove_all(text, "\\[.*?\\]"),
         text = str_remove_all(text, "<.*>:"),
         text = str_remove_all(text, "\\#.*"),
         text = str_replace_all(text, " {2,}", " ")) %>% 
  filter(!text == "") %>% 
  unnest_tokens(input = text, output = "letters", token = "characters", to_lower = FALSE) %>% 
  distinct(letters) %>% 
  arrange(letters) %>% 
  pull() ->
  alphabet

c(alphabet, toupper(alphabet)) %>% 
  cat()
