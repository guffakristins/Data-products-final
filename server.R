# Text of the 3 books are downloaded from gutenberg.org:
# Anecdotes of Dogs:
#  http://www.gutenberg.org/cache/epub/26500/pg26500.txt
# The Einstein Theory of Relativity:
#  http://www.gutenberg.org/cache/epub/11335/pg11335.txt
# Concrete Construction:
#  http://www.gutenberg.org/cache/epub/24855/pg24855.txt

function(input, output, session) {
        # Define a reactive expression for the document term matrix
        terms <- reactive({
                # Change when the "update" button is pressed...
                input$update
                # ...but not for anything else
                isolate({
                        withProgress({
                                setProgress(message = "Processing corpus...")
                                getTermMatrix(input$selection)
                        })
                })
        })
        
        # Make the wordcloud drawing predictable during a session
        wordcloud_rep <- repeatable(wordcloud)
        
        output$plot <- renderPlot({
                v <- terms()
                wordcloud_rep(names(v), v, scale=c(4,0.5),
                              min.freq = input$freq, max.words=input$max,
                              colors=brewer.pal(8, "Dark2"))
        })
}
