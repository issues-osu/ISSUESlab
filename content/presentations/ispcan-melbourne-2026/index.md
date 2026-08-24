---
title: "Detecting Hidden Mechanisms of Abuse-Related Injury in Children: Structured Topic Modeling of Clinical Death Reviews and Legal Opinions"
date: 2026-08-24
draft: false
featured: true
event: ISPCAN World Congress on Child Abuse and Neglect — Melbourne 2026
event_url: https://ispcan.org/congresses/melbourne-2026/
authors:
  - gia-barboza-salerno
  - henriikka-weir
  - malcolm-mccarthy
  - karla-shockley-mccarthy
  - amy-watson-grace
  - keith-warren
  - esenia-cassidy
  - olivia-mclucas
tags:
  - child abuse and neglect
  - child fatality
  - structured topic modeling
  - NLP
  - machine learning
  - traumatic brain injury
  - craniofacial trauma
  - child maltreatment
  - ISPCAN
---

**Presented at the ISPCAN World Congress on Child Abuse and Neglect**, Melbourne, Australia, August 24–26, 2026.

**Full title:** *Detecting Hidden Mechanisms of Abuse-Related Injury in Children: Structured Topic Modeling of Clinical Death Reviews and Legal Opinions — Triangulating Multidisciplinary Child Fatality Reviews with Factual and Procedural Narratives from Case Law*

## Abstract

Existing child maltreatment surveillance systems miss or misclassify between 80–90% of maltreatment deaths, and CPS records undercount fatalities by 55–76%. Unstructured narrative text — clinical death reviews, court opinions, and social work records — accounts for 80–90% of all organizational data produced, yet it is rarely leveraged for injury surveillance.

This presentation introduces a two-study AI + Structured Topic Modeling (STM) pipeline that integrates two distinct narrative corpora to recover latent, abuse-related injury mechanisms that structured administrative codes routinely obscure.

## Study Design

| | Study 1: CFRT Death Reviews | Study 2: CourtListener Case Law |
|---|---|---|
| **Source** | Colorado Child Fatality Review Team reports | Appellate opinions retrieved from CourtListener |
| **Documents** | 223 child-level narrative records | 751 opinions → 335 confirmed cases from Ohio |
| **Text** | Two free-text fields per report (clinical + administrative) | Facts + procedural history |
| **LLM Extraction** | GPT-4o-mini: caregiver behavior, injury mechanism, setting, diagnosis | GPT-4o-mini: 9 structured fields including perpetrator, victim type, legal outcome |
| **STM Models** | Risk & Contributing Factors; Circumstances | Injury Mechanism; Long-Term Consequences |
| **Covariate** | Incident year (temporal prevalence) | Judicial ruling (affirmed / reversed) |

## Research Questions

1. Can large language models transform unstructured child fatality narratives into standardized semantic features — caregiver behavior, injury mechanism, setting, diagnosis?
2. What latent themes emerge, and what typology of risk and incident circumstances do they suggest?
3. Do the recovered themes reveal recurring patterns of head and neck trauma consistent with abuse-related injury?
4. How does the prevalence of these themes shift across incident years (2020–2025)?

## Key Findings

- Both corpora converge on **craniofacial injury** as the dominant mechanism — routinely undercounted by ICD codes.
- **Strangulation** emerged as a critical lethality predictor; soft-tissue damage can surface 2–3 days post-injury, requiring clinician and court training on delayed sequelae.
- Records document **long-term neurological harm** (cerebral palsy, pituitary damage, blindness) in children — often years before clinical follow-up.
- **Children represent a structurally distinct injury profile** in both datasets, warranting specialized clinical and legal protocols.
- "Accidental" injuries (falls, environmental contact) are frequently embedded in an abuse context — screening for **mechanism**, not just diagnosis, is essential.
- Appellate opinions and death reviews function as **injury-surveillance sources** beyond structured administrative fields.

## Methodology

The pipeline applies:
- **PDF parsing** (pdftools) and regex isolation of narrative fields
- **GPT-4o-mini** for LLM-based structured field extraction
- **Structured Topic Modeling (STM)** with incident year or judicial ruling as a prevalence covariate
- **BART zero-shot classification** as an independent supervised-style validation check
- **FREX word scoring** (frequency × exclusivity) for topic labeling

## Lab Members

This presentation was developed by the ISSUES Lab team at The Ohio State University:

**Dr. Gia E. Barboza-Salerno** (Founding Director), **Dr. Henriikka Weir**, **Malcolm McCarthy**, **Dr. Karla Shockley McCarthy**, **Dr. Amy Watson-Grace**, **Dr. Keith Warren**, **Esenia Cassidy**, and **Olivia McLucas** — with collaborators **Scottye Cash** and **Suzanne Perkins**.

### 📄 Presentation

{{< icon name="download" pack="fas" >}} Download the {{< staticref "uploads/ISPCAN_Melbourne_2026_ISSUES_Lab.pptx" "newtab" >}}presentation slides here{{< /staticref >}}.
