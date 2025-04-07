# 📱 Reforma360  
*Aplicació per a la gestió i contractació de professionals de reformes*  

## **📌 Descripció**  
Reforma360 és una aplicació multiplataforma (mòbil i escriptori) desenvolupada en **Flutter** que connecta usuaris amb professionals del sector de les reformes. Els usuaris poden buscar, contractar i gestionar projectes, mentre que els professionals poden mostrar els seus serveis i rebre valoracions.  

---

## **🎯 Objectius Principals**  
✔ **Per a Usuaris (Clients):**  
- Cercar professionals amb filtres (especialitat, ubicació, valoracions)  
- Gestionar projectes (crear, seguir-ne el progrés, xatejar)  
- Valorar els professionals contractats  

✔ **Per a Professionals:**  
- Mostrar el seu perfil i treballs anteriors  
- Rebre sol·licituds de projectes  
- Gestionar múltiples projectes simultàniament  

✔ **Tècnics:**  
- Arquitectura modular (**Clean Architecture + Riverpod**)  
- Compatibilitat amb **Android, iOS, Windows i macOS**  
- Integració amb **Firebase** (Auth, Firestore, Storage)  

---

## **⚙️ Requisits Tècnics**  

### **📋 Funcionals**  
| ID | Descripció | Prioritat |  
|----|------------|-----------|  
| RF01 | Sistema d'autenticació (email/google) | Alta |  
| RF02 | Cercador de professionals amb filtres | Alta |  
| RF03 | Gestió de projectes (crear/editar/eliminar) | Alta |  
| RF04 | Xat integrat entre usuari i professional | Mitjana |  
| RF05 | Sistema de valoracions (1-5 estrelles) | Mitjana |  

### **🔧 No Funcionals**  
| ID | Descripció |  
|----|------------|  
| RNF01 | Rendiment fluid en dispositius antics |  
| RNF02 | Internacionalització (català/castellà/anglès) |  
| RNF03 | Accesibilitat (contrast de colors, mida de text) |  

---

## **🛠️ Tecnologies**  
- **Frontend**: Flutter 3.19  
- **Backend**: Firebase (Auth, Firestore, Storage)  
- **Estat**: Riverpod 2.0  
- **Navegació**: GoRouter  
- **Test**: flutter_test + Mockito  

---

## **📂 Estructura del Projecte**  
lib/
├── src/
│ ├── core/ # Constants, errors, routes
│ ├── data/ # Models, repositoris, fonts de dades
│ ├── domain/ # Entitats, casos d'ús
│ └── presentation/ # Pantalles, widgets

Copy

---

## **🚀 Començar**  

### **Prerequisits**  
- Flutter 3.19+  
- Android Studio/Xcode (per a builds natives)  
- Compte de Firebase  

### **Executar el Projecte**  
bash  
flutter pub get  
flutter run  

### **Configurar Firebase**
Afegir els fitxers de configuració (google-services.json i GoogleService-Info.plist)

Habilitar Auth i Firestore a la consola de Firebase

### 🤝 Contribucions
Fer un fork del projecte

Crear una branca (git checkout -b feature/nova-funcionalitat)

Fer commit dels canvis (git commit -m 'Afegit login')

Fer push a la branca (git push origin feature/nova-funcionalitat)

Obrir un Pull Request

### 📜 Llicència
MIT

✍️ Equip de desenvolupament

Bilal ElArbi

Xavier Hidalgo


> ℹ️ Documentació actualitzada el **{data}**