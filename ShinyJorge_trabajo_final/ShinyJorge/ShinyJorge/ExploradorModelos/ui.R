
#TRABAJO FINAL DE SHINY

#Autor: Jorge Casan Vazquez




library(shinydashboard)
library(shiny)

shinyUI(
  dashboardPage(
    dashboardHeader(title = 'Model Explorer'),
    dashboardSidebar(
      sidebarMenu(
        menuItem('Introduction', tabName = 'intro'),
        menuItem('Model Explorer', tabName = 'model'),
        menuItem('Model Detais', tabName = 'modelDetails'),
        menuItem('Conclusions', tabName = 'conclusions')
      )
    ),
    dashboardBody(tabItems(
      
      tabItem(tabName = 'intro', 
              mainPanel(style="text-align: center;",
                        
                        h2("Explorador de modelos"),
                        p("El objetivo de esta practica final de Shiny es que el usuario interactue en base a modelos polinomicos arbitrarios "),
                        p("Podemos elegir la correlacion de una normal multivariada. Ademas pulsando sobre la grafica podemos añadir nuevos puntos de datos"),
                        p("El modelo se muestra en la misma grafica, junto a los datos y cualquier cambio en los datos o en los modelos hace que se vuelva a ajustar "),
                        p("Se añaden unas pestañas en donde podemos ver la informacion estadistica"),
                        p("Esta informacion , en la pestaña model details, podemos ver los detalles de cada una de ellas, en donde la primera pestaña sera una vista general sobre la informacion estadistica generada por el modelo. La segunda seccion sera un analisis de los residuos, la tercera sera un analisis detallado de los mismos en donde se explique su capacidad predictora y finalmente la cuarta seccion sera un analisis de los outliers representados en forma de boxplot e histogramas. "),
                        p('A traves de cada generador y exploracion de los diferentes modelos que el usuario vaya seleccionando podemos ver la informacion estadisticamente significativa de cada uno de ellos')
                        
              )),
      
      tabItem(tabName = 'model',
              h2('Model Explorer'),
              h4('You can generate and explore a random model'),
              plotOutput('grafica'),
              uiOutput('uiModelExplorer')),
      
      tabItem(tabName = 'modelDetails',
              h2('Model Details'),
              h4('Details about generated model in first tab'),
              uiOutput('uiModelDetails')),
      
      tabItem(tabName = 'conclusions', h2('Conclusion y Referencias'),
              p('A traves de esta practica final de Tecnicas de Visualizacion he podido aprender a generar varios modelos, visualizar su correlacion en base a diferentes ordenes polinomicos y realizar un estudio estadistico sobre los residuos y los outliers de cada modelo generado arbitrariamente'),
              p('Debo decir que este trabajo final me ha supuesto un reto y a la vez una aventura. He aprendido bastante de como realizar un explorador de modelos pero sobre todo he aprendido a comprender en detalle lo que hay detras de la visualizacion y como cada variable esta interconectada con otro panel de cara a poder reflejar la informacion significativa con el objetivo de que el usuaio pueda interactuar con la aplicacion '),
              p('En cuanto a las referencias, esta ha sido la bibliografia que he ido utilizando a lo largo de esta practica final:'),
              p('- http://openaccess.uoc.edu/webapps/o2/bitstream/10609/81766/6/dpineyroTFM0618memoria.pdf'),
              p('- https://dlegorreta.wordpress.com/category/de-lo-concreto-a-lo-abstracto/exploracion-de-datos-y-data-analysis/'),
              p('-https://github.com/aviyashchin/Machine-Learning-Explorer-in-Shiny'),
              p('- https://rstudio.stat.washington.edu/shiny/wppExplorer/inst/explore/'),
              p('- https://master.bioconductor.org/help/course-materials/2015/CSAMA2015/lab/shiny.html'),
              p('-https://www.r-bloggers.com/shinyfit-advanced-regression-modelling-in-a-shiny-app/'),
              p('- https://github.com/mkearney/shinyapps_links'),
              p('-https://imdevsoftware.wordpress.com/2013/06/16/dynamic-plots-in-using-shiny-and-ggplot2/')
      ))
      
      
    ))
)
