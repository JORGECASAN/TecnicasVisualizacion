
#Examen Visualiacion Jorge Casan Vazquez

library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Examen de Shiny Jorge Casan Vazquez"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId ='color',
                  label = 'Elige el color que quieras',
                  choices = c('grey' = 'grey', 'red' = 'red', 'blue' = 'blue'),
                  selected = 'blue'),
      sliderInput("elementos",
                  "Numero de elementos",
                  min = 1,
                  max = 50,
                  value = 20,
                  step = 1),
      actionButton('clicar', 'Nuevo dataset')
    ),
    
    mainPanel(
      plotOutput("Migrafico1"),
      plotOutput("Migrafico2")
    )
  )
))

