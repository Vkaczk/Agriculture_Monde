# Étude des productions agricoles et de la faim dans le monde


## Table des matières

 - [Introduction](#Introduction)
 - [User's Guide](#users-guide)
 - [Developper's Guide](#developpers-guide)
 - [Rapport d'analyse](#rapport-danalyse)
 - [Liens des données](#lien-des-données)


# Introduction

Le but de ce dashboard est de mettre en relation la production agricole de chaque pays avec la faim dans le monde. Nous aimerions savoir si certains pays produisent suffisamment pour subvenir à leurs besoins sans pour autant y parvenir. Le cas échéant, cette incapacité témoignerait de fortes inégalités sociales au sein de ces pays.

# User’s Guide

Pour lancer l’application, il vous fait avoir téléchargé RStudio ainsi que le langage R.

Les packages nécessaires au bon fonctionnement de l’application sont les suivants :

 - tidyverse
 - shiny
 - shinydashboard
 - dplyr
 - ggplot2
 - rgdal
 - rworldmap
 - leaflet

Pour installer un package dans R, aller dans la console RStudio puis tapez la commande suivante : install.packages([package])

Pour lancer l’application, ouvrez le fichier server.R puis cliquez sur Run App en haut à droite. Celle-ci se lance dans une fenêtre dédiée. Vous pouvez aussi lancer celle-ci dans un navigateur en cliquant sur “open in browser” ou en allant à l’adresse affichée dans la console.

Le dashboard est composé de deux pages, une concernant l'agriculture dans le monde, l'autre la faim dans le monde.


# Developper's Guide    

## Traitement de la data
La data est entièrement traité dans Global.R. Nous commençons par créer le dataframe SAgricole à l’aide du csv Terre_agricole_km2.csv, un csv qui pour chaque pays  donne la superficie des terres agricoles dans la colonne année correspondante. Nous supprimons les colonnes vides de ce dataframe.
On crée ensuite dfPopulation, à l’aide du dataframe population_total.csv, Un csv qui nous donne la population de chaque pays dans la colonne année correspondante. On supprime également les colonnes non renseignées et on fait en sorte que les dataframes ait des colonnes identiques.
On créer ensuite un dataframe df comportant les colonnes pays, code pays, annee, superficie agricole et population qu’on rempli grâce à des boucles itératives et au deux autres dataframes.
Une fois le data frame df rempli. On créer la colonne Superficie_Agricole_Par_Habitant que l’on remplit.
on créer un dataframe df1 similaire a df moins les lignes ne correspondant pas à des pays, mais à des régions comme zone Europe ou Amérique latine.
On créer le csv dfRegion avec df et df avec df1.
Nous créons le dataframe dfHunger à l’aide du csv Hunger.csv, un csv qui pour chaque pays et chaque année nous donne l’indice de faim.
Nous créons une colonne ID dans les dataframes df et dfHunger. Cette colonne contient le code du pays suivi de l’année. Grâce à cette colonne, nous supprimons les lignes n'apparaissent dans aucun des deux csv. On les fusionne ensuite à l’aide de la fonction left_join. On renomme les colonnes dont les noms ont été modifiés et celle en trop, et on créer dfHunger.csv.

## Frontend
On a choisi pour traiter le layout, dans ui.R, d'utiliser shinydashboard. L'ensemble des inputs est placé dans la sidebar à l'exception du sélecteur de pays dans la page Agriculture. Pour faciliter l'affichage, nous avons choisi d'utiliser des fluidRow et des box.

## Backend
server.R regroupe l'ensemble des graphiques et des et des valueBox générés. Le dashboard contient deux histogrammes, un nuage de point ainsi que deux maps.

## Pistes d'amélioration
il serait intéressant d'ajouter les échanges internationaux ainsi que les inégalités sociales au sein d'un pays pour poursuivre cette étude. De plus, rajouter une page sur l'indice de développement humain pourrait permettre de mieux comprendre certaines inégalités au sein des pays et donc de mieux appréhender la situation.
De plus, l'importation des datas n'a pas pu se faire automatiquement et il faudrait rajouter cette fonctionnalité.
Enfin, certains pays comme la France ne sont pas comptés dans l'IFM empêchant les corrélations entre IFM et SAPH et donc d'avoir un étalon lors de l'étude des pays les moins avancés.

# Rapport d’analyse
L'objectif de ce dahboard était d'observer si l’on pouvait établir une corrélation entre les productions agricoles et l'indice de faim dans le monde (IFM). Pour cela, nous avons choisi d'étudier la superficie agricole par habitant afin de nous affranchir de variation due à la taille de la population.

## Résultats obtenus

### La superficie agricole par habitant
Nous avons pu observer que la superficie agricole par habitant (SAPH) variait en 0 et 0.4 Km²/hb. De plus, la majorité des pays avait une SAPH inférieure à 0.1Km²/hb. Quelques pays font exception à cette moyenne comme la Mongolie avec une SAPH de 0.36 Km²/hb. On remarque que des pays ne souffrant pas de la faim comme la France ou les États-Unis ont pour superficies respectives 0.004 Km²/hb et 0.017 Km²/hb.

### La faim dans le monde
Sans surprise, la faim frappe particulièrement les pays d'Afrique, mais aussi l'Asie, l'Amérique centrale et l'Amérique du Sud. Néanmoins, on peut observer que celle-ci est de moins en moins présente au cours des années. La moyenne de l'IFM, allant de 0 à 100 où 0 est l'absence de faim, à diminuer de 19.7 à 14.3 entre 2000 et 2016. De même, la médiane est passée de 16.55 à 9.85 montrant un réel recul de la faim dans le monde.

## Correlation, critiques et conclusion
Nous pouvons observer que certains pays comme la Mongolie qui montre une très grande SAPH voient leur IFM diminuer avec le temps. Cependant, d'autres pays comme l'Estonie voient aussi leur IFM s'atténuer en dépit d'un très faible SAPH. De plus, des pays comme le Brésil et la Russie se voient disparaître du classement IFM alors que la situation au Zimbabwe empire avec un IFM supérieur à 40 et en augmentation malgré une SAPH équivalente. Finalement, la corrélation entre IFM et SPAH semble très faible laissant supposer que les problèmes de famine sont majoritairement dus à des inégalités sociales ou à des échanges internationaux. il serait pertinent de poursuivre cette étude en ajoutant les échanges agroalimentaires internationaux.


# Lien des données

Les données proviennent de Our World In Data et de WorldBank et sont disponibles aux URL suivantes: <br>

 - Indice de faim dans le monde :<br>
https://ourworldindata.org/hunger-and-undernourishment#undernourishment-by-world-region

 - Population totale par pays :<br>
http://api.worldbank.org/v2/fr/indicator/SP.POP.TOTL?downloadformat=csv

-Terre agricole par pays :<br>
-http://api.worldbank.org/v2/fr/indicator/AG.LND.AGRI.K2?downloadformat=csv
