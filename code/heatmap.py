# -*- coding: utf-8 -*-
"""
Created on Tue Feb 27 11:01:55 2018

@author: iagalliadis
"""

import plotly.plotly as py
import plotly.figure_factory as ff

#plotly.tools.set_credentials_file(username='iagalliadis', api_key='8YQQ0s9WZUBoXtQQwgnq')

#py.sign_in(“iagalliadis”, “8YQQ0s9WZUBoXtQQwgnq”)

z=[[68.1,69.7,67.0,72.0,71.3,74.2,73.2,72.9,74.2,73.0,74.1,73.3,74.6],
    [61.0,66.0,63.7,65.0,67.8,71.1,68.6,71.0,63.2,71.6,71.8,70.1,70.0],
    [63.5,70.5,72.4,71.4,74.0,73.0,74.0,72.3,74.8,73.8,73.8,74.1,74.5],
    [67.0,68.4,70.0,71.5,72.5,73.8,73.5,72.2,72.8,74.2,74.0,73.1,73.7],
    [61.0,69.2,68.4,72.1,71.0,74.2,71.7,73.5,74.0,72.3,74.6,74.3,74.3],
    [68.0,67.1,71.2,71.1,71.5,72.6,73.0,73.6,73.5,73.0,73.7,74.1,74.9],
    [66.0,69.5,69.7,70.5,72.5,74.1,74.3,73.5,72.1,74.1,74.2,74.4,74.9],
    [64.4,68.4,69.1,69.4,70.5,72.3,73.8,74.3,74.4,74.8,73.7,74.0,74.8],
    [66.0,67.0,70.7,73.0,67.0,71.5,73.2,72.0,71.5,73.4,72.5,74.8,74.6]]
  
y = ['smooth','rms','stft','haar','db8','bior13','bior22','coif3','coif4']
    
x = ['Layer 1','Layer 2','Layer 3','Layer 4','Layer 5','Layer 6','Layer 7','Layer 8','Layer 9','Layer 10','Layer 11','Layer 12','Layer 13']

fig = ff.create_annotated_heatmap(z, x=x, y=y, colorscale='Viridis')

py.iplot(fig, filename='annotated_heatmap')