#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyjs)
library(shinythemes)
library(Cairo)
library(shinydashboard)
library(shinyBS)
library(rintrojs)
library(shinymaterial)
library(noteMD)
shinyServer(function(input, output, session ) {
  # start introjs when button is pressed with custom options and events
  introjsUI()
  #  introjs(session, events = list(onbeforechange = readCallback("switchTabs")))
  # show intro tour
  observeEvent(input$help,
               introjs(session, options = list("nextLabel" = "Next",
                                               "prevLabel" = "Previous",
                                               "skipLabel"="Close",
                                               "doneLabel" = "Done!"),
                       events = list(onbeforechange = readCallback("switchTabs") )
               )
  )
  hideTab("inTabset", "panel2")
  
  
  current_input=reactive({
    str1_0=paste("Input for Question 1:", input$Answer1)
    str1_1=paste("Input for Question 2:", input$Answer2)
    str1_2=paste("Input for Question 3:", input$Answer3)
    HTML(paste(str1_0,str1_1,str1_2, sep = '<br/>'))
  })
  
  output$inputtext <- renderUI({
    current_input()
  })
  

  #### Pop up questions pages ####
  # the modal dialog where the user can enter the query details.
  query_modal_post <- modalDialog(
    title = "Question Page 3/3",
    numericInput("Answer3", label="Please select Number of bins for the third plot:", min=1, max=50, value=30),
    easyClose = F,size = "l",
    footer = tagList(
      actionButton("ready", "Go!")
    )
  )
  observeEvent(input$ready, {
    showTab("inTabset", "panel2")
    
  }
  )
  
  query_modal <- modalDialog(
    title = "Welcome to Question Pages",
    helpText("Lorem ipsum porta ut volutpat lacinia condimentum mi et ac, 
             vel ornare vel dictumst sem aliquam hendrerit magna torquent euismod, 
             ad torquent etiam iaculis felis orci donec quisque pretium mauris feugiat neque eu ut."),
    easyClose = F,size = "l",
    footer = tagList(
      modalButton("Cancel"),  actionButton("next1_2", "Next Page")
    )
  )
  
  query_modal2 <- modalDialog(
    title = "Question Page 1/3",
    numericInput("Answer1", label="Please select Number of bins for the first plot:", min=1, max=50, value=20),
    easyClose = F,size = "l",
    footer = tagList(
      modalButton("Cancel"), actionButton("next2_3", "Next Page")
    )
  )
  
  query_modal3 <- modalDialog(
    title = "Question Page 2/3",
    numericInput("Answer2", label="Please select Number of bins for the second plot:", min=1, max=50, value=10),
    easyClose = F,size = "l",
    footer = tagList(
      modalButton("Cancel"), actionButton("next3_s", "Next")
    )
  )
  
  all_inputs=modalDialog(
    title = "Your Answers:",
    uiOutput("inputtext"),
    footer = modalButton("Dismiss"),
    size = "l", easyClose = T, fade = TRUE
  )
  
  # Show the model on start up ...
  observeEvent(input$launch,{
    showModal(query_modal)
  })
  
  # ... or when user wants to change query
  # observeEvent(input$change,{
  #   showModal(query_modal)
  # })
  
  # reactiveVal to store the dataset
  observeEvent(input$next3_s,{
    showModal(query_modal_post)
  })
  
  observeEvent(input$next1_2,{
    showModal(query_modal2)
  })
  
  observeEvent(input$next2_3,{
    showModal(query_modal3)
  })
  
  observeEvent(input$ready,{
    removeModal()
  })
  
  ### jump to tab
  observeEvent(input$ready, {
    updateTabsetPanel(session, "inTabset",
                      selected = "panel2")
  })
  
  observeEvent(input$back_home, {
    updateTabsetPanel(session, "inTabset",
                      selected = "panel1")
  })
  
  observeEvent(input$back_home2, {
    updateTabsetPanel(session, "inTabset",
                      selected = "panel1")
  })
  
  observeEvent(input$check_input, {
    showModal(all_inputs)
  })
  
  observeEvent(input$check_input2, {
    showModal(all_inputs)
  })
  
  observeEvent(input$check_str, {
    showModal(query_modal_post)
  })
  observeEvent(input$check_str2, {
    showModal(query_modal_post)
  })

  useShinyjs()
  
  observe({
    
    shinyjs::hide("check_str")
    if(!is.null(input$Answer3) )
      shinyjs::show("check_str")
  })
  output$distPlot1 <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$Answer1 + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  output$distPlot2 <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$Answer2 + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'blue', border = 'white')
  })
  output$distPlot3 <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$Answer3 + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'orange', border = 'white')
  })
  ### ### download pdf part ### ###
  ### ###                   ### ###
  output$download_table3 = downloadHandler(
    filename<- function(){
      paste("Biosecurity Report",Sys.Date(),".pdf",sep = "")
    },
    content = function(file) {
      #### Progressing indicator
      withProgress(message = 'Download in progress',
                   detail = 'This may take a while...', value = 0, {
                     for (i in 1:15) {
                       incProgress(1/15)
                       Sys.sleep(0.01)
                     }
                     src <- normalizePath('bio_table3.Rmd')
                     
                     # temporarily switch to the temp dir, in case you do not have write
                     # permission to the current working directory
                     owd <- setwd(tempdir())
                     on.exit(setwd(owd))
                     file.copy(src, 'bio_table3.Rmd', overwrite = TRUE)
                     
                     library(rmarkdown)
                     out <- render('bio_table3.Rmd', pdf_document())
                     file.rename(out, file)
                   })
    },
    contentType = 'application/pdf'
  )
  
  output$download_table3_2 = downloadHandler(
    filename<- function(){
      paste("Biosecurity Report",Sys.Date(),".pdf",sep = "")
    },
    content = function(file) {
      #### Progressing indicator
      withProgress(message = 'Download in progress',
                   detail = 'This may take a while...', value = 0, {
                     for (i in 1:15) {
                       incProgress(1/15)
                       Sys.sleep(0.01)
                     }
                     src <- normalizePath('bio_table3.Rmd')
                     
                     # temporarily switch to the temp dir, in case you do not have write
                     # permission to the current working directory
                     owd <- setwd(tempdir())
                     on.exit(setwd(owd))
                     file.copy(src, 'bio_table3.Rmd', overwrite = TRUE)
                     
                     library(rmarkdown)
                     out <- render('bio_table3.Rmd', pdf_document())
                     file.rename(out, file)
                   })
    },
    contentType = 'application/pdf'
  )
  ### ### End of download pdf part ### ###
  ### ###                          ### ###
  
 
  #  introjs(session, events = list(onbeforechange = readCallback("switchTabs")))
  
})





