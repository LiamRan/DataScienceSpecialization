library(shiny)
library(shinysky)
library(ggplot2)
library(ggrepel)
library(stringr)
library(plotly)

shinyUI(
  fluidPage(titlePanel("Predictive Text"),
            tags$head(tags$script('
                        var dimension = [0, 0];
                        $(document).on("shiny:connected", function(e) {
                        dimension[0] = window.innerWidth;
                        dimension[1] = window.innerHeight;
                        Shiny.onInputChange("dimension", dimension);
                        });
                        $(window).resize(function(e) {
                        dimension[0] = window.innerWidth;
                        dimension[1] = window.innerHeight;
                        Shiny.onInputChange("dimension", dimension);
                        });
                        ')),
    sidebarLayout(
      sidebarPanel(
        
        h5("Enter up to three words:"),
        textInput("textInput01", label=NULL, 
                  value = "", width=NULL,
                  placeholder=''),
        shinyalert("shinyalert01"),
        h5("Most frequent group of three words:"),
        verbatimTextOutput("verbatimTextOutput01", placeholder=TRUE),
        tableOutput('tableOutput01'),
        actionButton("actionButton01", "Reset")
      ),
      
      mainPanel(
        plotlyOutput("plotly01")
      )
    )
  )
  )
