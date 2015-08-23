from collections import defaultdict
import csv


def make_ngrams(proc_file, n):
    """Finds n-grams and calculates their frequencies.

    Args:
        proc_file (.txt): file containing text preprocessed by process_text().
        n (int): the number of words in n-gram.

    Returns:
        frequency dictionary of n-grams.
    """
    # only considering for up to 4-grams:
    #exclude = {1: 'UNK', 2: 'UNK UNK', 3: 'UNK UNK UNK', 4: 'UNK UNK UNK UNK'}
    dct = defaultdict(int)

    with open(proc_file, 'rb') as in_file:
        for line in in_file:

            line_list = line.split()
            for i in range(len(line_list)-n):
                ngram = ' '.join(line_list[i:i+n])
                #  since we will use the last word of n-gram for prediction of the next word, the last word of n-gram cannot be UNK.
                if ngram[-3:] != 'UNK':
                    dct[ngram] += 1

    #dct.pop(exclude[n]) # remove n-grams consisting only from UNKs.
    return dct

processed_text = "processed_UNK.txt"


freq_dict1 = make_ngrams(processed_text, 1)  # unigrams
print "Number of unique unigrams :", len(freq_dict1)

freq_dict2 = make_ngrams(processed_text, 2)  # bigrams
print "Number of unique bigrams :", len(freq_dict2)

freq_dict3 = make_ngrams(processed_text, 3)  # trigrams
print "Number of unique trigrams :", len(freq_dict3)
freq_dict3_1 = {k: freq_dict3[k] for k in freq_dict3 if freq_dict3[k] > 3}
print "after cut-off dict3_1 :", len(freq_dict3_1)

freq_dict4 = make_ngrams(processed_text, 4)  # fourgrams
print "Number of unique fourgrams :", len(freq_dict4)
freq_dict4_1 = {k: freq_dict4[k] for k in freq_dict4 if freq_dict4[k] > 3}
print "after cut-off dict4_1 :", len(freq_dict4_1)


# write data into a .csv files:
with open('unigrams.csv', 'wb') as f1:
    w1 = csv.writer(f1)
    w1.writerows(freq_dict1.items())

with open('bigrams.csv', 'wb') as f2:
    w2 = csv.writer(f2)
    w2.writerows(freq_dict2.items())

with open('trigrams.csv', 'wb') as f3:
    w3 = csv.writer(f3)
    w3.writerows(freq_dict3_1.items())

with open('fourgrams.csv', 'wb') as f4:
    w4 = csv.writer(f4)
    w4.writerows(freq_dict4_1.items())
