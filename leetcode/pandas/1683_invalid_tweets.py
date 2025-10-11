"""
1683. Invalid Tweets
https://leetcode.com/problems/invalid-tweets/description
"""

import pandas as pd


def invalid_tweets(tweets: pd.DataFrame) -> pd.DataFrame:
    condition = tweets["content"].str.len() > 15
    return tweets[condition][["tweet_id"]]


if __name__ == "__main__":
    data = [[1, "Let us Code"], [2, "More than fifteen chars are here!"]]
    tweets = pd.DataFrame(data, columns=["tweet_id", "content"]).astype(
        {"tweet_id": "Int64", "content": "object"}
    )
    output = invalid_tweets(tweets)
    print(output)
