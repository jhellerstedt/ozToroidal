#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Nov 17 21:47:51 2019

@author: jack
"""

import numpy as np

file = '671-Ag(100) Re Mount--21.2Ph-16.8Ke-Azimuth.txt'

with open(file, 'rb') as f:
    lines = f.readlines()
    
## header line is 0
    
header_raw = lines[0].split(b'\r')


header_dict = {}
comment_string = ''

for header_line in header_raw[1:]: ## John Riley first line has non utf-8 in it
    if header_line.decode('utf-8') == '***':
        ## end of header
        break
    try:
        header_item = header_line.split(b'\t\t')[0].decode('utf-8')
        header_content = header_line.split(b'\t\t')[1].decode('utf-8')
        header_dict[header_item] = header_content
    except:
        comment_string += header_line.decode('utf-8') + '\n'
header_dict['comments'] = comment_string

## mirror current is between the *** at the end of the first line

mirror_array = header_raw[-2].split(b'\t')
mirror_array = [float(ii.decode('utf-8')) for ii in mirror_array]

### read in the data

## initialize array according to scan parameters
shape = (int(float(header_dict['Angular divisions: ']))+1, 
         int(float(header_dict['Number of steps']))+1,
         int(float(header_dict['Number of energy data sets: ']))
         )
data = np.empty(shape=shape)

ang_indexer = 0
energy_indexer = 0
for line in lines[2:]:
    if line.split(b'\r')[1] == b'***':
        print(line)
        break
    elif line == b'\r\n':
        ang_indexer = 0
        energy_indexer += 1
    elif b'[' in line:
        pass
    else:
        dd = line.split(b'\t')
        dd = [int(ii.decode('utf-8')) for ii in dd]
        data[ang_indexer,:,energy_indexer] = dd
        ang_indexer += 1



# ### gif the data
#
# import matplotlib.pyplot as plt
# from celluloid import Camera
#
# fig = plt.figure()
# camera = Camera(fig)
#
# for ii in range(data.shape[2]):
#     fig.gca().imshow(data[:,:,ii])
#     camera.snap()
#
# ani = camera.animate(blit=True, interval=100)
# ani.save('out.mp4')
