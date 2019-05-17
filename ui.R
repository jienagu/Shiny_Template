#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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
library(bsplus)
navbarPage(
      title = div(
        div(
          id = "img-id",
          img(src = "Logo.png")
        ),
        "Shiny Template"
      ),
      selected = "panel1",id = "inTabset",
      # CSS code for color
      tags$head(tags$style(HTML('
                                #img-id{
                                position: absolute;
                                right: 5px;
                                top: 7px;
                                }
                                .navbar-default {
                                background-color: #E1EEFF ;
                                }
                                .navbar-default:hover {
                                background-color: #E1EEFF ;
                                }
                                .navbar-default .navbar-brand {
                                color: #003368;
                                font-size: 18px;
                                font-weight:bold;
                                }
                                .navbar-default .navbar-brand:hover{
                                color: #003368;
                                font-size: 18px;
                                }
                                .navbar-default .navbar-nav > .active > a:hover {
                                color: white;
                                background-color: #003368;
                                }
                                .navbar-default .navbar-nav > .active > a:focus{
                                color: white;
                                background-color: #003368;
                                }
                                .navbar-default .navbar-nav > .active > a{
                                color: white;
                                background-color: #003368;
                                }
                                .navbar-default .navbar-nav > li > a {
                                color: #003368;
                                background-color: #E1EEFF ;
                                }
                                .navbar-default .navbar-nav > li > a:hover {
                                color: #f60;
                                background-color: #E1EEFF ;
                                }
                                '))),
      theme = shinytheme("flatly"),
      introjsUI(),
      tabPanel("Home",   value = "panel1",
               # img(src='image4.jpg',  width ="100%"),
               bs_carousel(id = "with_the_beatles") %>%
                 bs_append(content = bs_carousel_image(src = "img/image4.jpg")) %>%
                 bs_append(content = bs_carousel_image(src = "img/image7.jpg")),
               includeMarkdown("www/about.md"), br(),
               # This is where you change the color of action button
               tags$head(tags$style(".launch2{background-color:#003366;} .launch2{color: white;}")),
               actionButton('launch','Launch', class="launch2"), br(), br(),
               useShinyjs(),
               br(),
               img(src='image7.jpg',  width ="100%"),br(),br()



      ),

      tabPanel("Results", value = "panel2",
               fluidPage(

                 br(),
                 introjsUI(),
                 fluidRow(
                   column(12,
                          tags$head(tags$style(".walk{background-color:#006699;} .walk{color: white;}")),
                          bsButton("help", label = "Walk me through the results!", block = F, class="walk"),br(),br(),
                          introBox( data.step = 1,
                                    data.intro = "You can Re-enter questions, check your answers (inputs), download report in pdf (with your note),
                                    here!",
                                    actionButton('back_home','Re-enter questions', class="launch2"),
                                    actionButton('check_input','Check Answers', class="launch2"),
                                    downloadButton("download_table3", "Reports", class="launch2") )
                   )

                 ) ,

                box(solidHeader=TRUE, collapsible = TRUE,width=300,
                          title="Plot1",
                          introBox( data.step = 2,
                                    data.intro = "The first plot",
                          plotOutput("distPlot1") )
                 ),
                 box(solidHeader=TRUE, collapsible = TRUE,width=300,
                     title="Plot2",
                     introBox( data.step = 3,
                               data.intro = "The second plot",
                     plotOutput("distPlot2") )
                 ),
                 box(solidHeader=TRUE, collapsible = TRUE,width=300,
                     title="Plot3",
                     introBox( data.step = 4,
                               data.intro = "The third plot",
                     plotOutput("distPlot3") )
                 ),

                 introBox( data.step = 5,
                           data.intro = "You can write down short notes here and your notes will print in the pdf report when you click download button.",
                           h4("Comments:"),
                           fluidRow(
                             column(12,
                                    tags$textarea(
                                      "Please using any **markdown** syntax!",
                                      id    = 'markdown_table3',
                                      rows  = 6,
                                      style = 'width:100%;')) ) ),
      br(),br()
      ),
      br() )

      )

