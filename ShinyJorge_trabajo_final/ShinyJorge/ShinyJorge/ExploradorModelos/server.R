#TRABAJO FINAL DE SHINY

#Autor: Jorge Casan Vazquez

library(shiny)
library(ggplot2)
library(MASS)
library(psych)

outlierKD <- function(dt, var) {
  var_name <- eval(substitute(var),eval(dt))
  na1 <- sum(is.na(var_name))
  m1 <- mean(var_name, na.rm = T)
  par(mfrow=c(2, 2), oma=c(0,0,3,0))
  boxplot(var_name, main="With outliers")
  hist(var_name, main="With outliers", xlab=NA, ylab=NA)
  outlier <- boxplot.stats(var_name)$out
  mo <- mean(outlier)
  var_name <- ifelse(var_name %in% outlier, NA, var_name)
  boxplot(var_name, main="Without outliers")
  hist(var_name, main="Without outliers", xlab=NA, ylab=NA)
  title("Outlier Check", outer=TRUE)
  na2 <- sum(is.na(var_name))
  cat("Outliers identified:", na2 - na1, "n")
  cat("Propotion (%) of outliers:", round((na2 - na1) / sum(!is.na(var_name))*100, 1), "n")
  cat("Mean of the outliers:", round(mo, 2), "n")
  m2 <- mean(var_name, na.rm = T)
  cat("Mean without removing outliers:", round(m1, 2), "n")
  cat("Mean if we remove outliers:", round(m2, 2), "n")
  response <- readline(prompt="Do you want to remove outliers and to replace with NA? [yes/no]: ")
  if(response == "y" | response == "yes"){
    dt[as.character(substitute(var))] <- invisible(var_name)
    assign(as.character(as.list(match.call())$dt), dt, envir = .GlobalEnv)
    cat("Outliers successfully removed", "n")
    return(invisible(dt))
  } else{
    cat("Nothing changed", "n")
    return(invisible(var_name))
  }
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  values <- reactiveValues()
  
  output$uiModelExplorer <- renderUI({
    fluidRow(
      column(6, align = 'center',
             numericInput('size', 'Size', min = 1, max = 1000, value = 30),
             numericInput('r', 'Correlation', min = -1, max = +1, value = 0, step = 0.01),
             actionButton('gen', 'Generate')),
      column(6, align = 'center',
             numericInput('order', 'Poly order', min = 1, value = 1, step = 1),
             actionButton('genOrder', 'Add model'))
    )
  })
  
  output$uiModelDetails <- renderUI({
    tabsetPanel(
      tabPanel('Overview', uiOutput('uiOverview')),
      tabPanel('Residuals', uiOutput('uiResiduals')),
      tabPanel('Predictive capacity', uiOutput('uiPCapacity')),
      tabPanel('Outliers', uiOutput('uiOutliers'))
    )
  })
  
  output$uiOverview <- renderUI({
    fluidRow(
      column(6, align = 'center',
             dataTableOutput('dtOverview')),
      column(6, align = 'center',
             plotOutput('plotOverview'))
    )
  })
  
  output$uiResiduals <- renderUI({
    
    fluidPage(
      fluidRow(h2('Residuals Plot'),
               column(12, align = 'center'),
               plotOutput('residualsPlot')
               ),
      fluidRow(h2('Residuals Analysis'),
               column(12, align = 'center',
                      dataTableOutput('dtResiduals')))
    )
  })
  
  output$uiPCapacity <- renderUI({
    dataTableOutput('dtCapacity')
  })
  
  output$uiOutliers <- renderUI({
    plotOutput('outliersPlot')
  })
  
  ############ EVENT REACTIVES #############3
  misDatos <- eventReactive(input$gen, {
      datos <- as.data.frame(mvrnorm(input$size, c(0,0),
                                     Sigma = matrix(c(1, input$r, input$r, 1), nrow = 2)))
      colnames(datos) <- c("x", "y")
      
      datos
    })
  
  ####### OBSERVE EVENTS #############
  observeEvent(input$gen, {
    datos <- as.data.frame(mvrnorm(input$size, c(0,0),
                                   Sigma = matrix(c(1, input$r, input$r, 1), nrow = 2)))
    colnames(datos) <- c("x", "y")
    
    grafica <- ggplot(datos, aes(x=x, y=y)) + geom_point()
    values$gNormal <- grafica
  })
  
  observeEvent(input$genOrder, {
    
    if(!is.null(values$gNormal)){
      values$gNormal <- values$gNormal + geom_smooth(method = "lm", formula = y ~ poly(x, isolate(input$order)))
    }
  })
  
  
  ############### TABLAS ############
  
  output$dtOverview <- renderDataTable({
    datos <- misDatos()
    datosDF <- as.data.frame(describe(datos))
    datosDF
  })
  
  output$dtResiduals <- renderDataTable({
    if(!is.null(values$residuals)){
      residuos <- as.data.frame(values$residuals)
      names(residuos) <- 'Residuals'
      residuos
    }
  })
  
  output$dtCapacity <- renderDataTable({
    first <- rnorm(input$size)
    datos <- misDatos()
    df <- cbind(first, datos)
    fit <- lm(first~x+y, data=df)
    
    dfPred <- as.data.frame(predict(fit))
    names(dfPred) <- 'Predictive Capacity'
    dfPred
  })
  
  ########### PLOTS ###############33
  output$grafica <- renderPlot({
    values$gNormal
  })
  
  output$outliersPlot <- renderPlot({
    datos <- misDatos()
    #qplot(data=datos,x,y) +
      #geom_text(aes(label=ifelse((x>4*IQR(x)|y>4*IQR(y)),label,"")), hjust=1.1)
    var_name <- eval(substitute(x),eval(datos))
    na1 <- sum(is.na(var_name))
    m1 <- mean(var_name, na.rm = T)
    par(mfrow=c(2, 2), oma=c(0,0,3,0))
    boxplot(var_name, main="With outliers")
    hist(var_name, main="With outliers", xlab=NA, ylab=NA)
    outlier <- boxplot.stats(var_name)$out
    mo <- mean(outlier)
    var_name <- ifelse(var_name %in% outlier, NA, var_name)
    boxplot(var_name, main="Without outliers")
    hist(var_name, main="Without outliers", xlab=NA, ylab=NA)
    title("Outlier Check", outer=TRUE)
  })
  
  output$residualsPlot <- renderPlot({
    first <- rnorm(input$size)
    datos <- misDatos()
    df <- cbind(first, datos)
    fit <- lm(first~x+y, data=df)
    ln <- length(fit$residuals)
    sec <- seq(1, ln)
    
    values$fit <- fit
    values$residuals <- fit$residuals
    
    dfRes <- as.data.frame(cbind(sec ,fit$residuals))
    names(dfRes) <- c('Observations', 'Residuals')
    ggplot(dfRes) + geom_smooth(aes(Observations, Residuals))
  })
  
})
