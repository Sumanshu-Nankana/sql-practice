"""
1280. Students and Examinations
https://leetcode.com/problems/students-and-examinations/description/
"""

import pandas as pd


def students_and_examinations(
    students: pd.DataFrame, subjects: pd.DataFrame, examinations: pd.DataFrame
) -> pd.DataFrame:
    # We will perform cross-join, to map each student with each subhect first
    df = pd.merge(left=students, right=subjects, how="cross")

    # We add a helper column attended_exams=1, so that after merging we can count how many exam records exist for each student–subject pair.
    examinations["attended_exams"] = 1

    # Merge with examinations
    df_final = pd.merge(
        left=df, right=examinations, how="left", on=["student_id", "subject_name"]
    )
    # groupby dropped the null values, but in output we need the null values for the student_name as well, so, we pass dropna=False
    # Because by defualt - it's True
    return (
        df_final.groupby(["student_id", "student_name", "subject_name"], dropna=False)
        .agg({"attended_exams": "count"})
        .reset_index()
    )


if __name__ == "__main__":
    data = [[1, "Alice"], [2, "Bob"], [13, "John"], [6, "Alex"]]
    students = pd.DataFrame(data, columns=["student_id", "student_name"]).astype(
        {"student_id": "Int64", "student_name": "object"}
    )
    data = [["Math"], ["Physics"], ["Programming"]]
    subjects = pd.DataFrame(data, columns=["subject_name"]).astype(
        {"subject_name": "object"}
    )
    data = [
        [1, "Math"],
        [1, "Physics"],
        [1, "Programming"],
        [2, "Programming"],
        [1, "Physics"],
        [1, "Math"],
        [13, "Math"],
        [13, "Programming"],
        [13, "Physics"],
        [2, "Math"],
        [1, "Math"],
    ]
    examinations = pd.DataFrame(data, columns=["student_id", "subject_name"]).astype(
        {"student_id": "Int64", "subject_name": "object"}
    )
    output = students_and_examinations(students, subjects, examinations)
    print(output)
