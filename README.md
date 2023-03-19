Migrated the shell scripts to Java for readability
Moved shell code to shell branch

Note input file the surveys is expected to be tsv with name ```input.tsv```

Step 1:
Replace the path to input files in the following line:
    final static String PATH = "PUT THE ABSOLUTE PATH"; 

Step 2: 
Run and generate the outpur.tsv

java  Migrator.java | grep ggg | sed 's/ggg//g' | tee output.tsv
