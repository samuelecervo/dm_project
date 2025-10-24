import pandas as pd
from pathlib import Path

# Percorsi relativi
BASE_DIR = Path(__file__).resolve().parent.parent  # sale di due livelli fino alla root del progetto
RAW_DIR = BASE_DIR / "data-raw"
CLEAN_DIR = BASE_DIR / "data-clean"

# File di input/output
input_file = RAW_DIR / "dcp_regions.csv"
output_file = CLEAN_DIR / "dcp_regions_clean.csv"

# Leggi CSV originale
df = pd.read_csv(input_file)

# Rinomina colonne
df = df.rename(columns={
    'data': 'date',
    'stato': 'country_code',
    'codice_regione': 'region_code',
    'denominazione_regione': 'region_name',
    'lat': 'latitude',
    'long': 'longitude',
    'ricoverati_con_sintomi': 'hospedalized',
    'terapia_intensiva': 'intensive_care',
    'totale_ospedalizzati': 'total_hospitalized',
    'isolamento_domiciliare': 'home_isolation',
    'totale_positivi': 'total_positive',
    'variazione_totale_positivi': 'variation_total_positive',
    'nuovi_positivi': 'new_positive',
    'dimessi_guariti': 'recovered',
    'deceduti': 'deaths',
    'casi_da_sospetto_diagnostico': 'suspected_cases',
    'casi_da_screening': 'screening_cases',
    'totale_casi': 'total_cases',
    'tamponi': 'swabs',
    'casi_testati': 'tested_cases',
    'ingressi_terapia_intensiva': 'intensive_care_admissions',
    'totale_positivi_test_molecolare': 'positive_molecular_test',
    'totale_positivi_test_antigenico_rapido': 'positive_rapid_antigen_test',
    'tamponi_test_molecolare': 'molecular_swabs',
    'tamponi_test_antigenico_rapido': 'rapid_antigen_swabs',
    'codice_nuts_1': 'nuts_1_code',
    'codice_nuts_2': 'nuts_2_code',
    'note': 'notes',
    'note_test': 'test_notes',
    'note_casi': 'case_notes'
})

# Trasforma date
df['date'] = pd.to_datetime(df['date']).dt.strftime('%Y-%m-%d')

# Codici regione a 2 cifre
df['region_code'] = df['region_code'].apply(lambda x: f"{int(x):02d}" if pd.notna(x) else "")

# Colonne numeriche: riempi NaN con 0
numerical_cols = [
    'hospitalized_with_symptoms', 'intensive_care', 'total_hospitalized', 'home_isolation',
    'total_positive', 'variation_total_positive', 'new_positive', 'recovered', 'deceased',
    'suspected_cases', 'screening_cases', 'total_cases', 'swabs', 'tested_cases',
    'intensive_care_admissions', 'positive_molecular_test', 'positive_rapid_antigen_test',
    'molecular_swabs', 'rapid_antigen_swabs'
]
df[numerical_cols] = df[numerical_cols].fillna(0).astype(int)

df = df[['date', 'region_code', 'hospedalized', 'new_positive', 'deceased', 'swabs']]


# Salva CSV pulito
CLEAN_DIR.mkdir(exist_ok=True)  # crea la cartella se non esiste
df.to_csv(output_file, index=False)

print(f"File pulito salvato in {output_file}")
