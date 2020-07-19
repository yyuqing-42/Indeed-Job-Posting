---
  title: Creating An Attractive Job Posting to Garner Quality Clicks
author:
  - name: Citlally Reynoso
affil: 1
- name: Fatima Kabbaj
affil: 1
- name: Hanna Grossman
affil: 1
- name: Kai Chen Tan
affil: 1
- name: Patricia Njo
affil: 1
- name: Yuqing Yang
affil: 1

affiliation:
  - num: 1
address: Department of Statistics, UCLA

header-includes:
  - \usepackage[usenames,dvipsnames,svgnames,table]{xcolor}
- \usepackage{fontspec}
- \usepackage{calligra}
- \usepackage{amsmath,amssymb,amsthm}
- \usepackage{wasysym} 
- \usepackage{marvosym}
- \usepackage{graphicx}

column_numbers: 3
font_family: Karbon
primary_colour: navy
secondary_colour: white
accent_colour: blue
logoright_name: https&#58;//pydata.org/seattle2017/media/sponsor_files/indeedLogoBlue_3_OluKqNq.png
  logoleft_name: http&#58;//www.firststar.org/wp-content/uploads/2015/02/ucla1.jpg
  titlebox_bordercol: white
title_textsize : "75pt"
author_textsize: "50pt"
body_bgcol: lightbeige
output: 
  posterdown::posterdown_html:
  self_contained: no
latex_engine: xelatex
bibliography: packages.bib
---
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE)
```

$$\color{white}{c}$$
  $$\Large \color{#2D68C4}{INTRO} \space\space\color{#2D68C4}{\&} \space\space \color{#2D68C4}{METHODS}  $$
    
    # 1. Introduction
    
    In today’s competitive labor market, sourcing the best talent is more difficult than ever. Although factors such as income, benefits, and company culture affect an applicant’s willingness to apply to a company, the job posting itself also contributes to an applicant’s willingness to apply. In order to hire the best employees, companies are pushed to improve the quality of their job postings because only the top postings will attract the top candidates. Thus, we set out to explore some factors that will influence the popularity of a job posting in order to give companies the best advice.
    
    
    # 2. Research Objective
    
    What are some factors that will make a job posting more attractive and garner more clicks of interest on Indeed?
      
      # 3. About the Data Set
      
      We analyzed an Indeed dataset that reported the performance of job postings active between November 2016 and November 2017. The dimension of the dataset is 14,586,035 rows and 23 columns. The columns included information of each job posting, such as title, description word count, experience required, estimated salary, and number of clicks. Each row recorded the daily number of clicks received by every job posting, so a jobID could have several rows of observations from multiple days.
    
    # 4. Methodology
    
    Step 1: We curated the data to focus only on observations from California. We combined rows with the same jobID and created a new response variable “mean clicks per day.” In addition, we only kept variables that we believe companies can modify to improve their postings. This yielded our final cleaned dataset of 38,591 observations and 13 variables. 
    
    Step 2: We dichotomized variables with NAs to investigate whether the absence of a characteristic will impact the average clicks per day. 
    
    Step 3: We visualized the bivariate relationships between the input variables and average clicks per day.
    
    
    Step 4: We modeled our data to determine whether each input variable has a statistically significant influence on average clicks per day.
    
    Step 5: By looking at the relationship between each variable and average clicks per day, we recommended a few actionable insights that companies can work on to improve their postings.
    
    
    $$\color{white}{c}
    \color{white}{c}$$
      $$\color{white}{C}
    \color{white}{c}$$
      
      
      $$  \Large \color{#2D68C4}{R}\color{#2D68C4}{E}\color{#2D68C4}{S}\color{#2D68C4}{U}\color{#2D68C4}{L}\color{#2D68C4}{T}\color{#2D68C4}{S} \space\color{#2D68C4}{\&} \space\color{#2D68C4}{R}\color{#2D68C4}{E}\color{#2D68C4}{C}\color{#2D68C4}{O}\color{#2D68C4}{M}\color{#2D68C4}{M}\color{#2D68C4}{E}\color{#2D68C4}{N}\color{#2D68C4}{D}\color{#2D68C4}{A}\color{#2D68C4}{T}\color{#2D68C4}{I}\color{#2D68C4}{O}\color{#2D68C4}{N}\color{#2D68C4}{S} $$
        
        # 5. Results
        
        
        ```{r,warning=FALSE,message=FALSE}
        library(dplyr)
        library(ggplot2)
        data <- read.csv("~/Desktop/clean_data.csv")
        
        data$industry_dich[data$industry_dich == 0] <- "No"
        data$industry_dich[data$industry_dich == 1] <- "Yes"
        
        data$normTitle_dich[data$normTitle_dich == 0] <- "No"
        data$normTitle_dich[data$normTitle_dich == 1] <- "Yes"
        
        data$normTitleCategory_dich[data$normTitleCategory_dich == 0] <- "No"
        data$normTitleCategory_dich[data$normTitleCategory_dich == 1] <- "Yes"
        
        data$experienceRequired_dich[data$experienceRequired_dich == 0] <- "No"
        data$experienceRequired_dich[data$experienceRequired_dich == 1] <- "Yes"
        
        #plot1
        #descriptionCharacterLength
        ggplot(data,aes(x=descriptionCharacterLength, y=mean_clicks)) +
          geom_point(color= "#0073C2FF", alpha=0.4) +
          xlab("Description Character Length")+
          ylab("Average of Clicks")+
          ggtitle("Description Character Length v.s. Clicks")+
          geom_vline(xintercept = 5000,color="black",linetype="dashed")+
          geom_vline(xintercept = 10000,color="black") +
          theme(plot.title = element_text(size = 23, face = "bold")) +
          theme(axis.title.x = element_text(size = 22, face = "bold"))+
          theme(axis.title.y = element_text(size = 22, face = "bold"))
        
        #plot2
        #descriptionWordCount
        ggplot(data,aes(x=descriptionWordCount, y=mean_clicks)) +
          geom_point(color= "#0073C2FF", alpha=0.4) +
          xlab("Description Word Count")+
          ylab("Average of Clicks")+
          ggtitle("Description Word Count v.s. Clicks")+
          geom_vline(xintercept = 500,color="black",linetype="dashed")+
          geom_vline(xintercept = 1000,color="black")+
          theme(plot.title = element_text(size = 23, face = "bold"))+
          theme(axis.title.x = element_text(size = 22, face = "bold"))+
          theme(axis.title.y = element_text(size = 22, face = "bold"))
        
        #plot3
        #experienceRequired
        ggplot(data,aes(x=experienceRequired, y=mean_clicks)) +
          geom_point(color= "#0073C2FF", alpha=0.5) +
          xlab("Experience Required")+
          ylab("Average of Clicks")+
          ggtitle("Description Word Count v.s. Clicks") +
          theme(plot.title = element_text(size = 23, face = "bold"))+
          theme(axis.title.x = element_text(size = 22, face = "bold"))+
          theme(axis.title.y = element_text(size = 22, face = "bold"))
        
        #plot4
        #experienceRequired_dich
        data %>% ggplot(aes(x = as.factor(experienceRequired_dich), y = mean_clicks)) + 
          geom_boxplot(aes(color = experienceRequired_dich))+ 
          ylab("Average of Clicks")+
          xlab("Minimum Experience Required (year)")+
          ggtitle("Experience Required v.s. Clicks")+
          scale_color_manual(values = c("#0073C2FF", "black")) + theme(legend.position = "none")+
          theme(plot.title = element_text(size = 23, face = "bold"))+
          theme(axis.title.x = element_text(size = 22, face = "bold"))+
          theme(axis.title.y = element_text(size = 22, face = "bold"))
        
        #plot5
        #estimatedSalary
        ggplot(data,aes(x=estimatedSalary, y=mean_clicks)) +
          geom_point(color= "#0073C2FF", alpha=0.4) +
          xlab("Estimated Salary")+
          ylab("Average of Clicks")+
          ggtitle("Estimated Salary v.s. Clicks")+
          theme(plot.title = element_text(size = 23, face = "bold")) +
          theme(axis.title.x = element_text(size = 22, face = "bold"))+
          theme(axis.title.y = element_text(size = 22, face = "bold"))
        
        #plot6
        #industry_dich
        
        data %>% ggplot(aes(x = as.factor(industry_dich), y = mean_clicks)) + 
          geom_boxplot(aes(color = industry_dich))+ 
          ylab("Average of Clicks")+
          xlab("Industry")+
          ggtitle("Industry v.s. Clicks") +
          scale_color_manual(values = c("#0073C2FF", "black")) + theme(legend.position = "none")+
          theme(plot.title = element_text(size = 23, face = "bold"))+
          theme(axis.title.x = element_text(size = 22, face = "bold"))+
          theme(axis.title.y = element_text(size = 22, face = "bold"))
        
        #plot7
        #normTitle_dich
        
        data %>% ggplot(aes(x = as.factor(normTitle_dich), y = mean_clicks)) + 
          geom_boxplot(aes(color = normTitle_dich))+ 
          ylab("Average of Clicks")+
          xlab("Normalized Job Title")+
          ggtitle("Normalized Job Title v.s. Clicks")+
          scale_color_manual(values = c("#0073C2FF", "black")) + theme(legend.position = "none")+
          theme(plot.title = element_text(size = 23, face = "bold"))+
          theme(axis.title.x = element_text(size = 22, face = "bold"))+
          theme(axis.title.y = element_text(size = 22, face = "bold"))
        
        #normTitleCategory_dich
        
        data %>% ggplot(aes(x = as.factor(normTitleCategory_dich), y = mean_clicks)) + 
          geom_boxplot(aes(color = normTitleCategory_dich))+ 
          ylab("Average of Clicks")+
          xlab("Category of the Normalized Title")+
          ggtitle("Category of Normalized Title v.s. Clicks")+
          scale_color_manual(values = c("#0073C2FF", "black")) + theme(legend.position = "none")+
          theme(plot.title = element_text(size = 23, face = "bold"))+
          theme(axis.title.x = element_text(size = 22, face = "bold"))+
          theme(axis.title.y = element_text(size = 22, face = "bold"))
        
        ```
        
        
        
        # 6. Recommendations
        
        Recommendations for a company to maximize the number of quality clicks: 
          
          1. The job description should be between 0 and 5,000 characters optimally, and preferably below 10,000 characters. 
        
        2. The job description should be between 0 and 500 words optimally, and preferably below 1,000 words. 
        
        3. If a company wants to maximize the number of quality clicks, the experience required should be left blank. However, if a company wants job applicants with a certain level of experience, the experience required should be specified. 
        
        4. If a company chooses to specify experience required, they should select the lower end of their preferred range.
        
        5. The estimated salary should be specified and representative of the skill sets required for the job.
        
        6. If a company is open to job applicants with a variety of backgrounds, the industry should be left blank. However, if the company wants job applicants with a certain background, the industry should be specified.
        
        7. The job title and the category of the job title should be specified. 
        
        
        $$ \Large\color{#2D68C4}{CONCLUSION}$$
          
          # 7. Conclusion and Future Studies
          
          In today’s competitive labor market, it is important for companies to create job postings that would attract the top candidates. Some factors that would make a job posting more attractive include a concise job description, reasonable estimated salary, and specified job title and category of the job title. However, their approach to other variables such as experience required and industry should depend on their company goals. 
          
          Future Studies:   
            
            1. We can cater to a company’s individual needs by creating a customized set of recommendations for a particular industry.  
          
          2. We can look into the relationship between the number of days a job has been posted and the average number of clicks. This may allow us to recommend refreshing or starting a new job posting after a certain number of days to garner more clicks of interest.  
          
          3. We can research how the time of year affects the number of clicks. If more people are searching for jobs during certain times of the year, we could recommend focusing new hire efforts for a particular period.
          
          
          # 8. Works Cited
          
          Indeed. "Datafest 2018." Indeed.com, 2018. 
          
          Živković, Mile."How to Make a Job Ad That Attracts Candidates (with Examples)." Hundred5, Hundred5, 22 Mar. 2018, hundred5.com/blog/make-job-ad-that-attracts-candidates.
          
          ```{r, include=FALSE}
          knitr::write_bib(c('knitr','rmarkdown','posterdown','pagedown'), 'packages.bib')
          ```
          
          
          
          