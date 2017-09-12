import os
import regex as re
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import string
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from collections import Counter

#-----importing files----#
scriptdir = os.path.dirname(os.path.abspath(__file__))
train_txt = os.path.join(scriptdir, "trainingtext.txt")
with open(train_txt, 'r', encoding='utf8') as file:
    train = file.read()
scriptdir2 = os.path.dirname(os.path.abspath(__file__))
train_csv = os.path.join(scriptdir2, "training_variants.csv")
train_var = pd.read_csv(train_csv, header=0, index_col=0)
#print(len(train_var)) #3321

#----turning training text file into dataframe----#
train_split_line = re.split('\n+', train)
train_split_delim = [re.split(r"\^\%\^", entry, 2) for entry in train_split_line]
train_split_new = train_split_delim[1:]
train_ind = [item[0] for item in train_split_new]
train_text = [text[-1] for text in train_split_new]
train_text_new = train_text[:-1]
train_mer = train_var.copy() #merging var and text files together
train_mer['Text'] = train_text_new
#print(train_mer.shape) #(3321, 4)
#print(train_mer.info())

#----basic cleaning----#

##remove null values
null_mask = train_mer['Text'].str.contains('^null')
contain_null = train_mer['Text'].loc[null_mask]
#print(contain_null) #consistent with before: 1109, 1277, 1407, 1639, 2755; 448 and 1385 have articles behind "null"
null_ind = 1109, 1277, 1407, 1639, 2755
trainmer_new = train_mer.drop(train_mer.index[[null_ind]])
#print(trainmer_new.info()) #cleaning "null" entries: (3316, 4) after the five null entries are deleted
trainmer_new.loc[[448, 1385], 'Text'] = trainmer_new['Text'].loc[[448, 1385]].str.replace('null', ' ')
#print(trainmer_new.iloc[[448, 1385]]) #replaced the "null" in front of text with empty string

##convert gene and class into category type
trainmer_new.Gene = trainmer_new.Gene.astype('category')
trainmer_new.Class = trainmer_new.Class.astype('category')
#print(trainmer_new.iloc[[448, 1385]])
#print(trainmer_new.info())

#----exploratory analysis----#

##Class frequency
#class_freq = trainmer_new.groupby('Class')['Gene'].count()
#fig1 = plt.figure(1)
#classfreq = fig1.add_plot(221)
#classfreq = class_freq.plot(kind='bar', use_index=True, title='Class frequency')
#classfreq.set_xlabel('Class')
#for tick in classfreq.get_xticklabels():
#    tick.set_rotation(90)
#classfreq.set_ylabel('Frequency')

#Text frequency
#text_freq = trainmer_new.groupby('Text')['Class'].count()
#textfreq = text_freq.plot(kind='bar', use_index=True, title='Text frequency')
#textfreq.set_xlabel('Class')
#for tick in classfreq.get_xticklabels():
#    tick.set_rotation(90)
#classfreq.set_ylabel('Frequency')

#Gene frequency
#gene_freq = trainmer_new.groupby('Gene')['Text'].count()
#print(gene_freq.sort_values(ascending=False))

#var_freq = trainmer_new.groupby('Variation')['Text'].count()
#print(var_freq.sort_values(ascending=False))

#print(trainmer_new[['Gene', 'Variation']].drop_duplicates()) #check if gene-var pairs are unique
trainmer_multiind = trainmer_new.set_index(['Gene', 'Variation']) #indexed by unique pairs of gene and variation
#print(trainmer_multiind.info()) #memory usage reduced from 256KB+ to 77KB+

#----preprocessing of text files----#

###Try first without removing Materials and Methods (ver A.)

##No spaces (ver A.1)
miTrainmer_A1 = pd.DataFrame(trainmer_multiind['Class'])
nospace_tokens = pd.Series([re.findall(r'\S+', text) for text in trainmer_multiind['Text']]) #nospace_tokens.values return series of lists with "list()"; the part inside is just a list of list
miTrainmer_A1['NoSpacesTokens'] = nospace_tokens.values
#miTrainmer_A1.to_csv('NoSpacesTokens.csv', index_label=['Gene', 'Variation'], sep='\t')

##Best combo (ver A.2)
miTrainmer_A2 = pd.DataFrame(trainmer_multiind['Class'])

#for text in trainmer_multiind['Text']:
train_word = [[word.strip(string.punctuation) for word in text.split(" ")] for text in trainmer_multiind['Text']] #strip off standalone punctuations
no_stops_nopunc = [[t for t in text if t not in stopwords.words('english')] for text in train_word]
#wordnet_lemmatizer = WordNetLemmatizer()
#lemmatized_nostops_nopunc = [[wordnet_lemmatizer.lemmatize(t) for t in subtext] for subtext in no_stops_nopunc]

print(type(no_stops_nopunc), no_stops_nopunc[:1])
#best_combo = pd.Series(lemmatized_nostops_nopunc) #best_combo.values return multiple lists with just "[]"; if previous code is list of lists, then make this a list of lists before transforming to series
#    print(type(best_combo))
#miTrainmer_A2['BestComboTokens'] = best_combo.values
#miTrainmer_A2.to_csv('BestComboTokens.csv', index_label=['Gene', 'Variation'], sep='\t')
