library(shiny)
library(googleVis)


shinyServer(function (input, output) {
        
        data <- reactive({
                a <- subset(result, Pos <= input$maxpos)
                return(a)
        })
        
        
        output$FreqDirectors <- renderPrint({
                length(with(data(), prop.table(table(Directors),1)))
                })
        
        
        output$motionchart <- renderGvis({
                              
                myStateSettings <-'
                {"xZoomedDataMax":9.3,"nonSelectedAlpha":0.4
                ,"yZoomedIn":false
                ,"iconKeySettings":[{"key":{"dim0":"Sergio Leone"}},{"key":{"dim0":"Frank Capra"}},{"key":{"dim0":"Stanley Kubrick"}},{"key":{"dim0":"Charlie Chaplin"}},{"key":{"dim0":"Billy Wilder"}},{"key":{"dim0":"Christopher Nolan"}},{"key":{"dim0":"Peter Jackson"}},{"key":{"dim0":"Alfred Hitchcock"}},{"key":{"dim0":"Steven Spielberg"}},{"key":{"dim0":"Quentin Tarantino"}},{"key":{"dim0":"Akira Kurosawa"}},{"key":{"dim0":"Clint Eastwood"}},{"key":{"dim0":"Martin Scorsese"}}]
                ,"orderedByX":false,"yZoomedDataMin":0.004
                ,"dimensions":{"iconDimensions":["dim0"]}
                ,"yZoomedDataMax":0.04,"xZoomedIn":false
                ,"iconType":"BUBBLE", "xAxisOption":"3"
                ,"xLambda":1,"yLambda":1,"sizeOption":"4"
                ,"uniColorForNonSelected":false
                ,"playDuration":40000,"time":"1920","showTrails":false
                ,"yAxisOption":"2","duration":{"timeUnit":"Y","multiplier":1}
                ,"xZoomedDataMin":8,"colorOption":"_UNIQUE_COLOR","orderedByY":false}
                '
                return (gvisMotionChart(data=result
                                , idvar="Directors", timevar="Year"
                                , xvar="Percentage", yvar="IMDbRating"
                                , sizevar="NumVotes"
                                , options=list(state=myStateSettings)
                                , chartid="IMDB_Top250"))
                
        })
        
        
#         output$tabla1 <- renderGvis({
#                 
#                 t1 <- with(data(), prop.table(table(Directors, SnapshotDate)))                
#                 t1 <- as.data.frame.matrix(t1)
#                 t1 <- t1*100     
#                 t1 <- round(t1,1)
#                 t1 <- cbind(row.names(t1),t1)
#                 colnames(t1)[1] <- "Director Names"
#                 t1.pl <- gvisTable(t1,options=list(page='enable',height=300,width=800))
#                               
#                 return(t1.pl)
#         })

        # Make the wordcloud drawing predictable during a session
        
        output$plot <- renderPlot({
                
#                 wordcloud_rep <- repeatable(wordcloud)            
                
                wc <- wordcloud(d$word,d$freq, scale=c(5,.3),min.freq=1,max.words=100
                          , random.order=T, rot.per=.15, colors=brewer.pal(8, "Dark2"))
                return(wc)
        })

        
#         output$tablebasic = renderTable({
#                 t1 <- with(data(), (table(Directors)))
#                 t1 <- as.data.frame(t1)
#                 t1 <- t1[order(-t1$Freq),]
#                 return(t1)
#         })

        output$tablemovie = renderDataTable({
                 t1 <- data()
                 t1 <- t1[,c(2,4,3)]      # select columns
                 t1 <- t1[order(t1$Directors, t1$Pos),] #sort
                 return(t1)
        })
        
        output$tabla1 <- renderGvis({
                
                t1 <- with(data(), (table(Directors)))
                t1 <- as.data.frame(t1)
                t1 <- t1[order(-t1$Freq),]
                
#                 t1 <- cbind(row.names(t1),t1)
#                 colnames(t1)[1] <- "Director Names"
                t1.pl <- gvisTable(t1,options=list(page='enable',height=300,width=600))
                
                return(t1.pl)
        })

        
        outputOptions(output, "motionchart", suspendWhenHidden = FALSE)
        outputOptions(output, "plot", suspendWhenHidden = FALSE)
        outputOptions(output, "tabla1", suspendWhenHidden = FALSE)
#         outputOptions(output, "linech", suspendWhenHidden = FALSE)
})