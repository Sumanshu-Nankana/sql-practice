"""
197. Rising Temperature
https://leetcode.com/problems/rising-temperature/description/
"""

import pandas as pd


def rising_temperature(weather: pd.DataFrame) -> pd.DataFrame:
    # Sort the date columns, as we don't have guarentee that data will be in sorted order
    df = weather.sort_values(by="recordDate")
    # We will use shift function to shift the rows by 1 and create a new column
    df["prev_day_temp"] = df["temperature"].shift(1)
    # Also, we need check exactly with yesterday (and there can be gaps in the dates in input data)
    df["prev_recordDate"] = df["recordDate"].shift(1)
    # default difference result is in milliseconds, so we convert to days
    df["dateDiff"] = (df["recordDate"] - df["prev_recordDate"]).dt.days
    filter = (df["temperature"] > df["prev_day_temp"]) & (df["dateDiff"] == 1)
    return df[filter][["id"]]


if __name__ == "__main__":
    data = [
        [1, "2015-01-01", 10],
        [2, "2015-01-02", 25],
        [3, "2015-01-03", 20],
        [4, "2015-01-04", 30],
    ]
    weather = pd.DataFrame(data, columns=["id", "recordDate", "temperature"]).astype(
        {"id": "Int64", "recordDate": "datetime64[ns]", "temperature": "Int64"}
    )
    output = rising_temperature(weather)
    print(output)
