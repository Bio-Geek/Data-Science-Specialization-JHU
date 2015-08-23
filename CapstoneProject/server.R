# server.R
unigrams <- read.csv("data/unigrams_predictions.csv", header=FALSE, stringsAsFactors = FALSE)
bigrams <- read.csv("data/bigrams_predictions.csv", header=FALSE, stringsAsFactors = FALSE)
trigrams <- read.csv("data/trigrams_predictions.csv", header=FALSE, stringsAsFactors = FALSE)
fourgrams <- read.csv("data/fourgrams_predictions.csv", header=FALSE, stringsAsFactors = FALSE)
prediction <- ""

## Function to add 'UNK' if the word is not in unigrams
## and to do some clean up of the input.
add_UNK <- function(words){
    new_words <- c()
    for (word in words) {
        if (word == "") {
            next }
        else if (word == "-") {
            next}
        else if (word == "'") {
            next}
        else if (word == '"') {
            next}
        else if ("\\" %in% word) {
            next}
        else if (word %in% unigrams$V1) {
            new_words <- c(new_words, word)
        } else {
            new_words <- c(new_words, 'UNK')}
        }
    return(new_words)
}

next_word <- function(input) {
     if(nchar(input) > 0)
    {
        input <- gsub("[^A-Za-z' -]", "", input)
        input <- tolower(input)
        input <- strsplit(input, " ")
        input <- unlist(input)
        input <- rev(input)
        input <- add_UNK(input)

        if (length(input) == 0){
            prediction <- ""
            return(prediction)
        }

        unigram <- input[1]

        if(length(input) == 1) {
            bigram <- paste(input[1], 'SOTS', sep=' ')
            trigram <- "dummy dummy dummy"
        }
        else if(length(input) == 2) {
            bigram <- bigram <- paste(input[2], input[1], sep=' ')
            trigram <- paste(input[2], input[1], 'SOTS', sep=' ')
        }
        else {
            bigram <- paste(input[2], input[1], sep=' ')
            trigram <- paste(input[3], input[2], input[1], sep=' ')
        }


        if(trigram %in% fourgrams$V1) {
            prediction <- subset(fourgrams, V1 == trigram, V2)$V2
        }
        else if(bigram %in% trigrams$V1) {
            prediction <- subset(trigrams, V1 == bigram, V2)$V2
        }

        else if(unigram %in% bigrams$V1) {
            prediction <- subset(bigrams, V1 == unigram, V2)$V2
        }
        else {
            prediction <- "the"
        }
     }
    return(prediction)
}

shinyServer(function(input, output) {

    predicted <- eventReactive(input$action, {
        next_word(input$textentered)
    })

    output$word <- renderText({predicted()})

    output$documentation <- renderUI({

        str1 <- "The aim of this application is to predict the next word after typing/pasting a word or text."
        str1a <- "How to use the App:"
        str2 <- "1) Type/paste word/text in the enter text field."
        str3 <- "2) Click 'Submit' button."
        str4 <- "The predicted word will be displayed in the right panel."
        str5 <- "Thanks for using the App!"

        HTML(paste(str1, str1a, str2, str3, str4, str5, sep = '<br/><br/>'))
        })
})




















