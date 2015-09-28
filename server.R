library(shiny)
library(data.table)
library(ggplot2)
require(grid)


# Define a server for the Shiny app
shinyServer(function(input, output) {
  
  # Select region data based on inputs
  dt.region <- reactive({
    
    validate(
      need(input$region != "", "Please select a region.")
    )
    
    # Subset selected data
    max.year <- max(input$range)
    min.year <- min(input$range)
    
    if(input$period==1) ({
      
      rdf <- df[(df$Year >= min.year) & (df$Year <= max.year) & (df$Region %in% input$region), c(1,3,5)]
      rdt <- aggregate(cbind(Visitors)~Region+Year, data=rdf, sum, na.rm=TRUE)
      
    }) else ({
      
      rdf <- df[(df$Year >= min.year) & (df$Year <= max.year) & (df$Region %in% input$region), c(1,2,3,5)]
      rdt <- aggregate(cbind(Visitors)~Year+Month, data=rdf, sum, na.rm=TRUE)
      
    })
    rdt$Visitors <- rdt$Visitors/1000
    rdt
  })
  
  # Select country data based on inputs
  dt.ctry <- reactive({
    
    validate(
      need(input$region != "", "")
    )
    
    # Subset selected data
    max.year <- max(input$range)
    min.year <- min(input$range)
    cdf <- df[(df$Year >= min.year) & (df$Year <= max.year) & (df$Region %in% input$region), c(4,5)]
    cdt <- aggregate(cbind(Visitors)~Country, data=cdf, sum, na.rm=TRUE)
    cdt$Visitors <- cdt$Visitors/1000
    cdt <- cdt[order(cdt['Visitors'], decreasing = TRUE), ]
  })
  
  # Create chart based on selected data
  output$regionchart <- renderPlot({
    
    if (input$period==1) ({
      
      qplot(x=factor(Year), y=Visitors, fill=Region,
            data=dt.region(), geom="bar", stat="identity",
            ylab="No. of Visitors ('000)", xlab="") +
        ggtitle("Total Visitors to Singapore") +
        scale_fill_brewer(palette = "Paired") +
        theme(plot.title=element_text(size=15, vjust=3)) +
        theme(plot.margin = unit(c(1,1,1,1), "cm")) +
        theme(legend.position="top")
      
    }) else ({
      
      ggplot(data=dt.region(), aes(x=factor(Month, month.abb, ordered=TRUE), Visitors, color=factor(Year))) +
        geom_line(aes(group=Year), size=1) +
        geom_point(size = 5) + ylab("No. of Visitors ('000)") + xlab("") +
        ggtitle("Total Visitors to Singapore") +
        guides(color=guide_legend(title="Year")) +
        theme(plot.title=element_text(size=15, vjust=3)) +
        theme(plot.margin = unit(c(1,1,1,1), "cm"))
      
    })
    
  })
  
  output$ctrychart <- renderPlot({
    
    ggplot(data=dt.ctry(), aes(x=reorder(factor(Country), Visitors),
                               y=Visitors, fill=Country)) +
      ylab("No. of Visitors ('000)") + xlab("") +
      geom_bar(stat="identity") + coord_flip() + 
      ggtitle("Breakdown of Countries of Residence of Visitors") +
      theme(plot.title=element_text(size=15, vjust=3)) +
      theme(plot.margin = unit(c(1,1,1,1), "cm")) +
      theme(legend.position="none")
  })
  
  # Render data table
  output$table <- renderDataTable(
    
{dt.region()}, options = list(searching = FALSE, pageLength = 50))

})