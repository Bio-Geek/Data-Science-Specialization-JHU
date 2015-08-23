import csv
from collections import defaultdict

filename1 = "unigrams.csv"
filename2 = "bigrams.csv"
filename3 = "trigrams.csv"
filename4 = "fourgrams.csv"

processed_text = "processed_UNK.txt"


## Count N (for stupid back-off) - the number of tokens in processed corpora:
def count_n(proc_text):
    """Counts the number of tokens (N) in corpora for "stupid backoff".
    """
    count = 0
    with open(proc_text, 'rb') as in_file:
        for line in in_file:
            words_list = line.split()
            for word in words_list:
                count += 1
    return count

N = count_n(processed_text)
print "N = ", N


def make_dict(filename, k):
    """Read csv file consiting of a pair of ['n-gram', 'frequincy'] on each line
    and create a dictionary with frequency cut-off k. The csv files were created
    by "new_processin.py" module.
    """
    dct = {}
    with open(filename, 'rb') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            count = int(row[1])
            if count > k:
                dct[row[0]] = count
    print "Created a dictionary with number of tokens: ", len(dct)
    return dct


unigrams = make_dict(filename1, 70)

unigrams.pop('SOTS')
unigrams_set = set(key for key in unigrams) # we will need the set later.

bigrams = make_dict(filename2, 25)
trigrams = make_dict(filename3, 15)
fourgrams = make_dict(filename4, 4)


# helper functions:
def first_from_bigrams():
    """Count frequencies of the first words in bigrams.
    """
    dct = defaultdict(int)
    for bigram in bigrams:
        words = bigram.split()
        first_word = words[0]
        dct[first_word] += 1

    print "Number of unique first words in bigrams :", len(dct)
    return dct


def first_two_from_trigrams():
    """Count frequencies of the combinations of first two words in trigrams.
    """
    dct = defaultdict(int)
    for trigram in trigrams:
        words = trigram.split()
        first_two_words = ' '.join(words[:2])
        dct[first_two_words] += 1

    print "Number of unique first two-words in trigrams :", len(dct)
    return dct


def first_three_from_fourgrams():
    """Count frequencies of the combinations of first three words in fourgrams.
    """
    dct = defaultdict(int)
    for fourgram in fourgrams:
        words = fourgram.split()
        first_three_words = ' '.join(words[:3])
        dct[first_three_words] += 1

    print "Number of unique first three-words in fourgrams :", len(dct)
    return dct


first_one_in_bigrams = first_from_bigrams()
first_two_in_trigrams = first_two_from_trigrams()
first_three_in_fourgrams = first_three_from_fourgrams()


# "Stupid back-off" algorithm implementation:
def bigram_predictions():
    """Creates a dictionary of the next word prediction for one word entered.
    Using bigrams and unigrams.
    """
    bigram_dict = {}
    add_set = set(['SOTS', 'UNK']) #  to cover the cases for UNK as the first word and the beggining of the sentence.
    unigrams_set_w1 = unigrams_set.union(add_set)

    for w1 in unigrams_set_w1:
        max_score = 0
        max_word = 'the'
        for w2 in unigrams_set:
            score = 0
            w1w2 = w1 + ' ' + w2

            if w1w2 in bigrams:
                score = bigrams[w1w2]/first_one_in_bigrams[w1]
            else:
                score = 0.4*unigrams[w2]/N

            if score > max_score:
                max_score = score
                max_word = w2

        bigram_dict[w1] = max_word
    print "Created dict of the next word for one word entered. Length: ", len(bigram_dict)
    return bigram_dict


def trigram_predictions():
    """Creates a dictionary of the next word prediction for two words entered.
    Using trigrams, bigrams, unigrams.
    """

    trigram_dict = {}

    for w1w2 in bigrams:
        max_score = 0
        max_word = 'the'
        for w3 in unigrams:
            score = 0
            w1w2w3 = w1w2 + ' ' + w3
            w2 = w1w2.split()[1]
            w2w3 = w2 + ' ' + w3

            if w1w2w3 in trigrams:
                score = trigrams[w1w2w3]/first_two_in_trigrams[w1w2]
            elif w2w3 in bigrams:
                score = 0.4*bigrams[w2w3]/first_one_in_bigrams[w2]
            else:
                score = 0.16*unigrams[w3]/N

            if score > max_score:
                max_score = score
                max_word = w3

        trigram_dict[w1w2] = max_word
    print "Created dict of the next word for given bigram. Length: ", len(trigram_dict)
    return trigram_dict


def fourgram_predictions():
    """Creates a dictionary of the next word prediction for three words entered.
    Using fourgrams, trigrams, bigrams, unigrams.
    """

    fourgram_dict = {}

    for w1w2w3 in trigrams:
        max_score = 0
        max_word = 'the'
        for w4 in unigrams:
            score = 0
            w1w2w3w4 = w1w2w3 + ' ' + w4
            w1 = w1w2w3.split()[0]
            w2 = w1w2w3.split()[1]
            w3 = w1w2w3.split()[2]
            w1w2 = w1 + ' ' + w2
            w2w3 = w2 + ' ' + w3
            w3w4 = w3 + ' ' + w4
            w2w3w4 = w2 + ' ' + w3w4

            if w1w2w3w4 in fourgrams:
                score = fourgrams[w1w2w3w4]/first_three_in_fourgrams[w1w2w3]
            elif w2w3w4 in trigrams:
                score = 0.4*trigrams[w2w3w4]/first_two_in_trigrams[w2w3]
            elif w3w4 in bigrams:
                score = 0.16*bigrams[w3w4]/first_one_in_bigrams[w3]
            else:
                score = 0.064*unigrams[w4]/N

            if score > max_score:
                max_score = score
                max_word = w4

        fourgram_dict[w1w2w3] = max_word
    print "Created dict of the next word for given trigram. Length: ", len(fourgram_dict)
    return fourgram_dict


# To save predictions into a scv files for further precessing in R:
def make_csv_table(ngram_dict, csv_name):
    """Creates csv table of the next word (second column) depending on
    the previous word/words (first column).

    Args:
        ngram_dict: dictionary with a key as n-gram and value as the next word prediction.
        csv_name (str): the name of the file where prediction table will be saved.

    Returns:
        None
    """
    with open(csv_name, 'wb') as f:
        w = csv.writer(f)
        w.writerows(ngram_dict.items())


## Now, make predictions:
bigram_pred_dict = bigram_predictions()
trigram_pred_dict = trigram_predictions()
fourgram_pred_dict = fourgram_predictions()


make_csv_table(bigram_pred_dict, "bigrams_predictions.csv")
make_csv_table(trigram_pred_dict, "trigrams_predictions.csv")
make_csv_table(fourgram_pred_dict, "fourgrams_predictions.csv")

## make unigram csv table without counts (just one row):
with open('unigrams_predictions.csv', 'wb') as f2:
    w2 = csv.writer(f2)
    w2.writerows([(key,) for key in unigrams])
