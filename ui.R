library(shiny)
library(ggplot2)
library(gbm)
library(gridExtra)

dataset <- iris

fluidPage(
    
    titlePanel("Predicting Iris Species By Sepals"),
    
    sidebarPanel(
        
        numericInput('mySeed', 'Seed for reproducibility', 1000),
        
        sliderInput('trainset', 'Train on', min=20, max=149,
                    value=112, step=1, round=0)
    
    ),
    
    mainPanel(
        
        tabsetPanel(type = "tabs", 
                    tabPanel("Prediction", 
                             plotOutput('plot'),
                             htmlOutput('text')
                    ), 
                    tabPanel("Readme", 
                             h4("How prediction quality depends on sample?"),
                             p("Iris is very famous dataset, containing only 150 measurements. But how much measurements do you need to predict what kind of iris is new one?"),
                             p("Select number of measurements in training set by slider. We use GBM to predict other species by only two parameters: sepal width and length. Dataset contains also petal width and length, but we are using only sepal parameters now."),
                             p("There are 3 different shapes for each specie type (real) and 3 colors."),
                             p("Blue means we used this measurement for training our model, green is for correct predictions and red means that our model failed to predict type of this specie."),
                             p("That's all! Have fun :)"),
                             a(href="mailto:ak@dived.me","ak@dived.me")
                             
                    )
        )
        
        
    )
)