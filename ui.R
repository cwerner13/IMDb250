library(shiny)

shinyUI(pageWithSidebar(
        # Application title
        headerPanel("Directors behind the IMDb Top 250 Movies"),
        
        sidebarPanel(
                numericInput("maxpos", "The Top ", 10, 1, 250),
                ('IMDb Movies (Maximum Entry: 250) were created by the following number of directors'),
                verbatimTextOutput("FreqDirectors"),
                
                submitButton(text="Calculate"),
                
                checkboxGroupInput("year","Yearly Snapshot",c(
                        "Dec 31, 2013" = "2013",
                        "Dec 31, 2012" = "2012"))
                ),
        
        mainPanel(
                tabsetPanel(
                        tabPanel("MotionChart",h4("GoogleViz MotionChart - Top250"),htmlOutput("motionchart")),
                        tabPanel("Table",h4("Calculated Movies by Director (in %)"),htmlOutput("tabla1"),
                                 h4("Activity of the occupied people (in %)"),htmlOutput("tabla2"))
                )
        )
))
