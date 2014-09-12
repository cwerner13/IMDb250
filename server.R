library(shiny)

shinyServer(function (input, output) {
        
        data <- reactive({
                a <- subset(result, Pos <= input$maxpos)
                return(a)
        })
        
        
        output$FreqDirectors <- renderPrint({
                length(with(data(), prop.table(table(Directors),1)))
                })
        
        
        output$motionchart <- renderGvis({
                
              
                  myStateSettings <-'{"xZoomedDataMax":9.3,"nonSelectedAlpha":0.4
                                         ,"yZoomedIn":false
                                         ,"iconKeySettings":[{"key":{"dim0":"Charlie Chaplin"}},{"key":{"dim0":"Martin Scorsese"}}]
                                         ,"orderedByX":false,"yZoomedDataMin":0.004
                                         ,"dimensions":{"iconDimensions":["dim0"]}
                                         ,"yZoomedDataMax":0.04,"xZoomedIn":false
                                         ,"iconType":"BUBBLE", "xAxisOption":"3"
                                         ,"xLambda":1,"yLambda":1,"sizeOption":"5"
                                         ,"uniColorForNonSelected":false
                                         ,"playDuration":40000,"time":"1920","showTrails":false
                                         ,"yAxisOption":"2","duration":{"timeUnit":"Y","multiplier":1}
                                         ,"xZoomedDataMin":8,"colorOption":"_UNIQUE_COLOR","orderedByY":false}
                                        '
                return (gvisMotionChart(data=result
                                , idvar="Directors", timevar="Year"
                                , xvar="Percentage", yvar="IMDbRating", sizevar="NumVotes"
                                , options=list(state=myStateSettings)
                                , chartid="IMDB_Top250"))
                
        })
        
        
        output$tabla1 <- renderGvis({
                
                t1 <- with(data(), prop.table(table(Directors,Year),1))
                t1 <- as.data.frame.matrix(t1)
                t1 <- t1*100
                t1 <- round(t1,1)
                t1 <- cbind(row.names(t1),t1)
                colnames(t1)[1] <- "Director Names"
                t1.pl <- gvisTable(t1,options=list(page='enable',height=300,width=800))
                return(t1.pl)
        })

        
        outputOptions(output, "motionchart", suspendWhenHidden = FALSE)
#         outputOptions(output, "edades", suspendWhenHidden = FALSE)
#         outputOptions(output, "tabla1", suspendWhenHidden = FALSE)
#         outputOptions(output, "tabla2", suspendWhenHidden = FALSE)
#         outputOptions(output, "linech", suspendWhenHidden = FALSE)
})