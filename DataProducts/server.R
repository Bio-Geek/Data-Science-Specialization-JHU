# server.R
library(ggplot2)

shinyServer(function(input, output) {

    output$distribution <- renderPlot({
        data <- switch(input$dist,
                       "Normal" = list(rnorm(100000), 8/30),
                       "Uniform" = list(runif(100000), 1/30),
                       "Exponential, lambda=0.2" = list(rexp(10000, rate = 0.2), 35/30),
                       "Binominal, p=0.5" = list(rbinom(10000, size=1, prob = 0.5), 1/30),
                       "Binominal, p=0.05" = list(rbinom(10000, size=1, prob = 0.05), 1/30)
                    )

        plot1 <- qplot(data[[1]], geom="histogram", binwidth = data[[2]],
                       col=I("skyblue"), alpha=I(.2), main="Original Distribution",
                       xlab="", ylab="Frequency")
        plot1
    })

    output$normality <- renderPlot({
        sim_mean <- switch(input$dist,

                    "Normal" = apply(matrix(rnorm(input$sample_size*input$num_simulations),
                                                nrow=input$num_simulations),
                                                1, mean),

                    "Uniform" = apply(matrix(runif(input$sample_size*input$num_simulations),
                                                nrow=input$num_simulations),
                                                1, mean),

                    "Exponential, lambda=0.2" = apply(matrix(rexp(input$sample_size*input$num_simulations,
                                                rate=0.2),
                                                nrow=input$num_simulations),
                                                1, mean),

                    "Binominal, p=0.5" = apply(matrix(rbinom(input$sample_size*input$num_simulations,
                                                size=1, prob=0.5),
                                                nrow=input$num_simulations),
                                                1, mean),

                    "Binominal, p=0.05" = apply(matrix(rbinom(input$sample_size*input$num_simulations,
                                                size=1, prob=0.05),
                                                nrow=input$num_simulations),
                                                1, mean)
                    )

        x_lim <- switch(input$dist,

                        "Normal" = c(-5, 5),
                        "Uniform" = c(0, 1),
                        "Exponential, lambda=0.2" = c(0, 35),
                        "Binominal, p=0.5" = c(0, 1.01),
                        "Binominal, p=0.05" = c(0, 1.01)
                        )

        teor_mean <- switch(input$dist,

                        "Normal" = 0,
                        "Uniform" = 0.5,
                        "Exponential, lambda=0.2" = 1/0.2,
                        "Binominal, p=0.5" = 0.5,
                        "Binominal, p=0.05" = 0.05
        )

        bin_width <- switch(input$dist,

                        "Normal" = 10/150,
                        "Uniform" = 1/150,
                        "Exponential, lambda=0.2" = 35/150,
                        "Binominal, p=0.5" = 1/100,
                        "Binominal, p=0.05" = 1/100
        )

        plot <- ggplot(as.data.frame(sim_mean), aes(x=sim_mean)) +
                        geom_histogram(alpha=0.5, binwidth=bin_width,
                        colour = "yellow", aes(y = ..count..)) +
                        xlim(x_lim) + xlab("Sample Means") + ylab("Frequency") +
                        ggtitle("Distribution of Sample Means")
        plot <- plot + geom_vline(xintercept=teor_mean, colour="red2")
        plot

    })

    output$documentation <- renderUI({

        str1 <- "The aim of this application is to illustrate the applicability of the Central Limit Theorem (CLT) to the sample mean of different distributions. The CLT states that the arithmetic mean of a sufficiently large sample of any distribution with a well-defined expected value and variance, will be approximately normally distributed."
        str1a <- "How to use the App:"
        str2 <- "1) Use the selection box on the left to choose a distribution."
        str3 <- "2) Use the upper slider on the left to select the size of the sample from the chosen distribution and the lower slider on the left to select the number of such samples, respectively."
        str4 <- "The top figure will show the chosen distribution and the bottom figure will display the distribution of the means of samples taken from that distribution."
        str5 <- "The red vertical line shows a theoretical mean of the chosen distribution."

        HTML(paste(str1, str1a, str2, str3, str4, str5, sep = '<br/><br/>'))
        })
})




















