'''
Created on 8 Oct 2014

@author: keywan hassani-pak
'''

import unittest
import find_high_cov


class Test(unittest.TestCase):

    #test for provided mpileup file with window size 300
    def test_example1(self):
        self.assertEqual(('Chromosome_4', 1518919),
                         find_high_cov.findMaxCov('test_data/example.mpileup', 300))
        


if __name__ == "__main__":
    unittest.main()
