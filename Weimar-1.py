# %%
# Import required libraries for database connection and data visualization
from sqlalchemy import create_engine, text
from sqlalchemy.types import Text
from mysql.connector import Error
from getpass import getpass
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl

# %%
# Database connection setup
user = "********"
password = getpass("MySQL password: ")
database = "***********"

engine = create_engine(f"mysql+pymysql://{user}:{password}@localhost/{database}")

# Test database connection
try:
    with engine.connect() as conn:
        # Wrap query in text() function
        result = conn.execute(text("SELECT '✅ Connection successful' AS status"))
        print(result.scalar())  # Fetch the first column of first row
except Exception as e:
    print(f"❌ Connection failed: {e}")

# %%
# Load data from the weighted averages table (created by our SQL script)
query = "SELECT * FROM weimar_weighted"

try:
    df = pd.read_sql(query, engine)
    print(f"✅ Data loaded successfully: {len(df)} records")
except Exception as e:
    print(f"❌ Data loading failed: {e}")
    raise


# %%
# Convert proportions to percentages for better readability
cols = ['U_avg', 'B_avg', 'W_avg', 'S_avg', 'D_avg']
df.loc[:, cols] = (df.loc[:, cols] * 100).round(1)


# %%
# Configure dark theme for somber historical visualization
plt.style.use('dark_background')
mpl.rcParams['axes.edgecolor'] = '#444444'
mpl.rcParams['axes.labelcolor'] = '#cccccc'
mpl.rcParams['xtick.color'] = '#cccccc'
mpl.rcParams['ytick.color'] = '#cccccc'
mpl.rcParams['figure.facecolor'] = '#222222'
mpl.rcParams['axes.facecolor'] = '#222222'
mpl.rcParams['legend.frameon'] = False
mpl.rcParams['font.family'] = 'DejaVu Sans'

# Create figure and axis
fig, ax = plt.subplots(figsize=(10, 6))

# Define color scheme and labels for each social class
colors = {
    'U_avg': '#b22222',   # dark red (unemployed)
    'B_avg': '#557799',   # dark grey (blue-collar)
    'W_avg': 'seashell',   # faded blue (white-collar)
    'S_avg': 'khaki',   # dim grey (self-employed)
    'D_avg': 'peru'    # almost black (domestic workers)
}

column_labels = {
    'U_avg': 'Unemployed',
    'B_avg': 'Blue-collar workers',
    'W_avg': 'White-collar workers',
    'S_avg': 'Self-employed',
    'D_avg': 'Domestic workers'
}

# Plot trend lines for each social class
for col in cols:
    ax.plot(
        df['year'], 
        df[col], 
        label=column_labels[col],
        color=colors[col], 
        linewidth=2, 
        marker='o', 
        markersize=5, 
        alpha=0.9
    )

# Add peak value annotations (excluding unfair 1933 elections)
for col in cols:
    # Find peak (excluding 1933)
    df_no1933 = df[df['year'] != '1933']
    peak_value = df_no1933[col].max()
    peak_row = df_no1933[df_no1933[col] == peak_value].iloc[0]
    peak_year = peak_row['year']

    # Set position: below for 'U_avg' and 'B_avg', above for others
    if col in ['U_avg', 'B_avg']:
        xytext = (0, -13)
        va = 'top'
    else:
        xytext = (0, 10)
        va = 'bottom'

    ax.annotate(
        f"{peak_value:.1f}%",
        (peak_year, peak_value),
        textcoords="offset points",
        xytext=xytext,
        ha='center',
        va=va,
        fontsize=11,
        color=colors[col],
        fontweight='normal'
        # bbox=dict(boxstyle="round,pad=0.25", fc="black", ec=colors[col], alpha=0.5)
    )

# Add legend and historical context
ax.legend(
    title="Social Class", 
    loc='upper left', 
    frameon=False, 
    fontsize=12, 
    title_fontproperties={'weight': 'bold', 'size' : 14}
)

# Mark 1933 as unfair elections with vertical line
if '1933' in df['year'].values:
    ax.axvline('1933', color='#cccccc', linestyle='--', linewidth=1)
    ax.text('1933', ax.get_ylim()[1]*1.03, '1933 elections \nwere not free or fair', color='darksalmon', fontsize=10, va='top', ha='center', alpha=1)

# Set chart title and axis labels
ax.set_title("Estimated Share of Nazi Votes per Social Class", fontsize=14, color='#ffffff', pad=15)
ax.set_xlabel("Year", fontsize=14)
ax.set_ylabel("Proportion (%)", fontsize=12)

# Create population statistics text box
table_text =  r'$\bf{Estimated\ Class\ }$' + '\n'
table_text += r'$\bf{Populations\ in\ 1933}$' + '\n'
table_text += '----------------------------------\n'
table_text += 'Unemployed: 5,855,018\n'
table_text += 'White-collar: 4,637,691\n'
table_text += 'Blue-collar: 10,142,385\n'
table_text += 'Self-employed: 5,299,809\n'
table_text += 'Domestic: 6,398,860'

# Add population statistics box to the chart
fig.text(
    0.02, 0.57,
    table_text,
    color = 'aliceblue',
    transform=ax.transAxes,
    fontfamily='DejaVu Sans',
    fontsize=11,
    verticalalignment='top',
    horizontalalignment='left',
    bbox=dict(boxstyle='round,pad=0.5', facecolor='lightblue', alpha=0.1)
)

# Add disclaimer about data estimates
plt.figtext(
    0.01, -0.05,    
    "* The numbers and percentages are not historical records, but estimates of a \n"
    "2008 Harvard Study. The figures are generated by analyzing electoral and census \n"
    "data, together with various studies. A degree of uncertainty is expected.",
    fontsize=9,
    ha='left',
    va='bottom',
    color='wheat'
)

# Add data source attribution
x, y = 0.8, 0.00
text_str = "Data source: Harvard Dataverse"
bbox_props = dict(boxstyle="round,pad=0.5", edgecolor="black", facecolor="firebrick", alpha=0.3, linewidth=1)
fig.text(x, y, text_str, ha='center', va='center', fontsize=13, color="peachpuff", bbox=bbox_props)

# Apply subtle grid and formatting
ax.yaxis.grid(True, color='#444444', linestyle='--', linewidth=0.6, alpha=0.5)
ax.xaxis.grid(False)

# Save and display the chart
plt.tight_layout()

plt.savefig(
    'weimar_elections_class',
    dpi=300,
    bbox_inches='tight',
    pad_inches=0.1,
    facecolor='black'
)

plt.show()