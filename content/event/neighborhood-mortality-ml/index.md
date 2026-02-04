---
title: "Living Here Predicts How You Will Die: Neighborhood Context and Mortality Patterns"
date: 2026-02-04
draft: false
featured: true
authors:
  - gia-barboza-salerno
tags:
  - mortality
  - neighborhood effects
  - machine learning
  - NLP
  - GIS
  - health inequities
  - medical examiner data
image:
  caption: "Cook County Neighborhood Typology"
  focal_point: "Smart"
---


## Abstract

Understanding how neighborhood context shapes patterns of death is critical to identifying the spatial distribution of health inequities. Medical examiner data contain rich narrative descriptions of causes and circumstances of death that are often absent from clinical records and can offer novel insights for public health prevention.

This study integrates **Geographic Information Systems (GIS)**, **machine learning (ML)**, and **natural language processing (NLP)** frameworks to demonstrate how neighborhood clustering and predictive text analytics can jointly reveal spatially stratified mortality patterns to examine how structural neighborhood conditions predict not only whether but how people die, thereby advancing geographically tailored public health insights.

## Methods

Tract-level mortgage lending and demographic data were integrated with narrative cause-of-death records from the Cook County Medical Examiner. A GIS-informed machine learning framework was used to classify neighborhood context and link it to mortality patterns in Cook County, Illinois.

Using tract geometries from the American Community Survey (ACS) 2020 and integrating:

- 2018 racial/ethnic composition
- Median household income
- Shifts in mortgage lending by borrower race/ethnicity and income from HMDA
- CDC Social Vulnerability Index

A standardized feature set capturing racial/ethnic composition, economic resources, and structural change in lending markets was constructed. Unsupervised machine learning methods with gap statistics were used to derive **five interpretable neighborhood clusters**.

Text descriptions from cause-of-death fields were cleaned, lemmatized, and harmonized into medical concepts, then summarized by cluster using frequency and tf–idf contrasts.

## Key Findings

The five neighborhood clusters showed **distinct mortality profiles** that mirrored structural conditions:

- **Disinvested Black neighborhoods**: Marked by violence and street-level drug toxicity
- **Affluent White enclaves**: Reflected prescription/synthetic drug deaths and self-harm
- **Latino working-class areas**: Exhibited mixed patterns of chronic disease, injury, and substance involvement
- **White-Latino transition neighborhoods**: Dominated by chronic illness and degenerative diseases
- **Lower-income Black neighborhoods**: Burdened by chronic illness, degenerative diseases, infectious causes, and substance-related mortality

### Predictive Modeling Results

Penalized logistic regression models (glmnet) were used to predict cluster membership from:

- Text alone
- Covariates (income, rent, poverty, age, gender)
- Both combined

**Key Results:**

- Text features exhibited **high sensitivity** across clusters
- Socioeconomic covariates improved **specificity**, particularly in affluent White enclaves
- **Combined models** (text + covariates) achieved the highest overall accuracy
- Performance varied by cluster: affluent White enclaves were well distinguished by socioeconomic covariates, while text features more easily identified disinvested Black and lower-income Black neighborhoods

## Research Questions

**RQ1**: Can neighborhood structural typologies derived from mortgage lending and demographic patterns be meaningfully linked to cause-of-death narratives?

**RQ2**: Does narrative text from Medical Examiner death records improve prediction of neighborhood typology?

## Conclusions

These results highlight how integrating structured tract-level data with unstructured death narratives uncovers not only **place-based disparities in mortality risk**, but also **systematic differences in how death is recorded** across structurally distinct neighborhoods.

Five neighborhood clusters were identified using k-means clustering on tract-level indicators. Penalized logistic regression models demonstrated that:

- Combined text and covariate models achieved the highest accuracy across most neighborhood types
- Narrative language varied systematically by neighborhood type, reflecting **place-based inequality in death documentation**

---

**Topics**: Mortality patterns, neighborhood effects, health inequities, machine learning, natural language processing, GIS, medical examiner data, Cook County
