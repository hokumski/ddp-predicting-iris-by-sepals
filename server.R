library(shiny)
library(ggplot2)
library(xgboost)

function(input, output) {
    
    dataset <- reactive({
        
        set.seed(input$mySeed);
        
        irisSample <- sample(seq_len(nrow(iris)), size = input$trainset)
        
        irisTrain <- iris[irisSample, ]
        irisTest <- iris[-irisSample, ]

        gbmmodel <- gbm(Species ~ Sepal.Length+Sepal.Width, distribution="multinomial", data=irisTrain,
                        n.trees=20, shrinkage=0.1, cv.folds=5,
                        n.minobsinnode = 2,
                        verbose=FALSE, n.cores=1)
        
        pred<-predict(gbmmodel, irisTest, type="response") 
        predNames<-colnames(pred)[apply(pred,1,which.max)]
        
        irisTrain$type<-'train'
        irisTest$type<- ifelse(predNames==irisTest$Species,'good','error')
        
        irisAll<-rbind(irisTrain,irisTest)
        irisAll
    })

    output$plot <- renderPlot({
        
        irisAll<-dataset()
        
        p<-ggplot(irisAll, aes(irisAll$Sepal.Length, irisAll$Sepal.Width))
        p<-p+geom_point(
            aes(
               shape=factor(irisAll$Species), 
                colour=factor(irisAll$type)))
        p<-p+labs(shape="Species",colour="Result",x="Sepal Length",y="Sepal Width",size=NA)    
        p
        
    }, height=400)
    
    output$text<-renderUI({
        irisAll<-dataset()
        
        correct<-paste("Correct:",sum(irisAll$type=='good'))
        error<-paste("Error:",sum(irisAll$type=='error'))
        
        HTML(paste(correct, error, sep = '<br/>'))
    })
}