library(tidyverse)
library(tidytext)
# Loading the First Text File

melville_raw <- scan("/Users/alena2/Dropbox/Teaching_Students/Classes_Courses/2022-2023/HUJI2023_StatisticsB/Classes&Slides/Slides/HUJI2022_QuantB_10_NLP/melville.txt", what="character", sep="\n", skip = 533)

str(melville_raw)
summary(melville_raw)

# Let's look inside
melville_raw

# We collapse all elements of the vector into one veery long string
melville <- paste(melville_raw, collapse=" ")
melville

melville <- tibble(melville)
melville

melville <- melville %>%
  unnest_tokens(word, melville)
melville
# to_lower = FALSE -Y

# More interesting, perhaps, is to have R calculate the number of unique word types in the novel. 
# R’s unique function will examine all the values in the character vector and identify those that are the same and those that are different. By combining the unique and length functions, you calculate the number of unique words in Melville’s Moby Dick vocabulary.
length(unique(melville$word))

# that’s interesting, but let’s kick it up another notch. 
# What we really want to know is how often he uses each of his words and which words are his favorites. We may even want to see if Moby Dick abides by Zipf’s law regard- ing the general frequency of words in English.24 No problem. R’s table function can be used to build a “contingency” 
# table of word types and their corresponding frequencies.

# count the frequency of each token
melville %>% 
  group_by(word) %>%
  summarize(tokens = n()) -> token_frequency

# count the frequency of each token
melville %>% 
  filter(word %in% c("she", "her", "hers"))

melville %>% 
  filter(word %in% c("he", "his", "him"))

melville %>% 
  filter(word == "whale") %>%
  summarize(n())

melville %>% 
  filter(word == "whale") %>%
  summarize(tokens = n())

melville %>% 
  filter(word == "harpoon") %>%
  summarize(tokens = n())

# TTR
unique(melville$word)

length(unique(melville$word))

# TTR 8.117047
length(unique(melville$word)) / length(melville$word) * 100
length(unique(melville$word[1:100])) / length(melville$word[1:100]) * 100
# 71
length(unique(melville$word[1:1000])) / length(melville$word[1:1000]) * 100
# 48.9


# striingr
str_length(melville$word)
melville %>% mutate(nr_characters = str_length(melville$word)) -> melville

melville %>%
  ggplot(aes(x = nr_characters)) +
  geom_histogram(binwidth = 1, fill = "seagreen3") + 
  theme_bw()

melville %>% 
  group_by(word, nr_characters) %>%
  summarize(count = n()) -> melville_frequency

melville_frequency %>% arrange(desc(nr_characters))

melville_frequency %>% filter(nr_characters > 15)

melville_frequency %>% 
  filter(nr_characters == 10) %>%
  arrange(desc(count))

melville_frequency %>% 
  ggplot(aes(x = nr_characters, y = log10(count))) + 
  geom_jitter(size = 0.1, alpha = 0.1) + 
  geom_smooth()

melville_frequency %>% 
  ggplot(aes(x = nr_characters, y = count)) + 
  geom_jitter(size = 0.1, alpha = 0.1) 


# tokenize into sentences
melville_raw

# We collapse all elements of the vector into one veery long string
melville <- paste(melville_raw, collapse=" ")
melville <- tibble(melville)
melville_sent <- melville %>%
  unnest_tokens(word, melville, token = "sentences")
str_count(melville_sent$word, "\\s")
str_count(melville_sent$word, "\\w+")

austen_raw <- scan("/Users/alena2/Dropbox/Teaching_Students/Classes_Courses/2022-2023/HUJI2023_StatisticsB/Classes&Slides/Slides/HUJI2022_QuantB_10_NLP/austen.txt", what="character", sep="\n", skip = 43)
austen <- paste(austen_raw , collapse=" ")
austen

austen <- tibble(austen)
austen

austen <- austen %>%
  unnest_tokens(word, austen)
austen
# to_lower = FALSE -Y

# More interesting, perhaps, is to have R calculate the number of unique word types in the novel. 
# R’s unique function will examine all the values in the character vector and identify those that are the same and those that are different. By combining the unique and length functions, you calculate the number of unique words in Melville’s Moby Dick vocabulary.
length(unique(austen$word))

length(unique(austen$word[1:100])) / length(austen$word[1:100]) * 100



melville %>% 
  mutate(id = row_number())
#statistics #R #text-mining #learning #teaching 
# Silge2017Text


melville_raw %>% 
  unnest_tokens(text, token = "ngrams", n = 2) -> melville_bigrams

melville_ngram <- paste(melville_raw, collapse=" ")
melville_ngram <- tibble(melville_ngram)
melville_ngram <- melville_ngram %>%
  unnest_tokens(text, melville_ngram, token = "ngrams", n = 2)

melville_ngram

### unnest sentences

melville <- melville %>%
  unnest_tokens(word, melville)


#### QUANTEDA 
install.packages("quanteda")
library("quanteda")
install.packages("readtext")
library("readtext")

library("quanteda.textstats")
data_char_mobydick <- texts(readtext("http://www.gutenberg.org/cache/epub/2701/pg2701.txt"))

names(data_char_mobydick) <- "Moby Dick"


textstat_frequency(melville, n = 10) 

install.packages("tidytext")

library(tidyverse)
library(tidytext)
# library(stringr)




# Work through integrate into class some sections

text <- c("Because I could not stop for Death -", "He kindly stopped for me -", "The Carriage held but just Ourselves -", "and Immortality")

text
# This is a typical character vector that we might want to analyze. 
# We first need to put it into a data frame.

text_df <- data_frame(line = 1:4, text = text)
# text_df <- data_frame(text) # no id
text_df


text_df %>% unnest_tokens(word, text)

# Within our tidy text framework, we need to both break the text into individual tokens (a process called tokenization) and transform it to a tidy data structure. To do this, we use the tidytext unnest_tokens() function.
text_df %>%
  unnest_tokens(word, text) # to_lower = FALSE



# we’ve split each row: there is one token (word) in each row 
# the default tokenization in unnest_tokens() is for single words

# Other columns, such as the line number each word came from, are retained.
# Punctuation has been stripped.
# By default, unnest_tokens() converts the tokens to lowercase, which makes them easier to compare or combine with other datasets. (Use the to_lower = FALSE argument to turn off this behavior).


## Jane Austin

library(janeaustenr)

original_books <- austen_books()
original_books %>% 
  unnest_tokens(word, text) -> books

original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",
                                                 ignore_case = TRUE)))) %>%
  ungroup()

books %>%
  count(word, sort = TRUE)

books %>%
  count(word, sort = TRUE) %>%
  filter(n > 6000) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()
