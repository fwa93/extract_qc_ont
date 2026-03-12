# extract_qc_ont
# 
The only requirement are Python and bash.

The script has been tested on the json-report from MinION Mk1B with flowcell FLO-MIN114 and kit SQK-16S114-24 with the following software versions:  

MinKNOW
25.09.16
Bream
8.8.3
Configuration
6.8.9
Dorado
7.11.2
MinKNOW Core
6.8.11

# Quick start
./extract_qc.sh
        Usage: bash ./extract_qc.sh -d <experiment_directory> -j <json_filepath>
        Either -d o -j are required

1. Clone the repository
2. Run like this with the path to the json report file or the directory containing the json-file. Output dir is required 
```  
./extract_qc.sh -j report_xxxxx_xxxx_xxxxx_xxxx.json  -o <results dir>
```  
Or
```
./extract_qc.sh -d <directory containing the report*json> -o <results dir>  
```  



#  Output
The script creates a tsv file containing information about:
- protocol_group_id
- Löpnummer. This is a number e.g., a serial number of protocol_group_id. Example: if protocol_group_id is Run_30_250202 then '30' is reported.  
 If this pattern (character_digits_digits) is not used for protocol_group_id 'Löpnummer' will become "none"
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

Fields that are not found in the json file will be "none" in the resulting table.
The resulting file content can easily be pasted into an excel sheet. 


