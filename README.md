# 🎯 Gender-Based Sales KPI Dashboard

> End-to-end Data Engineering & BI project on Azure — Medallion Architecture (Bronze/Silver/Gold) with ADF, Databricks, Synapse, and Power BI.

[![Azure](https://img.shields.io/badge/Azure-0078D4?style=flat&logo=microsoft-azure&logoColor=white)](https://azure.microsoft.com/)
[![Databricks](https://img.shields.io/badge/Databricks-FF3621?style=flat&logo=databricks&logoColor=white)](https://databricks.com/)
[![Synapse](https://img.shields.io/badge/Synapse%20Analytics-0078D4?style=flat&logo=microsoft-azure&logoColor=white)](https://azure.microsoft.com/en-us/products/synapse-analytics)
[![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=flat&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)

---

## 📋 Contexte métier

Une entreprise de vente au détail souhaite comprendre le comportement d'achat de ses clients selon leur **genre** pour adapter ses campagnes marketing et son catalogue produit.

**Problème** : Les données de ventes sont dispersées dans une base SQL Server on-premise, sans vision consolidée par genre.

**Solution** : Construire un pipeline de données end-to-end sur Azure suivant l'architecture Medallion, avec modélisation dimensionnelle (Star Schema) et exposition via Power BI.

---

## 🏗️ Architecture

```
┌─────────────────────┐
│ SQL Server │ Source on-premise
│ (AdventureWorks) │
└──────────┬──────────┘
│ Self-Hosted Integration Runtime
▼
┌─────────────────────┐
│ Azure Data Factory │ Ingestion metadata-driven (ForEach)
│ pipeline: pl_copy │
└──────────┬──────────┘
│
▼
┌─────────────────────┐
│ ADLS Gen2 (Bronze) │ Données brutes (Parquet)
│ stgendersaleshicham│
└──────────┬──────────┘
│
▼
┌─────────────────────┐
│ Azure Databricks │ Nettoyage + Typage + Validation
│ (Silver layer) │
└──────────┬──────────┘
│
▼
┌─────────────────────┐
│ Azure Databricks │ Agrégation + Star Schema
│ (Gold layer) │
└──────────┬──────────┘
│
▼
┌─────────────────────┐
│ Synapse Serverless │ Exposition SQL (T-SQL)
│ (SQL Pool) │
└──────────┬──────────┘
│
▼
┌─────────────────────┐
│ Power BI │ Dashboard + RLS
└─────────────────────┘

```


---

## 🏛️ Architecture Decisions (ADR)

### ADR-001 : Pourquoi une architecture Medallion ?

| Aspect | Décision |
| :--- | :--- |
| **Contexte** | Données sources hétérogènes, qualité variable |
| **Décision** | 3 couches : Bronze (raw), Silver (clean), Gold (aggregated) |
| **Justification** | Séparation des responsabilités, traçabilité, réutilisabilité |
| **Alternatives rejetées** | ETL monolithique, Data Vault (sur-dimensionné) |

### ADR-002 : Pourquoi ADF pour l'ingestion et Databricks pour la transformation ?

| Aspect | Décision |
| :--- | :--- |
| **Décision** | ADF → ingestion, Databricks → transformation |
| **Justification** | ADF simplifie la connexion on-premise (Self-Hosted IR). Databricks est optimisé pour le traitement distribué (PySpark). |
| **Alternatives rejetées** | Tout faire dans ADF (limité en transformation), tout faire dans Databricks (plus complexe pour l'ingestion) |

### ADR-003 : Pourquoi Synapse Serverless plutôt que Dedicated Pool ?

| Aspect | Décision |
| :--- | :--- |
| **Décision** | Synapse Serverless SQL Pool |
| **Justification** | Pay-per-query, pas de cluster à provisionner, adapté à un projet portfolio |
| **Alternatives rejetées** | Dedicated Pool (coût élevé, ~1,20 $/heure) |

---

## 🛠️ Stack technique

| Composant | Service Azure | Rôle |
| :--- | :--- | :--- |
| **Ingestion** | Azure Data Factory | Pipeline metadata-driven avec ForEach |
| **Connectivité** | Self-Hosted Integration Runtime | Connexion SQL Server on-premise |
| **Stockage** | ADLS Gen2 | Conteneurs `bronze/`, `silver/`, `gold/` |
| **Transformation** | Azure Databricks (PySpark) | Nettoyage, typage, agrégation |
| **Exposition** | Synapse Serverless SQL | Vues T-SQL sur la couche Gold |
| **Sécurité** | Azure Key Vault | Stockage des secrets |
| **Gouvernance** | RBAC, Unity Catalog, RLS | Contrôle d'accès |
| **Visualisation** | Power BI | Dashboard interactif |

---

## 📐 Modélisation dimensionnelle (Gold Layer)

### Star Schema

**Table de faits** : `FactInternetSales`

**Dimensions** :
- `DimCustomer` (Gender, YearlyIncome, Geography)
- `DimProduct` (Category, Subcategory)
- `DimDate` (Year, Quarter, Month)
- `DimGeography` (Country, City)

### Mesures DAX clés

```dax
Total Sales = SUM(FactInternetSales[SalesAmount])

Sales by Gender = 
CALCULATE(
    [Total Sales],
    USERELATIONSHIP(DimCustomer[Gender], DimCustomer[Gender])
)

YoY Growth = 
DIVIDE(
    [Total Sales],
    [Total Sales LY]
) - 1
```
✅ Qualité des données
Contrôle	Couche	Règle
Unicité	Bronze	Pas de doublons sur CustomerKey
Complétude	Silver	Gender non null et dans {M, F}
Validité	Silver	SalesAmount > 0
Cohérence	Gold	Somme des ventes par genre = total
🔐 Sécurité et Gouvernance
RBAC (Role-Based Access Control)
adf_user : db_datareader sur AdventureWorksDW2022

databricks_sp : accès aux conteneurs bronze/silver/gold via Unity Catalog

powerbi_user : accès en lecture seule à la couche Gold

Unity Catalog (Databricks)
Catalogue : gender_sales_catalog

Schémas : bronze, silver, gold

Grants : SELECT sur gold.* pour les analystes

Row-Level Security (Power BI)
Rôle : RegionManager

Filtre DAX : [Country] = LOOKUPVALUE(...)

Azure Key Vault
Secret : sql-adf-password (mot de passe SQL pour ADF)

Aucun secret n'est stocké dans le code source

📊 Résultats clés
Métrique	Valeur
Ventes totales (dataset complet)	$22.19 M
Ventes filtrées (via RLS)	$6.90 M
Nombre de clients	18 484
Nombre de produits	606
Période analysée	2010 - 2014
📁 Structure du projet
```
