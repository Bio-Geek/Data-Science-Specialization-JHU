import re
from collections import defaultdict

# dictionary of mapping of substitutions:
substitutions = {"&": "and"}


file_name = "corpora.txt"
new_file = "sots.txt"


def insert_sots(txt_file, new_file):
    """Takes a text file, preprocess the text to lower characters and insert
    "Start of The Seantence" token (SOTS). Saves proccesed data into
        new txt file line by line.

    Args:
        txt_file (.txt): file name or a full path name for the file.
        new_file (.txt): name for a file where the proccesed text will be saved

    Returns:
        None
    """
    f = open(new_file, "w")  # file where the processed text will be written.

    with open(txt_file, 'rb') as in_file:

        for line in in_file:
            line = line.lower()  # convert to lower cases
            sentenses_list = re.split(r'[!?.]+', line)  # split line by punctuation

            for sentence in sentenses_list:
                sentence = sentence.strip()
                if len(sentence) > 2:
                    sots_sentence = 'SOTS ' + sentence
                    f.write("%s\n" % sots_sentence)
    f.close()

insert_sots(file_name, new_file)

file_name2 = "sots.txt"
new_file2 = "processed.txt"


def process_text(txt_file, processed_file):
    """Takes a text file, preprocess the text and saves proccesed data into
        new txt file line by line, where each line contains meaningfully
        connected text block (to create meaningful n-grams further down the line).

    Args:
        txt_file (.txt): file name or a full path name for the file.
        new_file (.txt): name for a file where the proccesed text will be saved

    Returns:
        None
    """
    f2 = open(processed_file, "w")  # file where the processed text will be written.

    with open(txt_file, 'rb') as in_file:

        for line in in_file:
            phrases_list = re.split(r'[!?.,;:()/]+', line)  # split line by punctuation

            for phrase in phrases_list:
                word_list = []
                for word in phrase.split():  # splits a string into list of words
                    if word in substitutions:
                        new_word = substitutions[word]
                        word_list.append(new_word)
                    # elif word in ['-', '--', '---', '----', '-----', "'", '"']: # removing separate dashes and apostrophs.
                    #     word_list.append(' ')

                    ## to keep words with a single dash or apostroph only if
                    ## they are in the middle of word,
                    ## and to remove other occurances of dashes and apostrophs:
                    elif "'" in word or "-" in word:
                        m = re.match(r"[a-zA-Z]+['-][a-zA-Z]+", word)
                        if m != None:
                            word_list.append(word)
                        else:
                            word1 = re.sub(r"[^a-zA-Z\s]+", ' ', word)
                            word_list.append(word1)
                    else:
                        word_list.append(word)

                new_phrase = ' '.join(word_list)  # converts list into a string

                ## final clean up of the text:
                clean_phrase = re.sub(r"[^a-zA-Z'\s-]+", ' ', new_phrase).strip()

                ## Only save a single letter on a new line if the letter
                ## is a legitimate word 'a', or 'i', Also do not save 'SOTS' if
                ## there is no words following them:
                if ((len(clean_phrase) > 1 or clean_phrase in ['a', 'i'])
                                              and clean_phrase != 'SOTS'):
                    f2.write("%s\n" % clean_phrase) #  save each phrase line by line:
    f2.close()

process_text(file_name2, new_file2)


def word_frequencies(proc_file):
    """Calculates frequencies of words.

    Args:
        proc_file (.txt): file containing text preprocessed by process_text().

    Returns:
        frequency dictionary of words.
    """
    dct = defaultdict(int)

    with open(proc_file, 'r') as in_file1:
        for line in in_file1:

            line_list = line.split()
            for word in line_list:
                dct[word] += 1
    return dct


file_name3 = "processed.txt"
new_file3 = "processed_UNK.txt"


def insert_unk(txt_file, processed_file, n):
    """Inserts "unknown" (UNK) token instead of low frequency words.
    Also cleans from remained dashes which are not part of a single word.

    Note:
        Uses function word_frequencies().

    Args:
        txt_file (.txt): file name or a full path name for the file.
        processed_file (.txt): name for a file where the proccesed text will be saved
        n (int): frequency cut-off

    Returns:
        None
    """
    freq_dict = word_frequencies(txt_file)
    print "Number of unique tokens :", len(freq_dict)
    low_freq_set = set(k for k in freq_dict if freq_dict[k] <= n)
    print "Number of unique low frequency tokens :", len(low_freq_set)

    f3 = open(processed_file, "w")  # file where the processed text will be written.

    with open(txt_file, 'rb') as in_file:

        for line in in_file:
            word_list = line.split()  # split line by space
            new_list = []
            for word in word_list:
                if word in low_freq_set:
                    new_list.append('UNK')
                else:
                    new_list.append(word)

            new_line = ' '.join(new_list)

            if new_line != 'UNK' and new_line != 'SOTS UNK':
                f3.write("%s\n" % new_line)
    f3.close()


insert_unk(file_name3, new_file3, 25)
