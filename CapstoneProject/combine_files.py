

file_name1 = "en_US.twitter.txt"
file_name2 = "en_US.blogs.txt"
file_name3 = "en_US.news.txt"

filenames = [file_name1, file_name2, file_name3]
path = "C:/Users/Max/Documents/Data_Science_Specialization/10_Capstone/data/corpora.txt"

with open(path, 'w') as outfile:
    for fname in filenames:
        with open(fname, 'rb') as infile:
            for line in infile:
                outfile.write(line)
