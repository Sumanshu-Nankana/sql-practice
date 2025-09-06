"""
1378. Replace Employee ID With The Unique Identifier
https://leetcode.com/problems/replace-employee-id-with-the-unique-identifier/description/
"""

import pandas as pd


def replace_employee_id(
    employees: pd.DataFrame, employee_uni: pd.DataFrame
) -> pd.DataFrame:
    df = pd.merge(left=employees, right=employee_uni, how="left", on="id")
    return df[["unique_id", "name"]]


if __name__ == "__main__":
    data = [[1, "Alice"], [7, "Bob"], [11, "Meir"], [90, "Winston"], [3, "Jonathan"]]
    employees = pd.DataFrame(data, columns=["id", "name"]).astype(
        {"id": "int64", "name": "object"}
    )
    data = [[3, 1], [11, 2], [90, 3]]
    employee_uni = pd.DataFrame(data, columns=["id", "unique_id"]).astype(
        {"id": "int64", "unique_id": "int64"}
    )
    output = replace_employee_id(employees, employee_uni)
    print(output)
