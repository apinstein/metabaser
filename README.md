# metabaser

## Summary

A metabase driver for R. Easily access data from your Metabase questions for analysis in R.

This is an update to a previous package by apinstein to work with metabase version 0.33.6 (latest avilable as of January 1, 2020).

## Installation
1. Ensure the necessary packages are available within R
```
install.packages(c("jsonlite","httr","devtools"))
```
2. Install this library
```
library(devtools)
install_github("meedan/metabaser")
```

## First example
1. Load the package
```
library(metabaser)
```
2. Establish a metabase session.
```
mb_session <- metabase_init("https://your-metabase-site.com", username="user@your-metabase-site.com", password="your-metabase-password")
```
If you use RStudio and ommit the password argument, you will be prompted for a password.
3. Execute a query. Here is a simple question without any parameters. 
The "id" of the question is clearly visible in the querystring when using metabase in your browser.
```
dfMyData <- metabase_fetch_question(mb_session, id=42)
```

If you have parameters to your question, these should be added in the ``params`` argument as a list
```
dfMyData <- metabase_fetch_question(mb_session, id=42, params = list("answer"=project_id) )
```

## Contact

Further information is available from Scott Hale. Meedan team members can 
contact Scott via Slack and others can reach out to Scott via comments/issues
on this repository or via [direct message on Twitter](https://twitter.com/computermacgyve)
