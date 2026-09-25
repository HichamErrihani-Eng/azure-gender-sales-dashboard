# 🎯 Gender-Based Sales KPI Dashboard

> End-to-end Data Engineering project on Azure following the **Medallion Architecture (Bronze → Silver → Gold)**, analyzing sales data by customer gender.

[![Azure](https://img.shields.io/badge/Azure-0078D4?style=flat&logo=microsoft-azure&logoColor=white)](https://azure.microsoft.com/)
[![Databricks](https://img.shields.io/badge/Databricks-FF3621?style=flat&logo=databricks&logoColor=white)](https://databricks.com/)
[![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=flat&logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)

---

## 📋 Contexte métier

Une entreprise de vente au détail souhaite mieux comprendre le comportement d'achat de ses clients selon leur **genre** afin d'adapter ses campagnes marketing et son catalogue produit.

**Problème** : Les données de ventes sont dispersées dans une base SQL Server on-premise, sans vision consolidée par genre.

**Solution** : Construire un pipeline de données end-to-end sur Azure qui :
1. Ingère les données brutes depuis SQL Server
2. Les nettoie et les valide (couche Silver)
3. Les agrège par genre, année et catégorie (couche Gold)
4. Expose les résultats via un dashboard Power BI

---

## 🏗️ Architecture
```
┌─────────────────────┐
│ SQL Server │ Source on-premise
│ (AdventureWorks) │
└──────────┬──────────┘
│
▼
┌─────────────────────┐
│ Azure Data Factory │ Ingestion (Self-Hosted IR)
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
│ Azure Databricks │ Nettoyage + Typage
│ (Silver layer) │
└──────────┬──────────┘
│
▼
┌─────────────────────┐
│ Azure Databricks │ Agrégation (par genre)
│ (Gold layer) │
└──────────┬──────────┘
│
▼
┌─────────────────────┐
│ Power BI │ Dashboard final
└─────────────────────┘

```

---

## 🛠️ Stack technique

| Composant | Service Azure | Rôle |
| :--- | :--- | :--- |
| **Ingestion** | Azure Data Factory | Pipeline metadata-driven avec ForEach |
| **Connectivité** | Self-Hosted Integration Runtime | Connexion au SQL Server on-premise |
| **Stockage** | ADLS Gen2 | Conteneurs `bronze/`, `silver/`, `gold/` |
| **Transformation** | Azure Databricks (PySpark) | Nettoyage et agrégation |
| **Sécurité** | Azure Key Vault | Stockage des secrets et connexions |
| **Visualisation** | Power BI | Dashboard interactif |
| **Versioning** | Git / GitHub | Suivi du code et de la documentation |

---

## 📁 Structure du projet

```
azure-gender-sales-dashboard/
├── README.md # Ce fichier
├── LICENSE
├── .gitignore
├── sql/
│ ├── create_adf_user.sql # Création du login SQL pour ADF
│ └── exploratory_queries.sql # Requêtes d'exploration
├── notebooks/
│ ├── README.md
│ ├── 02_bronze_to_silver.ipynb # Nettoyage Bronze → Silver
│ └── 03_silver_to_gold.ipynb # Agrégation Silver → Gold
└── docs/
└── architecture.png # Schéma d'architecture
```


---

## 🚀 Résultats

- **Pipeline automatisé** : Ingestion quotidienne depuis SQL Server
- **Couche Silver** : Données nettoyées, typées et déduplicées
- **Couche Gold** : Agrégats prêts pour l'analyse
  - Ventes totales par genre et par année
  - Ventes par genre et par catégorie de produit
- **Dashboard Power BI** : Visualisation interactive avec filtres par genre, année et catégorie

---

## 🔐 Sécurité

- **Aucun mot de passe** n'est stocké dans le code source
- **Azure Key Vault** stocke tous les secrets (`sql-adf-password`)
- **ADF Linked Services** utilisent Key Vault pour récupérer les credentials
- **RBAC** configuré sur les ressources Azure

---

## 🎓 Compétences démontrées

- **Data Engineering** : ADF, Databricks, ADLS Gen2, architecture Medallion
- **Big Data** : PySpark, traitement distribué
- **Sécurité** : Key Vault, RBAC, gestion des secrets
- **Modélisation** : Star Schema, dimensions et faits
- **DevOps** : Git, versioning, documentation
- **Business Intelligence** : Power BI, DAX

---

## 🔮 Améliorations futures

- [ ] Ajouter Azure Synapse Analytics pour la couche de service
- [ ] Mettre en place des tests unitaires (pytest) sur les transformations
- [ ] Ajouter Azure Monitor pour la supervision des pipelines
- [ ] Automatiser le déploiement avec Azure DevOps (CI/CD)
- [ ] Enrichir le dashboard avec des prédictions ML (churn, segmentation)

---

## 👤 Auteur

**Hicham ERRIHANI**
- Data Engineer / Data Analyst
- 📧 errihanihicham1@gmail.com
- 🔗 [LinkedIn](https://www.linkedin.com/in/hicham-errihani)
- 💻 [GitHub](https://github.com/HichamErrihani-Eng)

---

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.
