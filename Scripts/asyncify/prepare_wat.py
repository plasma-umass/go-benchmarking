import sys
import re

with open(sys.argv[1], 'r') as wat_input_f:
    wat = wat_input_f.read()

terms_per_yield_log2 = int(sys.argv[2])
and_const = 2**terms_per_yield_log2 - 1

wat = re.compile(r'\$TERMS_PER_YIELD').sub(f'{and_const}', wat)
print(wat)