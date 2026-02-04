# **📊End-to-End SQL Data Engineering Project for Contoso Retail**

Welcome to the **End-to-End SQL Data Engineering Project** repository! This is a comprehensive data warehousing solution demonstrating enterprise-grade design and implementation using the **Medallion Architecture** pattern, and this includes end‑to‑end data engineering and SQL analytics solution built for a fictional retail company, Contoso Retail, to centralize sales data, improve data quality, and enable self‑service analytics across teams.

---

## 📋 Project Overview

## Business Context & Objectives
Contoso Retail operates multiple sales channels and maintains separate CRM and ERP systems. Data is fragmented, definitions differ between systems, and business users struggle to answer basic questions such as:
  - Who are our most valuable customers?
  - Which products and categories drive revenue and margin?
  - How are sales trending across time and regions?
This project delivers a SQL Server–based data platform that:
  - Consolidates CRM and ERP data into a governed enterprise data warehouse.
  - Cleanses and standardizes data via a Medallion (Bronze/Silver/Gold) architecture.
  - Exposes an analytics‑ready star schema for BI and ad‑hoc analysis.
  - Implements key SQL analytics to support Contoso’s sales, finance, and merchandising teams.

## Key Deliverables

- ✅ **Bronze Layer**: Raw data ingestion from CSV files into SQL Server
- ✅ **Silver Layer**: Data cleansing, standardization, and normalization
- ✅ **Gold Layer**: Star schema with dimension and fact tables for analytics
- ✅ **Data Model**: Complete star schema with relationships and optimizations
- ✅ **Documentation**: Architecture diagrams, data catalog, and naming conventions
- 📊 **Analytics Layer**: Sales, customer, and product insights
  
---

## 🏗️ Architecture Overview

## Medallion Architecture (Multi-Layer Approach)

The project implements the industry-standard **Medallion Architecture**, separating data processing into three distinct layers:

<img width="996" height="574" alt="image" src="https://github.com/user-attachments/assets/6524ff65-8469-44b7-9146-d7e1940d9031" />

## **Bronze Layer** (Raw Data)

- **Purpose**: Immutable source of truth with original data preservation
- **Characteristics**: Data loaded as-is from CSV files with minimal transformation
- **Load Strategy**: Batch processing with TRUNCATE & INSERT
- **Use Case**: Historical auditing and data lineage tracking

## **Silver Layer** (Refined Data)

- **Purpose**: Data quality, standardization, and preparation for analytics
- **Characteristics**: Cleansed, validated, and normalized data
- **Transformations**: Type standardization, deduplication, business rule application
- **Load Strategy**: Batch processing with data validation

## **Gold Layer** (Analytics-Ready)

- **Purpose**: Business-optimized data for reporting and analytics
- **Characteristics**: Star schema design optimized for query performance
- **Design**: Dimension and fact tables with surrogate keys
- **Use Case**: BI dashboards, SQL-based reports, analytical queries

---

## 📊 Data Model: Star Schema

## Schema Diagram

<img width="1056" height="596" alt="image" src="https://github.com/user-attachments/assets/ece5b21a-3ac5-4950-a0c5-06580edb5db5" />

---

## Dimension Tables

## `gold.dim_customers`

Unified customer dimension combining CRM and ERP customer attributes.

| **Column** | **Type** | **Description** |
| --- | --- | --- |
| `customer_key` | INT | Surrogate key (Primary Key) |
| `customer_id` | INT | Business identifier from source |
| `customer_number` | VARCHAR(50) | Customer reference number |
| `first_name` | VARCHAR(100) | Customer first name |
| `last_name` | VARCHAR(100) | Customer last name |
| `country` | VARCHAR(50) | Country of residence |
| `marital_status` | VARCHAR(20) | Marital status attribute |
| `gender` | CHAR(1) | Gender (M/F) |
| `birth_date` | DATE | Date of birth |
| `create_date` | DATETIME | Record creation timestamp |

**Characteristics**:

- Slowly Changing Dimension (Type 1) — No historical tracking
- Deduplication applied for single customer view
- Merged from CRM and ERP customer sources

## `gold.dim_products`

Complete product dimension with hierarchical and operational attributes.

| **Column** | **Type** | **Description** |
| --- | --- | --- |
| `product_key` | INT | Surrogate key (Primary Key) |
| `product_id` | INT | Business identifier from source |
| `product_number` | VARCHAR(50) | Product SKU/number |
| `category_id` | INT | Category identifier |
| `category` | VARCHAR(100) | Product category |
| `subcategory` | VARCHAR(100) | Product subcategory |
| `cost` | DECIMAL(10,2) | Unit cost for profitability |
| `product_line` | VARCHAR(100) | Product line categorization |
| `product_start_date` | DATE | Product launch date |
| `maintenance` | VARCHAR(20) | Service/maintenance status |

**Characteristics**:

- Supports product hierarchy navigation (category → subcategory → product)
- Includes cost information for margin analysis
- Operational metadata for product lifecycle tracking

## Fact Table

## `gold.fact_sales`

Central fact table capturing all transactional sales data.

| **Column** | **Type** | **Description** |
| --- | --- | --- |
| `order_number` | VARCHAR(50) | Order identifier (Primary Key) |
| `product_key` | INT | Foreign Key to `dim_products` |
| `customer_id` | INT | Foreign Key to `dim_customers` |
| `order_date` | DATE | Transaction date |
| `shipping_date` | DATE | Order shipment date |
| `delivery_due_date` | DATE | Expected delivery date |
| `price` | DECIMAL(10,2) | Unit price of item sold |
| `sales_amount` | DECIMAL(12,2) | Total transaction amount (Measure) |
| `sales_quantity` | INT | Quantity sold (Measure) |

**Characteristics**:

- **Granularity**: One row per order line item
- **Measures**: `sales_amount`, `sales_quantity`
- **Foreign Keys**: Links to both customer and product dimensions
- **Designed for**: Transaction-level analysis and aggregations

---

## 🔄 Data Integration Model

## Source Systems Integration

<img width="1139" height="611" alt="image" src="https://github.com/user-attachments/assets/a3b5718d-16a4-4543-a9d1-6b3f88a80923" />

## Integration Strategy

- **Customer Data**: CRM primary source, enriched with ERP extended attributes (location, demographics)
- **Product Data**: Merged CRM and ERP product information with category hierarchy from ERP
- **Sales Data**: Transaction records from CRM combined with product and customer dimensions
- **Deduplication**: Applied at Silver layer to ensure single unified views in Gold layer
- **Reconciliation**: Source-to-target validation at each layer

## 📈 ETL Pipeline Design

## Load Patterns and Strategies

## Bronze Layer

| **Aspect** | **Details** |
| --- | --- |
| **Load Strategy** | Full Load (TRUNCATE & INSERT) |
| **Frequency** | Batch Processing |
| **Scope** | All source tables loaded completely |
| **Transformation** | Minimal — structure preserved as-is |

## Silver Layer

| **Aspect** | **Details** |
| --- | --- |
| **Load Strategy** | Full Refresh (TRUNCATE & INSERT) |
| **Frequency** | Batch Processing |
| **Transformations** | Type standardization, validation, deduplication |
| **Business Rules** | Data quality checks and reconciliation |

## Gold Layer

| **Aspect** | **Details** |
| --- | --- |
| **Load Strategy** | Dimension-first, then Fact |
| **Frequency** | Batch Processing |
| **Design Pattern** | Star Schema with surrogate keys |
| **Optimization** | Pre-aggregation and indexing |

---
## Analytics Layer (SQL-Only)
To keep the focus on data engineering while still demonstrating end‑to‑end value, analytics is implemented directly in SQL, typically in a separate analytics database (DataWarehouseAnalytics):
### Views
  - gold.customer_report
  - gold.product_report
---

## 🛠️ Technology Stack

| **Component** | **Technology** | **Purpose** |
| --- | --- | --- |
| **RDBMS** | Microsoft SQL Server | Enterprise data warehousing |
| **ETL/Processing** | T-SQL | Data extraction, transformation, loading |
| **Source Data** | CSV Files | CRM and ERP system exports |
| **Development IDE** | SQL Server Management Studio (SSMS) | Query development and execution |
| **Version Control** | Git/GitHub | Code repository and collaboration |
| **Documentation** | Markdown, Draw.io | Architecture and technical docs |

## Why This Stack?

- **SQL Server**: Enterprise-grade RDBMS with robust T-SQL for complex transformations
- **T-SQL**: Native SQL dialect enabling efficient data manipulation and business logic
- **Medallion Architecture**: Industry best practice for scalable data warehouse design
- **CSV Sources**: Demonstrates real-world data ingestion from legacy systems
- **GitHub**: Industry standard for portfolio demonstration and collaboration

---

## 📚 Key Technical Achievements

## 1. **Multi-Layer Architecture Implementation**

Designed and implemented the Medallion Architecture pattern, demonstrating understanding of enterprise data warehouse design principles and separation of concerns.

## 2. **Data Integration and Consolidation**

Integrated heterogeneous data sources (CRM and ERP) into a unified, consistent data model with proper deduplication and reconciliation.

## 3. **Star Schema Design**

Applied dimensional modeling techniques to create an optimized star schema supporting efficient analytical queries and business intelligence reporting.

## 4. **Data Quality Management**

Implemented comprehensive data validation, cleansing, and standardization processes, addressing real-world data quality challenges.

## 5. **Documentation and Governance**

Provided detailed architecture diagrams, data catalogs, and naming conventions supporting maintainability, knowledge transfer, and compliance.

## 💼 Skills Demonstrated

This project showcases comprehensive expertise in:

| **Skill Category** | **Competencies** |
| --- | --- |
| **Data Engineering** | ETL pipeline design, data integration, batch processing, data orchestration |
| **SQL Development** | Advanced T-SQL, complex queries, stored procedures, performance optimization |
| **Data Modeling** | Dimensional modeling, star schema design, fact/dimension tables |
| **Database Design** | Normalization, indexing strategies, schema optimization, data dictionary |
| **Data Governance** | Data quality, documentation, naming conventions, metadata management |
| **BI Fundamentals** | Analytics-ready data design, reporting optimization, dimensional analysis |
| **Tools & Technologies** | SQL Server, SSMS, Git/GitHub, Draw.io, Markdown |
| **Architecture & Design** | Medallion Architecture, multi-layer design, source system integration |

---

## 📄 License

This project is licensed under the **MIT License.**

## 👨‍💻 Author

**Dhanush Srinivasan**

- 🔗 GitHub: [@DhanushSriniv](https://github.com/DhanushSriniv)
- 💼 Portfolio: [View Portfolio](https://github.com/DhanushSriniv)
- 📧 LinkedIn: https://www.linkedin.com/in/dhanush-srinivasan-815118188/

---

## 🙏 Acknowledgments

- **Microsoft SQL Server**: Enterprise-grade data warehouse platform
- **Kaggle**: Sample dataset sources for demonstration
- **Data Engineering Community**: Industry best practices and standards
- **Draw.io**: Architecture and diagram design tools

---

## ✨ Project Status

| **Phase** | **Status** | **Completion** |
| --- | --- | --- |
| Bronze Layer Development | ✅ Complete | 100% |
| Silver Layer Development | ✅ Complete | 100% |
| Gold Layer Development | ✅ Complete | 100% |
| Data Quality Testing | ✅ Complete | 100% |
| Documentation | 🟡 In Progress | 70% |
| Analytics Layer | 🟡 In Progress | 60% |
