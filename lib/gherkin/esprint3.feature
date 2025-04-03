# S3_T01: Llistat professionals
Feature: Visualització de professionals
  Scenario: Veure llistat complet
    Donat que estic a la pantalla principal
    Quan accedeixo a "Professionals"
    Llavors hauria de veure tots els professionals disponibles

# S3_T02: Targetes de perfil
Feature: Presentació de professionals
  Scenario: Veure informació bàsica
    Donat que estic veient un professional
    Quan miro la seva targeta
    Llavors hauria de veure foto, nom i valoració

# S3_T03: Filtres
Feature: Filtrar professionals
  Scenario: Filtrar per especialitat
    Donat que necessito un electricista
    Quan selecciono "Electricitat" als filtres
    Llavors només hauria de veure professionals d'aquesta especialitat

# S3_T04: Detall professional
Feature: Perfil complet
  Scenario: Veure informació detallada
    Donat que estic interessat en un professional
    Quan clico a la seva targeta
    Llavors hauria de veure la seva informació completa

# S3_T05: Valoracions
Feature: Sistema de valoracions
  Scenario: Valorar un professional
    Donat que he contractat un servei
    Quan li doneu una puntuació de 4 estrelles
    Llavors aquesta valoració hauria de reflectir-se al seu perfil

# S3_T06: Edició perfil
Feature: Actualització de perfil
  Scenario: Actualitzar informació
    Donat que sóc un professional
    Quan edito el meu perfil
    Llavors els canvis haurien de guardar-se correctament

# S3_T07: Base de dades
Feature: Connectar amb Firestore
  Scenario: Carregar dades
    Donat que estic a la pantalla de professionals
    Quan s'obre l'aplicació
    Llavors hauria de carregar les dades des de la base de dades

# S3_T08: Cerca
Feature: Cerca de professionals
  Scenario: Trobar per nom
    Donat que record el nom d'un professional
    Quan el busco a la barra de cerca
    Llavors hauria de trobar-lo si existeix

# S3_T09: Dades mock
Feature: Proves amb dades simulades
  Scenario: Visualitzar sense connexió
    Donat que no tinc connexió
    Quan accedeixo als professionals
    Llavors hauria de veure dades de prova

# S3_T10: Documentació
Feature: Documentar gestió professionals
  Scenario: Actualitzar manual
    Donat que hem acabat el mòdul
    Quan actualitzem la documentació
    Llavors hauria d'incloure com gestionar professionals

# S3_T11: Presentació
Feature: Mostrar avenços
  Scenario: Demostrar funcionalitats
    Donat que hem completat el sprint
    Quan presentem a classe
    Llavors hauríem de poder mostrar tot el que funciona