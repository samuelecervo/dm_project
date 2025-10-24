import pandas as pd
import glob

# prende tutti i file tipo popolazioneXXXX.csv
files = sorted(glob.glob("../data-raw/popolazione*.csv"))

all_data = []

for f in files:
    print(f"Processing {f}...")
    df = pd.read_csv(f, encoding="utf-8", sep=",")
    
    # pulizia dei nomi colonna (rimuove eventuali virgolette o spazi)
    df = df.rename(columns=lambda c: c.strip().replace("'", "").replace('"', ''))
    
    # tiene solo le colonne che servono
    keep = ["TIME_PERIOD", "Territorio", "Sesso", "Osservazione"]
    df = df[keep]
    
    # rinomina per chiarezza
    df = df.rename(columns={
        "TIME_PERIOD": "year",
        "Territorio": "region",
        "Sesso": "sex",
        "Osservazione": "population"
    })
    
    # rimuove righe senza popolazione
    df = df.dropna(subset=["population"])
    
    # converte la popolazione in intero (gestisce virgole e punti)
    df["population"] = (
        df["population"]
        .astype(str)
        .str.replace(".", "", regex=False)
        .str.replace(",", ".", regex=False)
        .astype(float)
        .astype(int)
    )
    
    all_data.append(df)

# unisce tutti i dataset in un unico DataFrame
final_df = pd.concat(all_data, ignore_index=True)

# salva il risultato
final_df.to_csv("../data-clean/population_by_region_sex_2019_2024.csv", index=False, encoding="utf-8")

print("Creato population_by_region_sex_2019_2024.csv")
print(final_df.head())
