---
title: "Machine Learning Techniques applied to Heart
Rate Variability - DTU Course final report"
summary: "Final report for DTU's Machine Learning course: supervised and unsupervised learning applied to Heart Rate Variability data to predict and cluster HRV values."
date: 2019-12-31
showtoc: false
---

## Introduction

Heart Rate Variability (HRV) is a way to measure the variation in time between each heartbeat. This variation is a measure of how the heart reacts to physical exercise, mental stress, and heart diseases, directly linked to an increased risk of mortality.

It has its origin in neurons from the parasympathetic, sympathetic nervous system, and vagus nerve. Evidence suggests that HRV is impacted by stress, specifically due to higher levels of stress resulting in a lower HRV.

While stress (and its causes and effects) is a known research topic, it's also more accessible due to the widespread usage of wearables that allow the collection of HRV data. The combination of the possibility of stress analysis from HRV and easy access to data makes this the main focus of the present report, determining whether machine learning techniques can help minimalizing generalization errors.

This report is structured into three main parts: data analysis, supervised, and unsupervised learning. All three parts revolve around predicting and/or clustering HRV values.

## Report

[Download full report (41 pages)](https://raw.githubusercontent.com/pmadruga/ml_project/master/dist/report.pdf)

## Code

1. [Data Preparation + Principal Component Analysis](https://github.com/pmadruga/ml_project/blob/master/books/data_preparation.ipynb)
2. [Supervised learning - classification (**baseline, logistic regression, neural network**)](https://github.com/pmadruga/ml_project/blob/master/books/Classification.ipynb)
3. [Supervised learning - regression (**linear regression, neural network**)](https://github.com/pmadruga/ml_project/blob/master/books/regression%20-%20part%20A.ipynb)
4. [Unsupervised learning - **Agglomerated Hierarquical Clustering, Gaussian Mixture Model, Anomaly Detection, Aprior Association**](https://github.com/pmadruga/ml_project/blob/master/books/New%20Unsupervised.ipynb)
