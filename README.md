# Indeed-Job-Posting

Members: Citlally Reynoso, Yuqing Yang, Fatima Kabbaj, Hanna Grossman, Kai Chen Tan, Patricia Njo

## Research Objective

What are some factors that will make a job posting more attractive and garner more clicks of interest on Indeed?

## About the dataset

We analyzed an Indeed dataset that reported the performance of job postings active between November 2016 and November 2017. The dimension of the dataset is 14,586,035 rows and 23 columns. The columns included information of each job posting, such as title, description word count, experience required, estimated salary, and number of clicks. Each row recorded the daily number of clicks received by every job posting, so a jobID could have several rows of observations from multiple days.

## Methodology

Step 1: We curated the data to focus only on observations from California. We combined rows with the same jobID and created a new response variable “mean clicks per day.” In addition, we only kept variables that we believe companies can modify to improve their postings. This yielded our final cleaned dataset of 38,591 observations and 13 variables.

Step 2: We dichotomized variables with NAs to investigate whether the absence of a characteristic will impact the average clicks per day.

Step 3: We visualized the bivariate relationships between the input variables and average clicks per day.

Step 4: We modeled our data to determine whether each input variable has a statistically significant influence on average clicks per day.

Step 5: By looking at the relationship between each variable and average clicks per day, we recommended a few actionable insights that companies can work on to improve their postings.

## Results & Recommendations

1. The job description should be between 0 and 5,000 characters optimally, and preferably below 10,000 characters.The job description should be between 0 and 5,000 characters optimally, and preferably below 10,000 characters.

2. Thejobdescriptionshouldbebetween0and500wordsoptimally,and preferably below 1,000 words.

3. If a company wants to maximize the number of quality clicks, the experience required should be left blank. However, if a company wants job applicants with a certain level of experience, the experience required should be specified.

4. If a company chooses to specify experience required, they should select the lower end of their preferred range.

5. Theestimatedsalaryshouldbespecifiedandrepresentativeoftheskill sets required for the job.

6. If a company is open to job applicants with a variety of backgrounds, the industry should be left blank. However, if the company wants job applicants with a certain background, the industry should be specified.

7. The job title and the category of the job title should be specified.

## Future Studies

1. We can cater to a company’s individual needs by creating a customized set of recommendations for a particular industry.

2. We can look into the relationship between the number of days a job has been posted and the average number of clicks. This may allow us to recommend refreshing or starting a new job posting after a certain number of days to garner more clicks of interest.

3. We can research how the time of year affects the number of clicks. If more people are searching for jobs during certain times of the year, we could recommend focusing new hire efforts for a particular period.
