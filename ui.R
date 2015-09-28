library(shiny)


# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(    
    
    # Give the page a title
    titlePanel(
      list(tags$head(tags$style()),
           HTML('<div style="background-color:AliceBlue; padding:15px">              
                  <p style="color:SlateGray"><img src="visitor.png", height="40px"/>
                    International Visitors to Singapore</p>
                </div>' )
      )
    ),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      
      # Define the sidebar with one input
      sidebarPanel(
        selectInput("period", label = h4("Select Period Type"), 
                    choices=list("By Year" = 1, "By Month" = 2)),
        
        sliderInput("range", label = h4("Select Year Range"),
                    min = min(df$Year),
                    max = max(df$Year),
                    value = c(2004, 2014),
                    step = 1,
                    sep=""),
        uiOutput("yearControl"),
        
        checkboxGroupInput("region", label = h4("Select Region"), 
                           choices = regions, selected = regions),
        
        hr(),
        helpText("Data Source: Singapore Tourism Board")
      ),
      
      # Main Panel
      mainPanel(
        tabsetPanel(
          
          # Plot
          tabPanel(p(icon("bar-chart"), "Chart"),
                   plotOutput("regionchart"),
                   plotOutput("ctrychart")
          ),
          
          
          # Data 
          tabPanel(p(icon("table"), "Data"),
                   dataTableOutput(outputId="table")
          ),
          
          # About
          tabPanel(p(icon("info-circle"), "About"),
                   includeHTML("about.html") 
          )
        )
      )
    )
  )
)

