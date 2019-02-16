library(shiny)
library(ggplot2)


shinyServer(function(input, output) {
  
  resultados <- reactiveValues()
  
  output$Migrafico1 <- renderPlot({
    ggplot(mpg, aes(x = cyl)) + geom_histogram(fill = input$color)
  })
  
  observeEvent(input$clicar, {
    df1 <- as.data.frame(rnorm(input$elementos))
    df2 <- as.data.frame(rnorm(input$elementos))
    dataframe <- cbind(df1, df2)
    
    names(dataframe) <- c('ejex', 'ejey')
    resultados$grafica <- ggplot(dataframe) + geom_point(aes(ejex, ejey))
  })
  
  output$Migrafico2 <- renderPlot({
    
    df1 <- as.data.frame(rnorm(input$elementos))
    df2 <- as.data.frame(rnorm(input$elementos))
    dataframe <- cbind(df1, df2)
    
    names(dataframe) <- c('ejex', 'ejey')
    
    resultados$grafica <- ggplot(dataframe) + geom_point(aes(ejex, ejey))
    resultados$grafica
    
  })
  
})


#Pasos que he ido haciendo:
##Me creo la variable resultados en donde guardaremos todos los valores reactivos que vayamos creando para ambas gráficas.
##Para nuestro gráfico 1 hacemos un ggplot, en el ejeX estará la cyl del dataset mpg y lo rellenaremos el histograma por el color por defecto, es decir, el azul
## Con el observeevent cada vez que se produzca se actualizará la gráfica en base al reactive value
##Para mi gráfico2, me creo al igual que el anterior una rnorm en base a los elemenos contenidos en el sliderinput, creandonos un dataframe para poder representarlo gráficamente