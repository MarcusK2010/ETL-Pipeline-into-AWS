# ETL-pipeline into AWS

In a nutshell, the project is about a fictitious e-scooter company, which is trying to efficiently distribute its scooter in several cities. My task was to collect data for these cities, cities where the company operates. They asked for data on population (to be updated annually), location (latitude and longitude), weather forecast and data on arrivals in the local airports (both updated on a daily basis) of these cities.

To create an automated ETL pipeline on the cloud using Python and MySQL on AWS (RDS, Lambda, and CloudWatch). The project is designed to gather information on the geographic location and population of cities in Germany by 
* web scraping [wikipedia.org](https://www.wikipedia.org/). 
* API calls for weather information 
* API calls for information on arriving flights for the next day

in the folder /`Notebooks` you will find the python code for the data extraction, transformation and loading into a local MySQL instance, as well as comments tothe code.

All data is stored in a relational database containing the tables `city_table`, `airports_table`, `city_airport_table`, `city_data_table`, `weather_table`, and `arrivals_table`.
In the folder /`MySQL files` you will find the file `set_up_project_5_aws.sql`, which sets up the tables mentioned above.

## Prerequisites
To run this project, you need an API key for the [Weather API - 5-day forecast](https://openweathermap.org/forecast5) as well as [AeroDataBox](https://rapidapi.com/aedbx-aedbx/api/aerodatabox/). Free options with monthly limited requests are available. 

You also need an AWS account to run the project in the cloud.

__WARNING:__ Free tier options are available for AWS, but costs may occur when choosing the wrong payment plan or exceeding limits. __I am not responsible for any costs.__

- Set up your AWS credentials and ensure you have the necessary permissions to create and manage AWS resources.

Create a new layers in AWS Lambda with the following ARNs:

* `pandas` --> arn:aws:lambda:eu-north-1:336392948345:layer:AWSSDKPandas-Python310:3
* `requests` --> arn:aws:lambda:eu-north-1:770693421928:layer:Klayers-p310-requests:3
* `BeautifulSoup` --> arn:aws:lambda:eu-north-1:770693421928:layer:Klayers-p310-beautifulsoup4:1
* `SQLAlchemy` --> arn:aws:lambda:eu-north-1:770693421928:layer:Klayers-p39-SQLAlchemy:14 

## Usage

### Setting up AWS Lambda functions
- I recommend creating separate AWS Lambda functions for different update schedules:
  - Update city and airport information - only needs to run if a new city was added to the database manually.
  - Update city information - should be updated yearly; older information will be stored with the respective year.
  - Update weather and arrival flights - should be updated on a daily basis to retrieve information for the next day.

Create the respective Lambda functions and copy the appropriate code from the ZIP-files in the folder /`Lambda functions` (don't forget to insert your MySQL endpoint and API credentials).

The ZIP file contain the different code for the Lambda functions:

- `static_tables.zip` creates the DataFrames for the tables `city_table`, `airport_table` and `city_airport_table` and loads the data into the AWS MySQL database, which is created by executing `set_up_project_5_aws.sql` in MySQL Workbench
- `city_data_web_scraping.zip` web scrapes data for the cities in the the list from Wikipedia, creates a DataFrame for the table `city_data_table` and loads the data into the AWS MySQL database, which is created by executing `set_up_project_5_aws.sql` in MySQL Workbench
- `weather_data_api_call.zip` creates the DataFrames for the table `weather_table` and loads the data into the AWS MySQL database, which is created by executing `set_up_project_5_aws.sql` in MySQL Workbench
- `arrivals_data_api_call.zip` creates the DataFrames for the table `arrivals_table` and loads the data into the AWS MySQL database, which is created by executing `set_up_project_5_aws.sql` in MySQL Workbench
- `all_in_one_weather_arrivals.zip` creates the DataFrames for the tables `arrivals_table` and `weather_table` and loads the data into the AWS MySQL database, which is created by executing `set_up_project_5_aws.sql` in MySQL Workbench <-- this Lambda function is a combination of `arrivals_data_api_call.zip` and `weather_data_api_call.zip` and does exactly the same as the two seperate functions. As the data extracted with these functions is to be updated daily, you can run this one function instead of the two separate ones.

- Add your layer (see Prerequisites) to the function.
- Create an CloudWatch event schedule. There is a short tutorial [here](https://www.youtube.com/watch?v=lSqd6DVWZ9o&t=1s).
