# Weimar Elections Insights

A comprehensive analysis of Nazi party support across different demographics during the Weimar Republic elections, based on the 2008 Harvard Study "Ordinary Economic Voting Behavior in the Extraordinary Election of Adolf Hitler."

## 📊 Project Overview

This repository contains SQL scripts and Python visualizations that analyze estimated Nazi party voting patterns by:
- **Social Class**: Unemployed, Blue-collar, White-collar, Self-employed, and Domestic workers
- **Religion**: Protestant vs Catholic populations

The data comes from Harvard Dataverse and represents statistical estimates derived from electoral and census data analysis.

## 📁 Repository Contents

### Core Files
- `Weimar_elections.sql`: Complete SQL script for database setup and data transformation
  - Creates population-weighted averages by social class
  - Generates religious breakdown analysis
  - Includes data cleaning and standardization
- `Weimar-1.py`: Social class analysis visualization
  - Creates line plots showing Nazi support trends across 5 social classes
  - Population-weighted calculations using 1933 demographic data
  - Dark theme appropriate for historical subject matter
- `Weimar-2.py`: Religious analysis visualization  
  - Compares Nazi support between Protestant and Catholic populations
  - Shows temporal trends across election years
  - Includes population statistics and data disclaimers

### Data Sources
- **Primary**: Harvard Dataverse - "Ordinary Economic Voting Behavior in the Extraordinary Election of Adolf Hitler" (2008)
- **Methodology**: Statistical estimates combining electoral results with census data

## 🛠 Technical Requirements

### Database
- MySQL server
- SQLAlchemy for Python database connectivity

### Python Dependencies
```python
sqlalchemy
mysql-connector-python
pandas
matplotlib
numpy
```

### Installation
```bash
pip install sqlalchemy mysql-connector-python pandas matplotlib numpy
```

## 🚀 Usage

### 1. Database Setup
```sql
-- Run the SQL script to create tables and process data
mysql -u your_username -p your_database < Weimar_elections.sql
```

### 2. Social Class Analysis
```bash
python Weimar-1.py
```
Generates: `weimar_elections_class.png` - Line plot showing Nazi support by social class

### 3. Religious Analysis  
```bash
python Weimar-2.py
```
Generates: `weimar_elections_rel.png` - Line plot comparing Protestant vs Catholic support

## 📈 Key Findings Visualized

- **Social Class Patterns**: Different levels of Nazi support across occupational groups
- **Religious Divide**: Comparative analysis of Protestant vs Catholic voting behavior  
- **Historical Context**: 1933 elections marked as "not free or fair"
- **Population Weighting**: Accurate representation based on actual demographic distributions

## ⚠ Important Notes

- **Data Nature**: These are statistical estimates, not direct historical records
- **Methodology**: Based on Harvard academic research combining multiple data sources
- **Uncertainty**: Expected degree of uncertainty in historical estimates
- **Context**: Analysis focuses on democratic elections before Nazi consolidation of power

## 🎨 Visualization Features

- **Dark Theme**: Somber styling appropriate for historical subject matter
- **Peak Annotations**: Highlights maximum support levels (excluding unfair 1933 elections)
- **Population Statistics**: Embedded demographic data for context
- **Data Attribution**: Clear sourcing and methodology disclaimers
- **Professional Quality**: High-resolution exports suitable for academic use

## 📚 Academic Context

This analysis supports historical research into:
- Economic factors in political extremism
- Religious influences on voting behavior
- Social class dynamics in democratic breakdown
- Statistical methodology in historical analysis
