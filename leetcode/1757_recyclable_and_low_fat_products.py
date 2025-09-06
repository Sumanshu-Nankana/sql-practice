"""
1757 Recyclable and Low Fat Products
https://leetcode.com/problems/recyclable-and-low-fat-products/description/
"""

import pandas as pd


def find_products(products: pd.DataFrame) -> pd.DataFrame:
    # Whenever we have two conditions, we will use bracket

    # Note: We cannot use Python's 'and' here, because it only works with single booleans.
    # products["low_fats"] == "Y" returns a Series of booleans (one per row), not a single value.
    # For element-wise comparisons on Series/DataFrames, we must use '&' instead.
    condition = (products["low_fats"] == "Y") & (products["recyclable"] == "Y")

    # Note: products[condition]['product_id'] returns a Series
    # To return a DataFrame, put column names in a list
    return products[condition][["product_id"]]


# Example usage/test
if __name__ == "__main__":
    data = [
        ["0", "Y", "N"],
        ["1", "Y", "Y"],
        ["2", "N", "Y"],
        ["3", "Y", "Y"],
        ["4", "N", "N"],
    ]
    products = pd.DataFrame(
        data, columns=["product_id", "low_fats", "recyclable"]
    ).astype({"product_id": "int64", "low_fats": "category", "recyclable": "category"})
    output = find_products(products)
    print(output)
    print(type(output))
