library(tidyverse)
library(shiny)
library(shinydashboard)
library(gapminder)
library(dplyr)
library(ggplot2)

library(ggmap)
library(rgdal)
library(dplyr)
library(rworldmap)

library(leaflet)



dashboardPage(
  skin='purple',
  dashboardHeader(title = "Dashboard",titleWidth = 350),

  dashboardSidebar(

      width = 350,
      sidebarMenu(
        menuItem("Agriculture", tabName = "Agri", icon = icon("tractor"),badgeColor = "olive"),
        sliderInput(inputId = "years",
                label = "Année : Agriculture dans le monde",
                min = 1961,
                max = 2016,
                step = 1,
                value = 2016,
                sep = "",
                width=340), #icon seeding dispo
        menuItem('Faim', tabName='Hunger', icon= icon("utensils"), badgeColor="olive"),
        selectInput(inputId="land",
                label = "Choix du pays",
                choices = df_hunger$pays,
                selected = "Afghanistan",
                multiple = TRUE,
                width=340),

        sliderInput(inputId = "years_hg",
                label = "Année : faim dans le monde",
                min = 2000,
                max = 2016,
                step = 1,
                value = 2016,
                sep = "",
                width=340)
      )
  ),

  dashboardBody(
    tabItems(
      tabItem(tabName='Agri',
          h2("Ressources agricoles mondiales"),

          fluidRow(
              box(
                title= 'Superficie agricole par habitant',
                status= 'success',
                solidHeader = TRUE,
                leafletOutput("map1")
              ),
              box(
                title= 'Superficie agricole par habitant',
                status= 'success',
                solidHeader = TRUE,
                plotOutput(outputId='hist')
              )
            ),
          h2("Superficie agricole"),
          selectInput(inputId="land1",
                  label = "Choix du pays",
                  choices = df$pays,
                  selected = "Afghanistan",
                  multiple = FALSE),
          fluidRow(
            valueBoxOutput("worldPlace"),
            valueBoxOutput("selectPlace"),
            valueBoxOutput("lastPlace")
          )
        ),
        tabItem(tabName='Hunger',

          h2("Faim dans le monde"),

          fluidRow(
              box(
                title= 'Indice de la faim dans le monde',
                status= 'danger',
                solidHeader = TRUE,
                leafletOutput("map2")
              ),
              box(
                title= 'Indice de la faim dans le monde',
                status= 'danger',
                solidHeader = TRUE,
                plotOutput(outputId='hist2')
              )
            ),
          fluidRow(
            valueBoxOutput("meanIFM"),
            valueBoxOutput("medianIFM"),
            valueBoxOutput("WorstIFM")
          ),

          fluidRow(
            box(
              title="Evolution de l'IFM par pays",
              status = 'danger',
              solidHeader=TRUE,
              plotOutput(outputId='scatter'),
              width = 12
            )
          ),
          fluidRow(
            box(
              title="Superficie agricole par habitant fonction de l'IFM",
              status = 'danger',
              solidHeader=TRUE,
              plotOutput(outputId='scatter2'),
              width = 12
            )
          )


        )
      )

  )
)
