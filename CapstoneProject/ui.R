library(shiny)

shinyUI(fluidPage(
    titlePanel("The Next Word Pediction App."),
    sidebarLayout(
        sidebarPanel(
            helpText("Please type/paste word/text below and click the submit button."),

            textInput("textentered", label = h3("Enter text here:"), value = ""),

            actionButton("action", label = "Submit")

        ),


        mainPanel(
            tabsetPanel(

                tabPanel("App",
                         h4("Word Suggestion:"),
                         hr(),
                         h3(textOutput("word"))),

                tabPanel("Documentation", htmlOutput("documentation"))
            )
        )

    )
))



