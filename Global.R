library(tm)
library(wordcloud)
library(memoise)

# The list of the books I chose
books <<- list("Anecdotes of Dogs" = "pg26500",
               "The Einstein Theory of Relativity" = "pg11335",
               "Concrete Construction" = "pg24855")

# Using "memoise" to automatically cache the results
getTermMatrix <- memoise(function(book) {
        # Here I make sure no unknown book can be added to my code
        if (!(book %in% books))
                stop("Unknown book")
        
        text <- readLines(sprintf("./%s.txt", book),
                          encoding="UTF-8")
        
        myCorpus = Corpus(VectorSource(text))
        myCorpus = tm_map(myCorpus, content_transformer(tolower))
        myCorpus = tm_map(myCorpus, removePunctuation)
        myCorpus = tm_map(myCorpus, removeNumbers)
        myCorpus = tm_map(myCorpus, removeWords,
                          c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but"))
        
        myDTM = TermDocumentMatrix(myCorpus,
                                   control = list(minWordLength = 1))
        
        m = as.matrix(myDTM)
        
        sort(rowSums(m), decreasing = TRUE)
})
