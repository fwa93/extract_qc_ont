# extract_qc_ont
# 
The only requirement are Python and bash.

The script has been tested on the json-report from MinION Mk1B with flowcell FLO-MIN114 and kit SQK-16S114-24 with the following software versions:  
MinKNOW  
25.05.14  
Bream  
8.5.4  
Configuration  
6.5.7  
Dorado  
7.9.8  
MinKNOW Core  
6.5.14  

# Quick start
1. Clone the repository
2. Run like this with the path to the json report file  
'''  
./extract_qc.sh report_xxxxx_xxxx_xxxxx_xxxx.json  
'''  

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
- start_time
- end_time
- model_name

The resulting file content can easily be pasted into an excel sheet. 


