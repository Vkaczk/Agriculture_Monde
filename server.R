library(tidyverse)
library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(gapminder)
#library(ggmap)
library(rgdal)
library(rworldmap)

library(leaflet)


function(input, output) {

  output$hist <- renderPlot({
    df_rounded <- df
    df_rounded$Superficie_Agricole_Par_Habitant <- round(df_rounded$Superficie_Agricole_Par_Habitant,5)
    df_grouped  <-df_rounded %>% group_by(Superficie_Agricole_Par_Habitant)
    df_count <- df_grouped %>% count(Superficie_Agricole_Par_Habitant, annee, sort=TRUE)
    ggplot(filter(df_count,annee==input$years), aes(x = Superficie_Agricole_Par_Habitant)) +
      geom_histogram(aes(color = n), fill = "#0F7B2A") +
      labs(y="Nombre de pays", x = "Superficie Agricole Par Habitant (Km²/hb)")
  })

  output$map1 <- renderLeaflet({
      data <- joinCountryData2Map(filter(df,annee==input$years),joinCode="ISO3",nameJoinColumn = "code_pays")
      bins1 <- c(0,0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08,0.09,0.1,0.2,0.3,1)
      pal <- colorBin("Greens", domain = data, bins = bins1)
      label <- sprintf("<strong>%s</strong><br/> Km2 / habitant: %g ",data$pays, data$Superficie_Agricole_Par_Habitant) %>% lapply(htmltools::HTML)
      leaflet()%>%
      #fitBounds(-90, -50, 90, 80)%>%
      addTiles()%>%
      setView(66.9022635,35.193764,zoom=1)%>%
      addPolygons(data= data,
                  fillColor= ~pal(Superficie_Agricole_Par_Habitant),
                  weight = 2,
                  opacity = 1,
                  color = "white",
                  dashArray = "3",
                  fillOpacity = 0.7,
                  highlight = highlightOptions(
                    weight = 5,
                    color = "#666",
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  label = label,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto")
      )%>%
      addLegend("bottomright",
                pal = pal,
                values = df$Superficie_Agricole_Par_Habitant,
                title = 'Superficie par habitant',
                labFormat = labelFormat(suffix = " Km²/hb")
      )
  })
  output$worldPlace <- renderValueBox({
    valueBox(
      "Monde",
      paste(round(filter(filter(df1,annee==input$years),pays=='Monde')$superficie_agricole,2),'Km²'),
      icon = icon("globe", lib = "glyphicon"),
      color = "blue"
    )
  })


  output$selectPlace <- renderValueBox({
    country <- 'Aucun pays selectionné'
    surface <- '0 Km²'
    if (input$land1 != ""){
      country <- filter(filter(df,annee==input$years),pays==input$land1)$pays %>% str_trunc(25)
      print(filter(filter(df,annee==input$years),pays==input$land1)$pays)
      surface <- paste(round(filter(filter(df,annee==input$years),pays==input$land1)$superficie_agricole,2),'Km²')
      if (surface == ' Km²'){
        country <- 'Pays indisponible'
        surface <- '0 Km²'
      }
    }
    valueBox(
      country,
      surface,
      icon = icon("flag", lib = "glyphicon"),
      color = "green"
    )
  })

  output$lastPlace <- renderValueBox({
    valueBox(
      filter(df,annee==input$years)$pays[which.min(filter(df,annee==input$years)$superficie_agricole)],
      paste(round(min(filter(df,annee==input$years)$superficie_agricole),2),'Km²'),
      icon = icon("thumbs-down", lib = "glyphicon"),
      color = "red"
    )
  })

  output$hist2 <- renderPlot({
    target <- c(input$land)
    df_groupedh  <-filter(df_hunger,pays %in% target) %>% group_by(indice_global_de_faim)
    df_counth <- df_groupedh %>% count(indice_global_de_faim, annee, pays,sort=TRUE)
    ggplot(filter(df_counth,annee==input$years_hg), aes(x = indice_global_de_faim)) +
      geom_histogram(aes(color = pays), fill = "#E96D6D") +
      #scale_color_brewer(palette="Reds") +
      labs(y="Nombre de pays", x = "Superficie Agricole Par Habitant (Km²/hb)")
  })

  output$map2 <- renderLeaflet({
      data <- joinCountryData2Map(filter(df_hunger,annee==input$years_hg),joinCode="ISO3",nameJoinColumn = "code_pays")
      bins2 <- c(0,10,20,30,40,50,60,70)
      pal <- colorBin("Reds", domain = data, bins = bins2)
      label <- sprintf("<strong>%s</strong><br/> IFM  %g",data$pays, data$indice_global_de_faim) %>% lapply(htmltools::HTML)
      leaflet()%>%
      #fitBounds(-90, -50, 90, 80)%>%
      addTiles()%>%
      setView(10.0318194999999832,0,zoom=2)%>%
      addPolygons(data= data,
                  fillColor= ~pal(indice_global_de_faim),
                  weight = 2,
                  opacity = 1,
                  color = "white",
                  dashArray = "3",
                  fillOpacity = 0.7,
                  highlight = highlightOptions(
                    weight = 5,
                    color = "#666",
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  label = label,
                  labelOptions = labelOptions(
                    style = list("font-weight" = "normal", padding = "3px 8px"),
                    textsize = "15px",
                    direction = "auto")
      )%>%
      addLegend("bottomright",
                pal = pal,
                values = df_hunger$indice_global_de_faim,
                title = 'Indice de la faim dans le monde'
      )
  })
  output$meanIFM <- renderValueBox({
    valueBox(
      paste("Moyenne :",round(mean(filter(df_hunger,annee==input$years_hg)$indice_global_de_faim),1)),
      "Indice de faim",
      icon = icon("calculator"),
      color = "yellow"
    )
  })

  output$medianIFM <- renderValueBox({
    valueBox(
      paste("Médianne :",median(filter(df_hunger,annee==input$years_hg)$indice_global_de_faim)),
      "Indice de faim",
      icon = icon("calculator"),
      color = "orange"
    )
  })

  output$WorstIFM <- renderValueBox({
    valueBox(
      filter(df_hunger,annee==input$years)$pays[which.min(filter(df_hunger,annee==input$years)$indice_global_de_faim)],
      paste('IDF =',min(filter(df_hunger,annee==input$years)$indice_global_de_faim)),
      icon = icon("thumbs-down", lib = "glyphicon"),
      color = "red"
    )
  })

  output$scatter <- renderPlot({
    target <- c(input$land)
    ggplot(filter(df_hunger,pays %in% target),aes(x=annee,y=indice_global_de_faim,color=pays)) +
    geom_point(aes(size=Superficie_Agricole_Par_Habitant),alpha=0.5) +
    geom_smooth(method=lm, se=FALSE, fullrange=TRUE) +
    geom_rug() +
    #scale_color_brewer(palette="Reds") +
    labs(y="IFM", x = "Années", color='Pays',size ='Superficie agricole par habitant')
  })

  output$scatter2 <- renderPlot({
    ggplot(filter(df_hunger,annee==input$years_hg),aes(x=indice_global_de_faim,Superficie_Agricole_Par_Habitant,color=pays)) +
    geom_point(alpha=0.5) +
    labs(y='SAPH',x='IFM')
  })

}

# Run the application
#shinyApp(ui = ui, server = server)
