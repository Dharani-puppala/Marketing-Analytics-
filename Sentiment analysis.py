
import pandas as pd
import pyodbc
import nltk
from nltk.sentiment.vader import SentimentIntensityAnalyzer

#downloading packing
#nltk.download('vader_lexicon')
#fetching data  in sql
def fetch_data_from_sql():
    conn_str=(
        "Driver={SQL Server};"  
        "Server=DANY\\SQLEXPRESS01;"  #put double slash \\
        "Database=PortfolioProject_MarketingAnalytics;"  
        "Trusted_Connection=yes;" 

    )
    connection=pyodbc.connect(conn_str)
    query= "SELECT ReviewID, CustomerID, ProductID, ReviewDate, Rating, ReviewText FROM dbo.customer_reviews "
    dataframe=pd.read_sql(query,connection)
    connection.close()
    return dataframe
    
    

   
#customer reviews
customer_reviw_df=fetch_data_from_sql()

#sentiment analysis
senti_analyz=SentimentIntensityAnalyzer()

#scores for sentiment analysis
def calc_senti_score(review):
    sentiment=senti_analyz.polarity_scores(review)
    return sentiment['compound']

#function to categorize sentiment
def categorize_sentiment(score, rating):
    if score>0.05:
        if rating >= 4:
            return 'Postive'
        elif rating == 3:
            return 'Mixed Positive'
        else:
            return 'Mixed Negative'
    elif score< -0.05:
        if rating <= 2:
            return 'Negative'
        elif rating == 3:
            return 'Mixed Negative'
    else:
        if rating >=4:
            return 'Positive' # high rating neutral
        elif rating <=2:
            return 'Negative' # low rating neutral
        else:
            return 'Neutral'  # neutral rating neutral
# function for bucketing sentiment scores to text
def bucket_sentiment(score):
    if score>= 0.05:
        return '0.5 to 1.0'
    elif 0.0<= score<0.5:
        return'0.0 to 0.49'    
    elif -0.5 <= score < 0.0:
        return '-0.49 to 0.0'
    else:
        return '-1.0 to -0.5'   
# sttartng sentimental analysis
customer_reviw_df['SentimentScore']=customer_reviw_df['ReviewText'].apply(calc_senti_score)
#applying sentimental categorization
customer_reviw_df['SentimentCategory'] = customer_reviw_df.apply(
    lambda row: categorize_sentiment(row['SentimentScore'], row['Rating']), axis=1)
# bucketing
customer_reviw_df['SentimentBucket'] = customer_reviw_df['SentimentScore'].apply(bucket_sentiment)


print(customer_reviw_df.head())
# make csv
customer_reviw_df.to_csv('fact_customer_reviews_with_sentiment.csv', index=False)