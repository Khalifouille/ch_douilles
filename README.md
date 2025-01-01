# Gestion des Douilles pour FiveM

Ce script permet d'ajouter une fonctionnalité immersive de gestion des douilles dans votre serveur FiveM. Lorsqu'un joueur tire avec une arme, des douilles avec des numéros de série uniques sont générées et peuvent être récupérées.

## Fonctionnalités

- **Génération des Douilles :**
  - Une douille est générée toutes les 12 balles tirées.
  - Chaque douille possède un numéro de série unique généré aléatoirement.
  
- **Affichage des Douilles :**
  - Lorsque le joueur vise avec une lampe torche, les douilles proches s'affichent avec leur numéro de série.

- **Récupération des Douilles :**
  - Les joueurs peuvent interagir avec les douilles pour les ramasser.
  - Le serveur vérifie la capacité d'inventaire avant d'ajouter la douille.

## Configuration

### Requis

- **FiveM** avec CitizenFX.
- **ox_inventory** pour la gestion des items.

### Dépendances

- Le script utilise les fonctions natives de FiveM, ainsi que l'exportation `CanCarryItem` et `AddItem` d'`ox_inventory`.

## Installation

1. **Téléchargement :**
   - Clonez ou téléchargez le dépôt sur votre machine.

2. **Ajout au serveur :**
   - Placez les fichiers `client.lua` et `server.lua` dans un dossier sous `resources/`.

3. **Activation :**
   - Ajoutez le dossier au fichier `server.cfg` :
     ```plaintext
     ensure NomDuDossier
     ```

4. **Vérification des dépendances :**
   - Assurez-vous qu'`ox_inventory` est installé et fonctionnel sur votre serveur.

## Utilisation

- Les joueurs peuvent tirer avec une arme pour générer des douilles.
- Utilisez une lampe torche pour afficher les douilles à proximité.
- Approchez-vous d'une douille et appuyez sur `E` pour la récupérer.

## Personnalisation

### Ajout de nouvelles armes

Pour ajouter des armes supplémentaires dans la reconnaissance des douilles, modifiez la table `WEAPON_HASHES` dans `client.lua` :
```lua
WEAPON_HASHES = {
    ["Pistolet"] = GetHashKey("WEAPON_PISTOL"),
    ["Lampe Torche"] = GetHashKey("WEAPON_FLASHLIGHT"),
    ["Votre Arme"] = GetHashKey("NOM_DE_L_ARME"),
}
