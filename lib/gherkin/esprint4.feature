# S4_T01: Creació projectes
Feature: Nou projecte
  Scenario: Crear projecte bàsic
    Donat que necessito una reforma
    Quan omplo el formulari de nou projecte
    Llavors hauria de crear-se un nou projecte al sistema

# S4_T02: Llistat projectes
Feature: Veure projectes
  Scenario: Veure els meus projectes
    Donat que tinc projectes actius
    Quan accedeixo a "Els meus projectes"
    Llavors hauria de veure tots els meus projectes

# S4_T03: Detall projecte
Feature: Informació de projecte
  Scenario: Veure estat del projecte
    Donat que tinc un projecte en curs
    Quan accedeixo al seu detall
    Llavors hauria de veure el seu estat actual

# S4_T04: Xat de projecte
Feature: Comunicació
  Scenario: Enviar missatge
    Donat que estic en un projecte
    Quan envio un missatge pel xat
    Llavors el professional hauria de rebre'l

# S4_T05: Pujar imatges
Feature: Documents del projecte
  Scenario: Afegir imatge de referència
    Donat que estic en un projecte
    Quan pujo una foto
    Llavors hauria de veure's al taulell del projecte

# S4_T06: Notificacions
Feature: Alertes
  Scenario: Notificació d'actualització
    Donat que el professional actualitza l'estat
    Quan canvia a "En progrés"
    Llavors hauria de rebre una notificació

# S4_T07: Proves mòbil
Feature: Provar en dispositius
  Scenario: Provar en Android
    Donat que hem desenvolupat una funcionalitat
    Quan la provem en un dispositiu real
    Llavors hauria de funcionar correctament

# S4_T08: Correcció errors
Feature: Depuració
  Scenario: Solucionar bug crític
    Donat que s'ha detectat un error greu
    Quan el corregim
    Llavors hauria de deixar de produir-se

# S4_T09: Preparar demo
Feature: Demostració
  Scenario: Mostrar flux complet
    Donat que hem acabat el sprint
    Quan preparem la demo
    Llavors hauríem de poder mostrar tot el flux de projectes

# S4_T10: Documentació
Feature: Documentar gestió projectes
  Scenario: Actualitzar manual
    Donat que hem implementat el mòdul
    Quan actualitzem la documentació
    Llavors hauria d'explicar com gestionar projectes