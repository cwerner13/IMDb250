library(shiny)
library(googleVis)

shinyUI(fluidPage(
        # Application title
        headerPanel('Directors behind the IMDb Top 250 Movies'),
        
        sidebarPanel(
                
                
                ('The'),  
                tags$a(href="http://www.imdb.com/chart/top?ref_=nv_ch_250_4", "IMDb Top 250 list"),
                (' celebrates outstanding films, cinema 
                  development over the past 100 year and its variety. However, 
                  the master minds behind these movies are not as manifold as 
                  the list title suggests.'),
                  br(),
                hr(),
                img(src="clapper2012.png"),
                numericInput("maxpos", "The Top X IMDb Movies (Maximum Entry: 250) ", 10, 1, 250),
                br(),
                (' were created by how many different directors?'),
                verbatimTextOutput("FreqDirectors"),
                
                submitButton(text="Calculate"),
                
                hr(),
#                 checkboxGroupInput("year","Yearly Snapshot",c(
#                         "Dec 31, 2013" = "2013",
#                         "Dec 31, 2012" = "2012"),
#                         selected = "Dec 31, 2012" ),


                ('Code on  '),
                tags$a(href="https://github.com/cwerner13/IMDb250", "github"),
                (', clipart from '),
                tags$a(href="http://www.clker.com", "clker.com"),
                (', data snapshot taken from '),
                tags$a(href="http://www.imdb.com", "IMDb.com"),
                ( 'on '),

                 radioButtons("radio", label = (""),
                             choices = list(
#                                          "Dec 31, 2013" = as.Date("2013-12-31", "%Y-%m-%d"),
                                           "Dec 31, 2012" = as.Date("2012-12-31", "%Y-%m-%d")), 
                             selected = as.Date("2012-12-31", "%Y-%m-%d"))


                
                
                ),
        
        mainPanel(
                tabsetPanel(
                        tabPanel("MotionChart",h4("MotionChart - Top250 (Gviz)"),htmlOutput("motionchart")),
                        
                        tabPanel("Table",h4("Number of Movies by selected Directors (Gviz)"),htmlOutput("tabla1"),
                                 br(), h4("related Movie Titels and their IMDb Ranking (DataTable)"),dataTableOutput("tablemovie"))
                )
        )
))
