"""
Hmmer hmmalign
Class that will run hmmalign 
"""

import sys,os
import os, shutil, subprocess, sys, optparse, fnmatch, glob

def stop_err(msg):
    sys.stderr.write("%s\n" % msg)
    sys.exit()


def main():
    usage = """%prog [options]
options (listed below) default to 'None' if omitted
    """
    parser = optparse.OptionParser(usage=usage)
     
    parser.add_option( '', '--alignment',action="store",dest='alignment', help='Alignment file in stockholm format' )
    parser.add_option( '', '--hmmfile',action="store",dest='hmmfile', help='HMM file from hmmbuild' )
    parser.add_option( '', '--metagenome',action="store",dest='metagenome', help='Metagenome file' ) 
    parser.add_option( '', '--outfile',action="store", dest='outfile', help='hmmalign output file' )
    #parser.add_option( '', '--info',action="store", dest='info', help='Statistics from hmmalign run' ) 
    (options, args) = parser.parse_args()
    
    outfile=args[0]
    alignment=args[1]
    hmmfile=args[2]
    metagenome=args[3]
    #info=args[4]
    val='--mapali'
    
    cmd = 'hmmalign -o %s %s %s %s %s' % ( outfile, val ,alignment, hmmfile, metagenome )
    #print cmd
    #exit
    try:
        proc = subprocess.Popen(args=cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    except Exception, err:
        sys.stderr.write("Error invoking command: \n%s\n\n%s\n" % (cmd, err))
        sys.exit(1)
    stdout, stderr = proc.communicate()
    return_code = proc.returncode
    if return_code:
        sys.stdout.write(stdout)
        sys.stderr.write(stderr)
        sys.stderr.write("Return error code %i from command:\n" % return_code)
        sys.stderr.write("%s\n" % cmd)
    else:
        sys.stdout.write(stdout)
        sys.stdout.write(stderr)
    #os.system(hmmbuild  full_cmd)
    
    

if __name__ == '__main__':
    main()

