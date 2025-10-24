import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os

INPUT_DIR = "analysis_output"
OUTPUT_DIR = "graphs_output"
os.makedirs(OUTPUT_DIR, exist_ok=True)

csv_files = [f for f in os.listdir(INPUT_DIR) if f.endswith(".csv")]

for csv_file in csv_files:
    df = pd.read_csv(os.path.join(INPUT_DIR, csv_file))
    plt.figure(figsize=(8,5))

    numeric_cols = df.select_dtypes(include='number').columns
    if len(numeric_cols) >= 1:
        x_col = df.columns[0]
        for y_col in numeric_cols:
            plt.plot(df[x_col], df[y_col], label=y_col)
        plt.xlabel(x_col)
        plt.ylabel("Value")
        plt.title(f"Plot of {csv_file}")
        plt.legend()
        plt.tight_layout()
        plt.savefig(os.path.join(OUTPUT_DIR, csv_file.replace(".csv",".png")))
    plt.close()

print(f"All plots saved in {OUTPUT_DIR}")
