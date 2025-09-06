"""
1581. Customer Who Visited but Did Not Make Any Transaction.
https://leetcode.com/problems/customer-who-visited-but-did-not-make-any-transactions/description/
"""

import pandas as pd


def find_customers(visits: pd.DataFrame, transactions: pd.DataFrame) -> pd.DataFrame:
    df = pd.merge(left=visits, right=transactions, how="left", on="visit_id")

    # filter those rows where transaction_id is Null
    condition = df["transaction_id"].isnull()

    # We use reset_index, because when we use group_by, it automatically creates customer_id column as index.
    # And old_index will added back as a column (in our case it's customer_id)
    # in aggregate function, we can also use .agg({'visit_id': 'count'})
    # 'count' - will count the Non-NA rows (So we need to mention only that column, which has Non-NA
    # while len (function) - can count the total_rows, In this question, we need to find the total_rows
    # So, we can use len (irrespective on column)
    return (
        df[condition]
        .groupby("customer_id")
        .agg({"visit_id": len})
        .reset_index()
        .rename(columns={"visit_id": "count_no_trans"})
    )


if __name__ == "__main__":
    data = [[1, 23], [2, 9], [4, 30], [5, 54], [6, 96], [7, 54], [8, 54]]
    visits = pd.DataFrame(data, columns=["visit_id", "customer_id"]).astype(
        {"visit_id": "Int64", "customer_id": "Int64"}
    )
    data = [[2, 5, 310], [3, 5, 300], [9, 5, 200], [12, 1, 910], [13, 2, 970]]
    transactions = pd.DataFrame(
        data, columns=["transaction_id", "visit_id", "amount"]
    ).astype({"transaction_id": "Int64", "visit_id": "Int64", "amount": "Int64"})
    output = find_customers(visits, transactions)
    print(output)
