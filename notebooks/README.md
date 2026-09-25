# Databricks Notebooks

Ce dossier contient les notebooks Databricks utilisés pour les transformations de l'architecture Medallion (Bronze → Silver → Gold) du projet **Gender-Based Sales KPI Dashboard**.

## Contenu du dossier

| Fichier | Description | Couche |
| :--- | :--- | :--- |
| `02_bronze_to_silver.ipynb` | Nettoyage, typage et validation des données brutes (Bronze → Silver) | Silver |
| `03_silver_to_gold.ipynb` | Agrégation des ventes par genre, année et catégorie (Silver → Gold) | Gold |

## Architecture Medallion
'''
Source (SQL Server)
│
▼
┌──────────────┐
│ BRONZE │ Données brutes (Parquet)
│ (ADLS Gen2) │
└──────┬───────┘
│
▼
┌──────────────┐
│ SILVER │ Données nettoyées et typées
│ (Databricks)│
└──────┬───────┘
│
▼
┌──────────────┐
│ GOLD │ Agrégats (ventes par genre, année, catégorie)
│ (Databricks)│
└──────┬───────┘
│
▼
Power BI (Dashboard)
'''

## Technologies utilisées

- **Azure Databricks** : Transformation et agrégation
- **PySpark** : Traitement distribué des données
- **Delta Lake / Parquet** : Format de stockage
- **Azure Data Lake Storage Gen2** : Stockage des couches Bronze, Silver, Gold

## Comment exécuter les notebooks

1. Importer les notebooks dans un workspace Databricks
2. Attacher un cluster avec Spark 3.x
3. Exécuter `02_bronze_to_silver.ipynb` en premier
4. Puis exécuter `03_silver_to_gold.ipynb`
5. Les résultats sont écrits dans les conteneurs `silver/` et `gold/` du Storage Account

## Auteur

**Hicham ERRIHANI** — Data Engineer / Data Analyst

