# DéCOuverte

Application Flutter (Windows + Android) de génération d'affiches pour l'initiation à la Course d'Orientation.

## Fonctionnement

L'utilisateur saisit les paramètres d'un événement via un formulaire, visualise l'affiche en aperçu, puis génère un PDF A4 prêt à imprimer.

## Zones éditables

- Date de l'événement
- Créneau horaire
- Lieu
- Type d'événement
- Public concerné
- Lien d'inscription (+ QR code généré dynamiquement)
- Contacts téléphoniques (1 à 2 numéros)

## Charte graphique

Les éléments fixes (logo, image de fond, boussole, titre, accroche) sont codés en dur et non modifiables. La palette et les polices (Comfortaa + Nunito) garantissent la cohérence entre toutes les affiches.

## Pré-requis

- Flutter SDK >= 3.4.0
- Polices Google Fonts : Comfortaa (Bold) et Nunito (Regular + Bold) à télécharger dans `fonts/`
- Assets dans `assets/charter/` : logo_crra.jpeg, background_runners.jpeg, compass_rose.jpeg

## Build

```bash
flutter pub get
flutter run -d windows    # ou -d android
```
