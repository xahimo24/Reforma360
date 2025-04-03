# S2_T01: Pantalla de login
Feature: Autenticació
  Scenario: Login amb credencials correctes
    Donat que sóc un usuari registrat
    Quan introdueixo email i contrasenya correctes
    Llavors hauria d'accedir a l'aplicació

# S2_T02: Pantalla de registre
Feature: Registre d'usuaris
  Scenario: Registre amb dades vàlides
    Donat que sóc un nou usuari
    Quan omplo tots els camps requerits correctament
    Llavors hauria de rebre un correu de confirmació

# S2_T03: Recuperació contrasenya
Feature: Recuperació de contrasenya
  Scenario: Sol·licitud de recuperació
    Donat que he oblidat la meva contrasenya
    Quan introdueixo el meu email registrat
    Llavors hauria de rebre un enllaç per restablir-la

# S2_T04: Navegació principal
Feature: Navegació entre pantalles
  Scenario: Anar a pantalla de perfil
    Donat que estic a la pantalla principal
    Quan clico a "El meu perfil"
    Llavors hauria de veure la meva informació personal

# S2_T05: Menú lateral
Feature: Menú d'opcions
  Scenario: Accés al menú
    Donat que estic a qualsevol pantalla
    Quan desplego el menú lateral
    Llavors hauria de veure totes les opcions principals

# S2_T06: Persistència sessió
Feature: Mantenir sessió
  Scenario: Recordar usuari
    Donat que he iniciat sessió anteriorment
    Quan torno a obrir l'aplicació
    Llavors hauria de romandre autenticat

# S2_T07: Validació formularis
Feature: Validació de dades
  Scenario: Email invàlid
    Donat que estic al formulari de registre
    Quan introdueixo un email mal formatit
    Llavors hauria de veure un missatge d'error

# S2_T08: Errors autenticació
Feature: Gestió d'errors
  Scenario: Contrasenya incorrecta
    Donat que introdueixo una contrasenya errònia
    Quan intento iniciar sessió
    Llavors hauria de veure un missatge clar d'error

# S2_T09: Perfil d'usuari
Feature: Gestió de perfil
  Scenario: Veure perfil
    Donat que he iniciat sessió
    Quan accedeixo a la meva pàgina de perfil
    Llavors hauria de veure la meva informació personal

# S2_T10: Mode clar/fosc
Feature: Temes d'interfície
  Scenario: Canviar a mode fosc
    Donat que estic a la configuració
    Quan selecciono "Mode fosc"
    Llavors la interfície hauria de canviar a colors foscos

# S2_T11: Control de versions
Feature: Actualització de codi
  Scenario: Pujar canvis
    Donat que he fet modificacions al codi
    Quan executo git push
    Llavors els canvis haurien de pujar al repositori remot

# S2_T12: Documentació
Feature: Documentar autenticació
  Scenario: Actualitzar documentació
    Donat que hem implementat la funcionalitat
    Quan actualitzem el README
    Llavors hauria d'incloure instruccions d'autenticació