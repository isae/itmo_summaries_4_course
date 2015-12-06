from collections import defaultdict
from math import log
import os
from random import shuffle

legit_label = "legit"
spam_label = "spmsg"

# features extracting way
both = "both"
subjects = "subjects"
bodies = "bodies"


def main(dataset_path="./dataset_dir", train_size=0.8, way=both, k_folds=10):
    assert 0 < train_size < 1, "Train dataset size not in (0, 1)"
    assert way in [both, subjects, bodies], "Third arg be equal to " \
                                            "{} | {} | {}".format(both,
                                                                  subjects,
                                                                  bodies)

    save_dir = os.getcwd()
    os.chdir(dataset_path)

    files = os.listdir()
    shuffle(files)
    dataset = [get_features(open(file), way) for file in files]
    left = int(train_size * len(dataset))
    right = len(dataset)
    train_set = dataset[0:left]
    cross_validation(train_set, k_folds)

    print("Start classifying...")
    classifier = train(train_set)
    percentage = classify(classifier, dataset[left:right])
    print("result = {}%".format(round(percentage, 1)))

    os.chdir(save_dir)


def get_features(file, way=both):
    label = legit_label if legit_label in file.name else spam_label

    subjects_feats = file.readline().split()[1:]
    file.readline()  # skip blank line
    bodies_feats = file.readline().split()

    if way == subjects:
        feats = subjects_feats
    elif way == bodies:
        feats = bodies_feats
    else:
        feats = subjects_feats + bodies_feats

    return feats, label


def cross_validation(dataset, k_folds=10):
    print("Cross validation:")
    fold_size = len(dataset) / k_folds
    total_percentage = 0
    for i in range(k_folds):
        left = int(i * fold_size)
        right = int((i + 1) * fold_size)
        classifier = train(dataset[0:left] + dataset[right:len(dataset)])
        percentage = classify(classifier, dataset[left:right])

        print("k = {}, {}%".format(i, round(percentage, 1)))
        total_percentage += percentage

    print("Average percentage = {}%"
          .format(round(total_percentage / k_folds, 1))
          )


def train(samples):
    classes, freq = defaultdict(lambda: 0), defaultdict(lambda: 0)
    for feats, label in samples:
        classes[label] += 1  # count classes frequencies
        for feat in feats:
            freq[label, feat] += 1  # count features frequencies

    for label, feat in freq:  # normalize features frequencies
        freq[label, feat] /= classes[label]
    for c in classes:  # normalize classes frequencies
        classes[c] /= len(samples)

    return classes, freq  # return P(C) and P(O|C)


def classify(classifier, dataset):
    hits = 0
    for feats, label in dataset:
        algo_label = classify_one(classifier, feats)
        if algo_label == label:
            hits += 1
    return hits / len(dataset) * 100


def classify_one(classifier, feats):
    classes, prob = classifier

    def get_prob(cl):  # calculate argmin(-log(C|O))
        feats_prob = (-log(prob.get((cl, feat), 10 ** (-7))) for feat in feats)
        return -log(classes[cl]) + sum(feats_prob)

    return min(classes.keys(), key=get_prob)
