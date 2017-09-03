import os
import regex as re
import numpy as np
import pandas as pd
import matplotlib as plt

scriptdir = os.path.dirname(os.path.abspath(__file__))
sp_file = os.path.join(scriptdir, "trainingtext.txt")
with open(sp_file, 'r', encoding='utf8') as file:
    print(file.readline())
    train = file.read()

pattern = '^%^'
print(re.findall(pattern, train))
