#Package � installer pour compiler ce programme
#install.packages("tidyverse")
library(tidyverse)
library(dplyr)

######################################################################################################################################
#cr�ation du dataframe SAgricole qui donne la surface agricole par pays et par an
SAgricole <- read_csv('Data/Terre_agricole_km2.csv')
#suppression des colonnes indicator name, indicator code, 1960, 2017, 2018 et 2019 qui sont vide
SAgricole <- select(SAgricole, -c("Indicator Name", "Indicator Code", "1960","2017", "2018", "2019"))

#On renomme les colonnes du dataframe
SAgricole <- rename(SAgricole, 'pays'='Country Name')
SAgricole <- rename(SAgricole, 'code pays'='Country Code')

######################################################################################################################################
#cr�ation du dataframe dfPopulation qui donne la population des pays chaque ann�e
dfPopulation <- read_csv('Data/population_total.csv')

#suppression des colonnes indicator name, indicator code, 1960, 2017, 2018 et 2019 qui sont vide
dfPopulation <- select(dfPopulation, -c("Indicator Name", "Indicator Code", "1960","2017", "2018", "2019"))

#On renomme les colonnes du dataframe
dfPopulation <- rename(dfPopulation, 'pays'='Country Name')
dfPopulation <- rename(dfPopulation, 'code pays'='Country Code')

######################################################################################################################################
#On cr�er un nouveau dataframe avec les colonnes souhait�es
pays <- "pays"
code_pays <- "code_pays"
annee <- "annee"
superficie_agricole <- "superficie_agricole"
Population <- "population"
df <- data.frame(pays=character(),code_pays=character(),annee=integer(),superficie_agricole=double(),population=double(),stringsAsFactors=FALSE)

#On le rempli avec les donn�es de SAgricole et dfPopulation
rowAgricole <- rownames(SAgricole)
rowPopulation <- rownames(Population)
rowAnnee <- names(SAgricole)
SAgricole[rowAgricole,rowAnnee]
i = 1
j = 3
line = 1
while(i <= length(rowAgricole))
{
  while(j <= length(rowAnnee))
  {
    line = line +1
    df[line,] = c(SAgricole[i,1],SAgricole[i,2],rowAnnee[j],SAgricole[i,j],dfPopulation[i,j])
    j = j + 1
  }
  j = 3
  i = i + 1
}


######################################################################################################################################
#ajout de la colonne Superficie_Agricole_Par_Habitant � df
colonneSuperficieAgricole <- df[4]
colonnePopulation <- df[5]
SuperficieAgricoleParHabitant <- colonneSuperficieAgricole/colonnePopulation
df["Superficie_Agricole_Par_Habitant"] <- SuperficieAgricoleParHabitant

######################################################################################################################################
#On supprime les lignes qui ne sont pas des pays
df1 <- df %>% filter(df$pays != "Monde")
df1 <- df1 %>% filter(df1$pays != "Le monde arabe")
df1 <- df1 %>% filter(df1$pays != "�les Vierges (EU)")
df1 <- df1 %>% filter(df1$pays != "Asie du Sud (BIRD et IDA)")
df1 <- df1 %>% filter(df1$pays != "Revenu interm�diaire, tranche sup�rieure")
df1 <- df1 %>% filter(df1$pays != "Afrique subsaharienne (BIRD et IDA)")
df1 <- df1 %>% filter(df1$pays != "Afrique du Nord et Moyen-Orient (BIRD et IDA)")
df1 <- df1 %>% filter(df1$pays != "Am�rique latine et Cara�bes (BIRD et IDA)")
df1 <- df1 %>% filter(df1$pays != "Europe et Asie centrale (BIRD et IDA)")
df1 <- df1 %>% filter(df1$pays != "Asie de l'Est et Pacifique (BIRD et IDA)")
df1 <- df1 %>% filter(df1$pays != "Afrique subsaharienne")
df1 <- df1 %>% filter(df1$pays != "Afrique subsaharienne (hors revenu �lev�)")
df1 <- df1 %>% filter(df1$pays != "Asie du Sud")
df1 <- df1 %>% filter(df1$pays != "Petits �tats insulaires du Pacifique")
df1 <- df1 %>% filter(df1$pays != "de Pr�-dividende d�mographique")
df1 <- df1 %>% filter(df1$pays != "Autres petits �tats")
df1 <- df1 %>% filter(df1$pays != "Pays membres de l'OCDE")
df1 <- df1 %>% filter(df1$pays != "Afrique du Nord et Moyen-Orient (hors revenu �lev�)")
df1 <- df1 %>% filter(df1$pays != "Revenu interm�diaire")
df1 <- df1 %>% filter(df1$pays != "Afrique du Nord et Moyen-Orient")
df1 <- df1 %>% filter(df1$pays != "R�gion administrative sp�ciale de Macao, Chine")
df1 <- df1 %>% filter(df1$pays != "de dividende tardif d�mographique")
df1 <- df1 %>% filter(df1$pays != "Revenu faible et interm�diaire")
df1 <- df1 %>% filter(df1$pays != "Revenu interm�diaire, tranche inf�rieure")
df1 <- df1 %>% filter(df1$pays != "Faible revenu")
df1 <- df1 %>% filter(df1$pays != "Pays les moins avanc�s: classement de l'ONU")
df1 <- df1 %>% filter(df1$pays != "Am�rique latine et Cara�bes")
df1 <- df1 %>% filter(df1$pays != "BIRD et IDA")
df1 <- df1 %>% filter(df1$pays != "IDA totale")
df1 <- df1 %>% filter(df1$pays != "IDA m�lange")
df1 <- df1 %>% filter(df1$pays != "Am�rique latine et Cara�bes (hors revenu �lev�)")
df1 <- df1 %>% filter(df1$pays != "Non classifi�")
df1 <- df1 %>% filter(df1$pays != "IDA seulement")
df1 <- df1 %>% filter(df1$pays != "BIRD seulement")
df1 <- df1 %>% filter(df1$pays != "Pays pauvres tr�s endett�s (PPTE)")
df1 <- df1 %>% filter(df1$pays != "Chine, RAS de Hong Kong")
df1 <- df1 %>% filter(df1$pays != "R�publique centrafricaine")
df1 <- df1 %>% filter(df1$pays != "Europe centrale et les pays baltes")
df1 <- df1 %>% filter(df1$pays != "�les Anglo-Normandes")
df1 <- df1 %>% filter(df1$pays != "Petits �tats des Cara�bes")
df1 <- df1 %>% filter(df1$pays != "Asie de l'Est et Pacifique (hors revenu �lev�")
df1 <- df1 %>% filter(df1$pays != "de dividende pr�coce d�mographique")
df1 <- df1 %>% filter(df1$pays != "Asie de l'Est et Pacifique")
df1 <- df1 %>% filter(df1$pays != "Europe et Asie centrale (hors revenu �lev�)")
df1 <- df1 %>% filter(df1$pays != "Europe et Asie centrale")
df1 <- df1 %>% filter(df1$pays != "Zone euro")
df1 <- df1 %>% filter(df1$pays != "Union europ�enne")
df1 <- df1 %>% filter(df1$pays != "Fragile et les situations de conflit touch�es")
df1 <- df1 %>% filter(df1$pays != "Revenu �lev�")

######################################################################################################################################
#Cr�ation du fichier df.csv
write_csv(df1,'Data/df.csv')

#Cr�ation du fichier dfRegion.csv
write_csv(df,'Data/dfRegion.csv')

######################################################################################################################################
#cr�ation du dataframe dfHunger qui donne l'indice de faim par pays et par an.
df <- read_csv('Data/df.csv')
dfHunger <- read_csv('Data/Hunger.csv')

#On renomme les colonnes du dataframe
dfHunger <- rename(dfHunger, 'pays'='Entity')
dfHunger <- rename(dfHunger, 'annee'='Year')
dfHunger <- rename(dfHunger, 'code_pays'='Code')
dfHunger <- rename(dfHunger, 'indice_global_de_faim'='Suite of Food Security Indicators - Prevalence of undernourishment (percent) (3-year average) - 210041 - Value - 6121 - %')
######################################################################################################################################
#fusion de df et de Hunger
#On cr�er une colonne ID dans les deux dataframes
df$ID = paste0(df$code_pays,df$annee)
dfHunger$ID = paste0(dfHunger$code_pays,dfHunger$annee)

#on ne garde que les donn�es communes aux deux dataframes
x <- pull(dfHunger, ID)
df <- df[df$ID%in%x,]

x <- pull(df, ID)
dfHunger <- dfHunger[dfHunger$ID%in%x,]

#fusion
df <- left_join(df,dfHunger, by = "ID")

#mise en forme des colonnes fusionn�es
df <- select(df, -c("ID","pays.y","code_pays.y","annee.y"))
df <- rename(df, 'pays'='pays.x')
df <- rename(df, 'code_pays'='code_pays.x')
df <- rename(df, 'annee'='annee.x')

#Cr�ation du fichier dfHunger.csv
write_csv(df,'Data/dfHunger.csv')


#Ouverture des fichiers
df <- read_csv('Data/df.csv')
df <-na.omit(df)
df_hunger <- read_csv('Data/dfHunger.csv')
df1 <- read_csv('Data/dfRegion.csv')
