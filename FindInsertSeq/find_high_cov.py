#!/usr/bin/env python

'''
Created on 2 Oct 2014

Simple script to identify most likely plasmid isertion site based on finding
a sliding window with maximum read coverage (similar to peak detection).

@author: keywan hassani-pak
'''

import argparse


def findMaxCov(file, window):
        coverages = []
        positions = {}
        c = 0
        with open(file) as f:
                for line in f:
                    col = line.split('\t')
                    loci = col[0]         
                    pos = int(col[1])
                    value = int(col[3])
                    positions[c] = (loci, pos)
                    coverages.append(value)
                    c +=1

        start_opt_window = 0
        max_sum = 0
        for n in range(0, len(coverages) - window):
                subset = coverages[n:n+window]

                if(sum(subset) > max_sum):
                    start_opt_window = n
                    max_sum = sum(subset)

        return (positions[start_opt_window][0], positions[start_opt_window][1])



if __name__ == '__main__':
        parser = argparse.ArgumentParser(description="Find coverage peak in mpileup file to suggest most likely plasmid insertion site.")
        parser.add_argument('mpileup_file', help='mpileup input file')
        parser.add_argument('-w', '--window', metavar='N', default=300, type=int, help="size of sliding window (default: 300)")
        args = parser.parse_args()
        window = args.window
        file = args.mpileup_file
        (loci, beg) = findMaxCov(file, window)
        print('Found max coverage window of size', window, 'at:', loci, beg, '-', beg + window)




