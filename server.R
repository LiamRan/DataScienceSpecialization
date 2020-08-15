library(shiny)
library(shinysky)
library(ggplot2)
library(ggrepel)
library(stringr)
library(plotly)

data <- readRDS("capstone data.rds")
words <- list()

function(input, output, session){
  observe({
    input$textInput01

    inp <- tolower(input$textInput01)
    inp <- gsub("^[^a-z]+|[^a-z]+$", " ", inp)
    inp <- str_trim(gsub("\\s+", " ", inp))
    
    individual <<- unlist(strsplit(inp, " "))
    
    if (length(individual) == 0){
      if (str_trim(input$textInput01) != ""){
        showshinyalert(session=session, 
                       id="shinyalert01", 
                       HTMLtext=paste0("\"", input$textInput01, 
                                       "\" : invalid input"), 
                       styleclass="danger")
      }
      output$verbatimTextOutput01 <- renderText(NULL)
      output$tableOutput01 <- renderTable(NULL)
      output$plotly01 <- renderPlotly(NULL)
      return()
    } 

    showshinyalert(session=session, 
                   id="shinyalert01", 
                   HTMLtext=paste0("Input entered: \"", inp, "\"."), 
                   styleclass="info")
    results <- head(data[grep(paste0("^", str_trim(paste0(individual[length(individual)-1], " ",
                                     individual[length(individual)])), " "), 
                                     data[,'ngrams']),], 10)
    if (length(individual)>1 & dim(results)[1]==0){
      results <- head(data[grep(paste0("^", individual[length(individual)], " "), 
                                data[,'ngrams']),], 10)}
    
    if (dim(results)[1] == 0){results <- data[1:10,]}
    
    if (dim(results)[1] != 0){
  
      output$verbatimTextOutput01 <- renderText({results[1,1]})
      output$tableOutput01 <- renderTable({names(results)[names(results)=="ngrams"] <- "n_grams"
                                           names(results)[names(results)=="prob"] <- "prop"
                                           results$prop <- format(results$prop, format = "e", digits = 2)
                                           results})
      output$plotly01 <- renderPlotly({
        p01 <- ggplot(data=results, aes(x=reorder(ngrams, -prob), y=prob)) +
               geom_bar(stat="identity", fill="red") +
               labs(title="Most frequent three-grams",
                    x="n-grams", y="Proportion (%)") +
               theme(plot.title=element_text(size=15, face="bold"),
                      axis.text.y=element_text(size = 10),
                      axis.text.x=element_text(size = 12, angle=90))
        ggplotly(p01, width = (0.5*as.numeric(input$dimension[1])),
                 height = .9*as.numeric(input$dimension[2]))
      })
      return()
    }
    output$verbatimTextOutput01 <- renderText("No results)")
    output$tableOutput01 <- renderTable(NULL)
    output$barplot01 <- renderPlot(NULL)
  }) 
  observeEvent(input$actionButton01, {
    individual <<- list()
    updateTextInput(session, "textInput01", value="")
    output$verbatimTextOutput01 <- renderText(NULL)
    output$tableOutput01 <- renderTable(NULL)
    output$barplot01 <- renderPlot(NULL)
    showshinyalert(session=session, 
                   id="shinyalert01", 
                   HTMLtext=paste0("Cleared. Enter new words."), 
                   styleclass="success")
    return()
  }) 
} 