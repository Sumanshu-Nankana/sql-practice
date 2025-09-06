"""
584 Find Customer Referee
https://leetcode.com/problems/find-customer-referee/description/
"""

import pandas as pd


def find_customer_referee(customer: pd.DataFrame) -> pd.DataFrame:
    # Note: We cannot use Python's 'or' here, because it only works with single booleans.
    # For element-wise comparisons on Series/DataFrames, we must use '|' instead.
    # instead of isnull(), we can also use the isna(). Both are functionally same
    condition = (customer["referee_id"] != 2) | (customer["referee_id"].isnull())
    return customer[condition][["name"]]


if __name__ == "__main__":
    data = [
        [1, "Will", None],
        [2, "Jane", None],
        [3, "Alex", 2],
        [4, "Bill", None],
        [5, "Zack", 1],
        [6, "Mark", 2],
    ]
    customer = pd.DataFrame(data, columns=["id", "name", "referee_id"]).astype(
        {"id": "Int64", "name": "object", "referee_id": "Int64"}
    )
    output = find_customer_referee(customer)
    print(output)
    print(type(output))
