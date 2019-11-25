#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  # select which df to use (which game) #
  df <- eventReactive(c(input$click, input$dfSelect),{
    selectdf(input$dfSelect)
  })
  
  # stats repping: total, pocket, PA, out-of-pocket, red zone
  # these are displayed on various tabs in main panel
  output$overall <- renderTable({
    data <- df()
    combineDirStats(data)
  }, rownames = TRUE)
  output$pocketpass <- renderTable({
    data <- df()
    pocketdf <- data[(data[,9]==0 & data[,10]==0),]
    combineDirStats(pocketdf)
  }, rownames = TRUE)
  output$PAPass <- renderTable({
    data <- df()
    PAdf <- data[(data[,9]==1),]
    combineDirStats(PAdf)
  }, rownames = TRUE)
  output$OOPPass <- renderTable({
    data <- df()
    OOPdf <- data[(data[,10]==1),]
    combineDirStats(OOPdf)
  }, rownames = TRUE)
  output$RZPass <- renderTable({
    data <- df()
    RZdf <- data[(data[,8]==1), ]
    combineDirStats(RZdf)
  }, rownames= TRUE)
   
  
  # plot overall passing Yards or Completion % by category of pass play type
  output$distPlot <- renderPlot({
    data <- df()
    pocketdf <- data[(data[,9]==0 & data[,10]==0),]
    PAdf <- data[(data[,9]==1),]
    OOPdf <- data[(data[,10]==1),]
    RZdf <- data[(data[,8]==1), ]
    
    
    if(input$prefOvrPlot=="yds"){
      # plot yards
      x <- as.vector(rbind(sum(pocketdf$Yds),sum(PAdf$Yds),sum(OOPdf$Yds),sum(RZdf$Yds)))
      plot(x, ylim = c(0, max(x)+10), xlim= c(.5, length(x)+.5),
           main="Pass Yds",
           ylab = "Yards",
           xlab= "Pass Classification") 
      text(x, labels=c("Pocket","Play-Action","Out-Of-Pocket","Red Zone"), pos=1)
    }else if(input$prefOvrPlot=="cmpprc"){
      # plot completion percentage
      x <- as.vector(rbind( sum(pocketdf$Comp)/length(pocketdf$Comp),
                            sum(PAdf$Comp)/length(PAdf$Comp),
                            sum(OOPdf$Comp)/length(OOPdf$Comp),
                            sum(RZdf$Comp)/length(RZdf$Comp)  ))
      plot(x, ylim = c(0,1), xlim = c(.5, length(x)+.5), main="Comp. %",
           ylab = "Completion Rate",
           xlab = "Pass Classification")
      text(x, labels=c("Pocket","Play-Action","Out-Of-Pocket","Red Zone"),pos=1)
    }else if(input$prefOvrPlot=="attempts"){
      x <- as.vector(rbind(length(pocketdf$Comp),length(PAdf$Comp),
                           length(OOPdf$Comp),length(RZdf$Comp)))
      plot(x, ylim=c(0,max(x)+3),xlim=c(.5,4.5),main="Pass Attempts")
      text(x,labels=c("Pocket","Play-Action","Out-Of-Pocket","Red Zone"),pos=1)
    }

  })
  
})
