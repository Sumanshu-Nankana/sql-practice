"""
595 Big Countries
https://leetcode.com/problems/big-countries/description/
"""

import pandas as pd


def big_countries(world: pd.DataFrame) -> pd.DataFrame:
    condition = (world["area"] >= 3000000) | (world["population"] >= 25000000)
    return world[condition][["name", "population", "area"]]


if __name__ == "__main__":
    data = [
        ["Afghanistan", "Asia", 652230, 25500100, 20343000000],
        ["Albania", "Europe", 28748, 2831741, 12960000000],
        ["Algeria", "Africa", 2381741, 37100000, 188681000000],
        ["Andorra", "Europe", 468, 78115, 3712000000],
        ["Angola", "Africa", 1246700, 20609294, 100990000000],
    ]
    world = pd.DataFrame(
        data, columns=["name", "continent", "area", "population", "gdp"]
    ).astype(
        {
            "name": "object",
            "continent": "object",
            "area": "Int64",
            "population": "Int64",
            "gdp": "Int64",
        }
    )
    output = big_countries(world)
    print(output)
