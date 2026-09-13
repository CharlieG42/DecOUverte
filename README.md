# DéCOuverte

Application Flutter (Windows + Android) de génération d'affiches pour l'initiation à la Course d'Orientation.

## Principe

L'application utilise un **template PDF vierge** (charte graphique seule, zones de texte vides) comme arrière-plan et superpose les zones éditables saisies par l'utilisateur.

```
PDF template vierge → rendu en image → overlay des zones éditables + QR code → PDF final A4
```

Cela garantit une fidélité pixel-perfect de la charte sans avoir à extraire ou recoder les éléments fixes (logo, fond, boussole, titre, accroche).

## Zones éditables

| Zone | Exemple |
|---|---|
| Date de l'événement | `> 4 OCTOBRE 2026 >` |
| Créneau horaire | `Horaire libre de 9h30 à 12h` |
| Lieu | `SAINT-HAON-LE-CHÂTEL` |
| Type d'événement | `Circuits urbains de débutants à confirmés` |
| Public concerné | `Circuit enfants à partir de 4 ans` |
| Lien d'inscription | `www.crra.run` (+ QR code généré) |
| Contacts téléphoniques | `07.79.61.34.45` / `06.86.57.76.22` |

## Template PDF

Le fichier `assets/templates/template_vierge.pdf` doit être fourni :
- A4 portrait (210 × 297 mm)
- Charte graphique complète (logo, fond, boussole, titre, accroche)
- Zones éditables **vides** (pas de texte date/lieu/etc.)

Les coordonnées des zones éditables sont définies dans `lib/constants.dart` (en % de la page) et doivent être calibrées sur le template.

## Pré-requis

- Flutter SDK >= 3.4.0
- Police Google Fonts : **Nunito** (Regular + Bold) à télécharger dans `fonts/`
- Template PDF vierge dans `assets/templates/template_vierge.pdf`

## Dépendances clés

| Package | Rôle |
|---|---|
| `pdfrx` | Rendu du PDF template en image (déjà utilisé dans OWildZimut) |
| `pdf` | Génération du PDF final (overlay texte sur image de fond) |
| `qr_flutter` | QR code pour l'aperçu écran |
| `pretty_qr` | QR code PNG pour le PDF |
| `share_plus` | Partage du PDF généré |
| `intl` | Formatage date en français |

## Build

```bash
flutter pub get
flutter run -d windows    # ou -d android
```

## Structure du projet

```
lib/
├── main.dart                      # Point d'entrée + thème
├── constants.dart                  # Coordonnées des zones éditables (% de page)
├── models/
│   └── event_data.dart             # Modèle des 7 zones (JSON sérialisable)
├── services/
│   ├── template_renderer.dart      # Rendu PDF template → image (pdfrx)
│   ├── poster_generator.dart       # Overlay texte + QR sur template → PDF final
│   └── qr_generator.dart           # QR code PNG
├── screens/
│   ├── form_screen.dart            # Formulaire de saisie
│   └── preview_screen.dart         # Aperçu + génération + partage
├── widgets/
│   └── poster_canvas.dart          # Aperçu écran (même layout que le PDF)
└── utils/
    └── formatters.dart             # Date FR, téléphone, URL
```

## Multi-affiches

Chaque affiche est un `EventData` sérialisable en JSON. On peut :
- Créer une nouvelle affiche depuis le formulaire
- Recharger une affiche existante (`.json`)
- Modifier les paramètres et régénérer le PDF

Pour changer de charte graphique : remplacer le PDF template + recalibrer les coordonnées dans `constants.dart`.
