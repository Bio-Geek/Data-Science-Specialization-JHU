library(shiny)

shinyUI(fluidPage(
    titlePanel("Illustration of Central Limit Theorem"),
    sidebarLayout(
        sidebarPanel(
            helpText("Creates the distribution of sample means by taking random samples from the following distributions:"),

            selectInput("dist",
                        label = "Choose a distribution to display",
                        choices = list("Normal", "Uniform",
                                       "Exponential, lambda=0.2", "Binominal, p=0.5",
                                       "Binominal, p=0.05"),
                        selected = "Uniform"),

            sliderInput("sample_size",
                        label = "Sample size:",
                        min = 1, max = 100, value = 1),

            sliderInput("num_simulations",
                        label = "Number of samples:",
                        min = 1, max = 1000, value = 1)

            ),

        mainPanel(
            tabsetPanel(
                tabPanel("App",
                         plotOutput("distribution"),
                         plotOutput("normality")),
                tabPanel("Documentation", htmlOutput("documentation"))
            )
        )

    )
))



