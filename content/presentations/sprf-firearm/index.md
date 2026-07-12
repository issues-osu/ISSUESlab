---
title: "Modeling Firearm Injury Risk Using Spatial Random Forests"

event: National Research Conference for the Prevention of Firearm-Related Harms  
event_url: https://www.preventioninstitute.org/nrc-firearm-harms  

authors: ["gia-barboza-salerno", "hexin-yang", "taylor-harrington"]  

tags: [firearm injury, spatial random forest, machine learning, environmental justice, violence prevention]  

date: 2025-10-23  
weight: 1
---

Our presentation, *Modeling Firearm Injury Risk Using Spatial Random Forests*, will be delivered by [Dr. Gia Barboza-Salerno](https://issues-osu.github.io/ISSUESlab/author/gia-barboza-salerno/) at the **Women in Statistics and Data Science** on **November 12, 2025** in Cincinnati, OH.

> This study introduces a spatial machine learning framework for predicting firearm injury risk across Chicago census tracts. Using Spatial Random Forest Modeling (SRFM), we integrate social, built, and natural environment indicators, such as social vulnerability, housing burden, green space, traffic volume, and tree canopy, to identify localized structural determinants of firearm violence.  
>  
> Results demonstrate that racial composition, economic hardship, and environmental stressors jointly predict spatial clustering of firearm injury, while local variable importance reveals that built environment features exert context-specific effects across neighborhoods. These findings highlight the value of spatially aware, data-driven approaches for informing equitable, place-based violence prevention and policy.
>
**Abstract:** Gun violence remains a critical public health crisis, particularly in urban centers like Chicago, where firearm-related injuries are among the highest in the nation. These injuries are not randomly distributed; they are spatially concentrated in neighborhoods shaped by structural inequality, including racial segregation, economic disinvestment, and environmental neglect. While random forest models have shown promise in predicting firearm violence and identifying neighborhood-level risk factors, conventional approaches often ignore spatial dependence, leading to biased estimates, inflated variable importance, and reduced geographic generalizability. This study applies spatially explicit machine learning to model non-fatal shootings across Chicago census tracts from 2020 to 2024. A curated set of predictors was compiled, including measures of social and environmental vulnerability, the built environment, and housing inequality. Three research questions guided the analysis: (1) Does incorporating spatial structure via Moran's Eigenvector Maps (MEMs) in spatial random forests and spatially structured random effects in a Bayesian spatial model improve predictive accuracy compared to non-spatial models? (2) Which neighborhoods exhibit elevated firearm violence risk due to unmeasured spatial processes, as captured by spatial random effects? (3) Does prediction error vary across geographic space, revealing limits to model transferability? Findings suggest that the spatial random forest model outperformed the non-spatial model (pseudo R² = 0.98 vs. test R² = 0.50). Spatial cross-validation revealed geographic variation in accuracy (median nRMSE = 0.76), while spatial random effects from a Bayesian Poisson model identified unexplained latent risk. The enhanced predictive accuracy reveals hidden geographic risk patterns, suggesting that social, structural, and environmental factors can efficiently inform targeted violence prevention strategies.

{{< icon name="download" pack="fas" >}} Download the {{< staticref "uploads/SpatialRF_FirearmInjuryPresentation.pdf" "newtab" >}}presentation here{{< /staticref >}}.
