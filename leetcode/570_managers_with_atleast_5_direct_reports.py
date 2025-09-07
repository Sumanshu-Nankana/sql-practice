"""
570. Managers with at least 5 Direct Reports
https://leetcode.com/problems/managers-with-at-least-5-direct-reports/description/
"""

import pandas as pd


def find_managers(employee: pd.DataFrame) -> pd.DataFrame:
    df = (
        employee.groupby("managerId")
        .agg({"id": "count"})
        .reset_index()
        .rename(columns={"id": "count"})
    )
    busy_managers = df[df["count"] >= 5]

    # We use inner join - keeps only the intersection: managerIds that exist in employee.id.
    return pd.merge(
        left=busy_managers,
        right=employee,
        how="inner",
        left_on="managerId",
        right_on="id",
    )[["name"]]


if __name__ == "__main__":
    data = [
        [101, "John", "A", None],
        [102, "Dan", "A", 101],
        [103, "James", "A", 101],
        [104, "Amy", "A", 101],
        [105, "Anne", "A", 101],
        [106, "Ron", "B", 101],
    ]
    employee = pd.DataFrame(
        data, columns=["id", "name", "department", "managerId"]
    ).astype(
        {"id": "Int64", "name": "object", "department": "object", "managerId": "Int64"}
    )
    output = find_managers(employee)
    print(output)
