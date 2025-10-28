# extract_qc_ont
# Quick start
Requirement:Python and bash.
1. Clone the repository
2. Run like this with the path to the json report file  
'''./extract_qc.sh report_FBA58159_20250220_1521_c969a030.json'''

#  Output
The script creates a tsv file containing information about:
- protocol_group_id
- flow_cell_id
- estimated_selected_bases
- read_count
- n50
- basecalled_pass_read_count
- basecalled_fail_read_count
- basecalled_fail_bases
- basecalled_pass_bases

The resulting file content can easily be pasted into an excel sheet. 

