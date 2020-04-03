import datetime
from os.path import dirname, join

import pandas as pd
from scipy.signal import savgol_filter

from bokeh.io import curdoc
from bokeh.layouts import column, row
from bokeh.models import ColumnDataSource, DataRange1d, Select
from bokeh.palettes import Blues4
from bokeh.plotting import figure


def get_dataset(src, name, distribution):
    df = src[src.airport == name].copy()
    del df['airport']
    df['date'] = pd.to_datetime(df.date)
    # timedelta here instead of pd.DateOffset to avoid pandas bug < 0.18 (Pandas issue #11925)
    df['left'] = df.date - datetime.timedelta(days=0.5)
    df['right'] = df.date + datetime.timedelta(days=0.5)
    df = df.set_index(['date'])
    df.sort_index(inplace=True)
    if distribution == 'Smoothed':
        window, order = 51, 3
        for key in STATISTICS:
            df[key] = savgol_filter(df[key], window, order)

    return ColumnDataSource(data=df)


dat_raw = pd.read_excel('raw_data.xlsx',sheet_name='Sheet1')
dat_pf = dat_raw[['Force Norm BW Left', 'Force NrmBW Right']].mean(axis=1)

path = (r'C:\Users\juliu\Desktop\NG_kiel\moonwalk_CliH\04_data\00_rawdata\raw_data.xlsx')


df = pd.read_excel(join(dirname(__file__), '04_data\00_rawdata\raw_data.xlsx'),sheet_name='Sheet1')


from statsmodels.stats.multicomp import pairwise_tukeyhsd

tukey = pairwise_tukeyhsd(endog=dat_pf,     # Data
                          groups=dat_raw['AlterG % BW','Gradient','Speed'],  # Groups
                          alpha=0.05)          # Significance level

tukey.plot_simultaneous()    # Plot group confidence intervals
plt.vlines(x=49.57,ymin=-0.5,ymax=4.5, color="red")

tukey.summary()              # See test summary

