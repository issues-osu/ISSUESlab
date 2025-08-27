---
title: Mining the “Indian Child Welfare Act” (ICWA) using Harvard Law School’s Caselaw API
subtitle: Big Data for Social Justice

# Summary for listings and search engines
summary: Textual analysis of case law can help identify areas to improve child welfare

# Link this post with a project
projects: []

# Date published
date: "2021-05-12T00:00:00Z"

# Date updated
lastmod: "2021-05-12T00:00:00Z"

# Is this an unpublished draft?
draft: false

# Show this page in the Featured widget?
featured: false

# Featured image
# Place an image named `featured.jpg/png` in this page's folder and customize its options here.
image:
  caption: 'Image credit: [**Unsplash**](https://unsplash.com/photos/CpkOjOcXdUY)'
  focal_point: ""
  placement: 2
  preview_only: false

authors:
- Gia Elise Barboza-Salerno
- Lani Elaine Castruita (Mvskoke Nation Citizen)

tags:
- BigData4SocialJustice

categories:
- ICWA
- Big Data
---

## Background
The United States government has a long and sordid history of separating children from their parents in this country. In the mid-1800s public and private agencies were routinely removing minor tribal citizens (hereafter “MTCs”) from their homes with the Federal Government’s consent. About 100 years later, a Congressional investigation revealed that between 25–35% of MTCs in the US were taken from families by state welfare agencies. The result was a gross disproportionality in the number of MTCs being removed from their homes and placed into foster care. More specifically, MTCs were 7–8 times more likely to be removed compared to white children with the vast majority placed in non — Tribal homes with white parents.

The overrepresentation of Native American children in our child welfare system has been attributed to the multiple systems of oppression that work in conjunction to harm communities of color. These systems are ignorant of tribal customs and refuse to acknowledge the benefits of prevailing cultural and social norms that characterize indigenous communities. In an acknowledgment of these facts and in response to the wholesale removal of children from indigenous households, in 1978 the US government enacted the “Indian Child Welfare Act” (ICWA). The ICWA (25 U.S.C. §1902) which was enacted by congress in accordance with its authority under the “Indian” commerce clause, has been described as a “monumental piece of legislation” that affects every Native American child born in the united states (Fletcher, 2007). Nevertheless, Native American children continue to be over-involved in the child welfare system at rates that are incongruent with their share of the population. In South Dakota, for example, available data from 2014–2018 show that Native American children remain disproportionately overrepresented in the child welfare system compared to other groups (see figure below). Importantly, 9 in 10 children are substantiated for neglect, which is defined as a parent or caregiver’s inability to meet a child’s basic needs. As I have previously noted elsewhere, child neglect and poverty are a tautology in this country.

## Chile welfare involvement by Race/Ethnicity in South Dakota
One critical element that is missing to shed light on the plight of indigenous communities is data. With the advent and availability of large, innovative datasets, however, it is now fairly easy to analyze ICWA caselaw in a systematic way — to better understand the issues and evaluate change over time. Therefore, as a first step in better understanding the circumstances surrounding family separation, we began to analyze ICWA caselaw using a broad social and ecological framework. One question we had was why, despite the enactment of the ICWA, have Native American children continued to be disproportionately represented in the foster care system decades after its enactment. The goal was to advocate for the creation of more sensitive and effective interventions that minimize involvement of indigenous families in the child welfare system.

## Our Analysis
Here, we describe the first step of our analysis, namely to identify and download a corpus of ICWA caselaw for further analysis. Thereafter, we are able to analyze the caselaw text (i.e. the corpus) using more advanced textual analysis and data science tools.

Legal documents are very complicated. Luckily, the Harvard Law School provides a way to access caselaw data fairly easily. The data for this analysis comes from Harvard Law School’s Caselaw Access Project (“CAP”) which can be accessed here https://case.law. As discussed on their website, the purpose of the CAP is to expand public access to U.S. law by providing a searchable database and an Application Programming Interface (”API”). The goal of this project is to make all published U.S. court decisions freely available to the public online, in a consistent format, digitized from the collection of the Harvard Law Library. According to their website, at the time of this writing, the CAP makes 6,725,065 unique cases available from 625 Reporters and they have 35,666,018 pages scanned. To learn more about Harvard’s CAP click here. The Harvard Law School also made a short video announcing the Caselaw Access Project at case.law which you can view below.

Announcing the Caselaw Access Project: Source: Harvard Law School
The first step is to access all ICWA caselaw data available through the CAP API. The data includes an ID, case name, decision date, docket number, parties, jurisdiction, cases cited and full text, among other things. The graphic below is a snapshot of the results from the link above. The Case Document List pictured below shows us that there are 899 cases returned from our search of the term “ICWA” that are available to download.

We accessed the caselaw data, stored the resulting data into a json object and then converted the results to a data set in R with the following code:
```r
base_url = "https://api.case.law/v1/cases/?page_size=896&search=%22ICWA%22"
get_cases <- httr::GET(url = base_url)
get_cases <- httr::content(get_cases, as="raw")
json <- jsonlite::fromJSON(rawToChar(get_cases))
icwa_cases <- tibble::as_tibble(json$results)
```
Then, we summarized the number of cases from seven jurisdictions (“Texas”,”California”, “Oklahoma”, “Arizona”, “Colorado”, “South Dakota”, “New Mexico”, “North Dakota”, “Oklahoma”) with relatively large shares of Native American children. The result is plotted below using the ggplot library in R.
```r
df<- icwa_cases$jurisdiction %>%
  dplyr::group_by(name_long) %>%
  dplyr::filter(name_long %in% 
    c("Texas","California", 
    "Oklahoma", 
    "Arizona", 
    "Colorado", 
    "South Dakota", 
    "New Mexico", 
    "North Dakota", 
    "Oklahoma")) %>%
  dplyr::summarise(counts = n())
ggplot(df, aes(x = reorder(name_long, -counts), y = counts)) +
  geom_bar(fill = "#0073C2FF", stat = "identity") +
  geom_text(aes(label = counts), vjust = -0.3) + 
  theme_pubclean() + ggtitle("ICWA Caselaw By State") +
  xlab("State Name") + ylab("Number of Cases")
```

In order to get the full text of each case the option ‘full_case’ must be set to true. For example, to access the full case text for case number 159725, State ex rel. Human Services Department v. Wayne R.N. click here.

```r
case_url = "https://api.case.law/v1/cases/1597254/?full_case=true"
# Replace the XXXX with your own token
auth_header <- httr::add_headers('Authorization' = 'Token XXXX')
get_case <- httr::GET(url = case_url, auth_header)
get_case <- httr::content(get_case, as="parsed") 
```

Next we looped through all of the available cases and stored the full case text and case ID for each case.

```r
# create an empty data frame
df <- setNames(data.frame(matrix(ncol = 2, nrow = 0)), c("id", "text"))
#loop through all icwa cases and store in the dataset
for (i in 1:nrow(icwa_cases)){
  tryCatch({
    get_case_url = paste0(icwa_cases[i,2],"?full_case=true")
    get_case_url <- httr::GET(url = get_case_url)
    get_case_url <- httr::content(get_case_url, as="parsed")
    if (!is.null(get_case_url$casebody[[2]])) {
      df[i,1] <- get_case_url$id
      df[i,2] <- get_case_url$casebody[[2]][3]$opinions[[1]]$text
     }
  }
    , error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
}
df <- df[complete.cases(df), ]
```

The wordcloud2 library was used to create the following wordcloud on the term document matrix after the data were cleaned.

As shown by the wordcloud above, several words stand out in addition to the words one would expect (for example “child” and “indian”). For example, abuse, adoption, transfer, health, neglect and expert might be subjects worthy of further investigation. Once the data are downloaded in R, we were able to identify the case law that contains these words to drill down further into the circumstances of each case. We also applied Latent Dirichlet Allocation modeling to the corpus of cases to elucidate categories of ICWA caselaw. Our results are available online. 

{{< icon name="download" pack="fas" >}}   {{< staticref "uploads/ICWA_USD_2021.pdf" "newtab" >}}Download the presentation {{< /staticref >}} we made at the University of South Dakota School of Law ICWA conference in Spring 2021.

In sum, we have used the Harvard Caselaw API in a way that provides researchers, lawyers and policymakers the ability to dig deeper into existing case law to better understand the issues that surround child welfare for the purpose of creating more effective and sensitive interventions. To download cases on a different subject merely change the search terms.

Using big data for social justice purposes.

## More Information
For additional information, see the following link to resources from Mvskoke Nation’s Child & Family Services Administration.
## References
Fletcher, Mathew (2007). “ICWA and the Commerce Clause.” Availabe at: https://www.law.msu.edu/indigenous/papers/2007-06.pdf
Caselaw Access Project, Harvard Law School. Available at https://case.law
