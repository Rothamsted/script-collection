'''
Created on 2 Oct 2014

@author: pakk
'''

if __name__ == '__main__':
	
	coverages = []
	
	window = 300
	
	pileup = 'H:\\unmapped_R1_3002.fastq.sam.sort.bam.mpileup'
	
	with open(pileup) as f: 
		for line in f:
			value = int(line.split("\t")[3])
			coverages.append(value)
	
	start_opt_window = 0
	max_sum = 0
	for n in range(0, len(coverages) - window):
		subset = coverages[n:n+window]
		
		if(sum(subset) > max_sum):
			#print(n, sum(subset), subset)
			start_opt_window = n
			max_sum = sum(subset) 
			
	c = 0	
	with open(pileup) as f: 
		for line in f:
			c +=1
			if(c == start_opt_window):
				chromosome = line.split('\t')[0]
				beg = int(line.split('\t')[1])
				end = beg + window
				print(chromosome, beg, end)
				break
	
	