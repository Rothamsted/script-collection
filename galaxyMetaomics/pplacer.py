"""
pplacer.py Placing reads on the phylogenetic tree
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
     
    parser.add_option( '', '--tree',action="store",dest='tree', help='tree produced by raxml' )
    parser.add_option( '', '--info',action="store",dest='info', help='info file from raxml' )
    parser.add_option( '', '--refalignment',action="store",dest='refalignment', help='Alignment file from hmmalign' ) 
    parser.add_option( '', '--jplace',action="store",type="string", dest='jplace', help='placement file' )
    parser.add_option( '', '--origfname',action="store",type="string", dest='origfname', help='original alignment name' )
    parser.add_option( '', '--stat',action="store",type="string", dest='stat', help='output of run' )     
    (options, args) = parser.parse_args()
    words=[]    
    ext=".jplace"    
    tree=args[0]
    info=args[1]
    jplace=args[3]
    refalignment=args[2]
    stat=args[4]
    origfname=args[5]
    #words = origfname.split(".")
    #jplace=words[0]+ext    
    

    # We simply symlink the galaxy system filename to the original
    # filename to get SymD the protein name and the .pdb extension
    os.symlink(refalignment,origfname) 
       
    
    # These are the names of the output files as created by
    # SymD. We will need to copy these files back to
    # outfname1 and outfname2 above.
    symdinfofname = os.path.splitext(origfname)[0] + ".jplace"
    
    cmd = 'pplacer -t %s -s %s  %s %s > %s' % ( tree, info , origfname, jplace, stat )
    
    try:
        proc = subprocess.Popen(args=cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    except Exception, err:
        sys.stderr.write("Error invoking command: \n%s\n\n%s\n" % (cmd, err))
        sys.exit(1)
    stdout, stderr = proc.communicate()
    return_code = proc.returncode
    if return_code:
        sys.stdout.write(stdout)
        #sys.stderr.write(stderr)
        #sys.stderr.write("Return error code %i from command:\n" % return_code)
        #sys.stderr.write("%s\n" % cmd)
    else:
        sys.stdout.write(stdout)
        #sys.stdout.write(stderr)
   
    
    # Finally, copy the output files from SymD back to the data files.
    shutil.copy(symdinfofname,jplace)
    

if __name__ == '__main__':
    main()

