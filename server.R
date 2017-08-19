# Text of the books downloaded from:
# Artists' Wives:
#  http://www.gutenberg.org/cache/epub/22522/pg22522.txt
# Cathedrals and Cloisters of the South of France:
#  http://www.gutenberg.org/cache/epub/22718/pg22718.txt
# Romeo and Juliet:
#  http://www.gutenberg.org/cache/epub/1112/pg1112.txt

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