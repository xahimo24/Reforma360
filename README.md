# Reforma360 - Documentació del Projecte

## 📋 Taula de Continguts
- [Reforma360 - Documentació del Projecte](#reforma360---documentació-del-projecte)
  - [📋 Taula de Continguts](#-taula-de-continguts)
  - [🏗️ Descripció del Projecte](#️-descripció-del-projecte)
  - [🎯 Objectius](#-objectius)
    - [Per a Usuaris](#per-a-usuaris)
    - [Per a Professionals](#per-a-professionals)
    - [Tècnics](#tècnics)
  - [⚙️ Requisits](#️-requisits)
    - [Funcionals](#funcionals)
    - [No Funcionals](#no-funcionals)
  - [💻 Tecnologies](#-tecnologies)
  - [📂 Estructura del Projecte](#-estructura-del-projecte)
  - [🚀 Instal·lació](#-installació)

## 🏗️ Descripció del Projecte
Reforma360 és una aplicació multiplataforma desenvolupada amb Flutter que té com a objectiu connectar usuaris amb professionals del sector de les reformes. L'aplicació permet:

- Cercar i contractar professionals
- Gestionar projectes de reforma
- Comunicar-se directament amb els professionals
- Valorar els serveis rebuts

## 🎯 Objectius

### Per a Usuaris
- [x] Cercar professionals amb filtres avançats
- [x] Gestionar múltiples projectes
- [x] Sistema de valoracions i ressenyes

### Per a Professionals
- [x] Crear i mantenir perfils detallats
- [x] Rebre i gestionar sol·licituds
- [x] Comunicar-se amb els clients

### Tècnics
- [x] Arquitectura modular (Clean Architecture)
- [x] Compatibilitat multi-dispositiu
- [x] Integració amb Firebase

## ⚙️ Requisits

### Funcionals
| ID    | Descripció                          | Estat    |
|-------|-------------------------------------|----------|
| RF01  | Autenticació d'usuaris              | Implementat |
| RF02  | Cercador de professionals           | Implementat |
| RF03  | Gestió de projectes                 | En progrés |
| RF04  | Sistema de xat                      | Pendent |

### No Funcionals
| ID    | Descripció                          |
|-------|-------------------------------------|
| RNF01 | Rendiment en dispositius antics     |
| RNF02 | Suport multi-idioma                 |
| RNF03 | Accessibilitat                      |

## 💻 Tecnologies
```plaintext
Flutter 3.19.0 • channel stable
Firebase • Auth, Firestore, Storage
Riverpod 2.4.9 • Gestió d'estat
GoRouter 10.0.0 • Navegació
```
## 📂 Estructura del Projecte
lib/
├── src/
│   ├── core/          # Elements compartits
│   ├── data/          # Accés a dades
│   ├── domain/        # Lògica de negoci
│   └── presentation/  # Interfície d'usuari

## 🚀 Instal·lació
1. Clonar el repositori:
   git clone https://github.com/xahimo24/Reforma360
2. Instal·lar dependècies:
   flutter pub get
3. Executar l'aplicació:
   flutter run


> ℹ️ Documentació actualitzada el **{data}**