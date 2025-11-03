#!/usr/bin/bash
# quit script if any of the commands fails. Note that && commands should be in parentheses for this to work.
set -eo pipefail
trap 'exit_status="$?" && echo Failed on line: $LINENO at command: $BASH_COMMAND && echo "exit status $exit_status"' ERR

#check that the script was called with 1 argument
if [ $# -gt 2 ]
then
                echo "
                    Usage: bash $0 -d <experiment_directory> -j <json_filepath>
                    Either -d or -j are required but both can not be used.
                    "
                exit 1
fi

# Defaults
experiment_dir=""
json_file=""

# Hantera flaggor med getopts
while getopts "d:j:" opt; do
    case $opt in
        d)
            experiment_dir="$OPTARG"
            echo "run folder $experiment_dir"
            if [ -d "$experiment_dir" ]; then
                my_json=$(ls "$experiment_dir/"*.json | head -n 1)
            else
                echo "
                    Usage: bash $0 -d <experiment_directory> -j <json_filepath>
                    Either -d or -j are required
                    "
                exit 1
            fi
            ;;
        j)
            json_file="$OPTARG"
            echo "json $json_file"
            my_json="$json_file"
            if [ -f "$json_file" ]; then
                my_json="$json_file"
            else
                echo "
                    Usage: bash $0 -d <experiment_directory> -j <json_filepath>
                    Either -d or -j are required
                    $json_file is not a file
                    "
                exit 1
            fi
            ;;
        *)
            echo "
                 Usage: bash $0 -d <experiment_directory> -j <json_filepath>
                 Either -d or -j are required
                 "
            exit 1
            ;;
    esac
done

# Kontrollera att båda flaggorna angavs
if [[ -z "$experiment_dir" && -z "$json_file" ]]; then
  echo "
        Error.
        Usage: bash $0 -d <experiment_directory> -j <json_filepath>
        Either -d o -j are required
        "
  exit 1
fi
convert_qc_path=$(dirname $0)
mkdir extract_qc_temp || time_to_quit="TRUE"
if [[ $time_to_quit == "TRUE" ]];then
    echo "please remove extract_qc_temp before running the script"
    exit 1
fi
echo $convert_qc_path
cat $my_json | jq | grep "protocol_group_id" | head -n1  >> extract_qc_temp/extract_qc_temp_2.txt
echo "Löpnummer: ," >> extract_qc_temp/extract_qc_temp_2.txt
cat $my_json | jq | grep "STOPPED_PROTOCOL_ENDED" -A 40 > "extract_qc_temp/extract_qc_temp.txt" && 
cat $my_json | jq | grep "flow_cell_id" | head -n1  >> "extract_qc_temp/extract_qc_temp_2.txt"
echo "plexnivå_skip: ," >> "extract_qc_temp/extract_qc_temp_2.txt"
grep "estimated_selected_bases" extract_qc_temp/extract_qc_temp.txt >> "extract_qc_temp/extract_qc_temp_2.txt"
grep "read_count" extract_qc_temp/extract_qc_temp.txt >> "extract_qc_temp/extract_qc_temp_2.txt"
cat $my_json | jq | grep "n50" | tail -n1  >> "extract_qc_temp/extract_qc_temp_2.txt"
grep "basecalled_pass_read_count" extract_qc_temp/extract_qc_temp.txt >> "extract_qc_temp/extract_qc_temp_2.txt"
grep "basecalled_fail_read_count" extract_qc_temp/extract_qc_temp.txt >> "extract_qc_temp/extract_qc_temp_2.txt"
grep "basecalled_fail_bases" extract_qc_temp/extract_qc_temp.txt | head -n 1 >> "extract_qc_temp/extract_qc_temp_2.txt"
grep "basecalled_pass_bases" extract_qc_temp/extract_qc_temp.txt | head -n 1 >> "extract_qc_temp/extract_qc_temp_2.txt"
grep "start_time" extract_qc_temp/extract_qc_temp.txt | head -n 1 >> "extract_qc_temp/extract_qc_temp_2.txt"
grep "\"end_time\":" extract_qc_temp/extract_qc_temp.txt | head -n 1 >> "extract_qc_temp/extract_qc_temp_2.txt"
cat $my_json | jq | grep "model_type" | tail -n 1 >> "extract_qc_temp/extract_qc_temp_2.txt"
# saved as comment if we want this value later. Needs modification as the strufcture is not like the others.
#cat  "$my_json" | jq | grep "barcoding_configuration" -A 10 -B 10 | grep "barcoding_kits" -A 1 | tail -n 1 >> "extract_qc_temp/extract_qc_temp_2.txt"

sed  's/^[[:space:]]*//g' extract_qc_temp/extract_qc_temp_2.txt | tr -d '"' > "extract_qc_temp/extract_qc_temp_3.txt"
sed -i 's/:/,/' extract_qc_temp/extract_qc_temp_3.txt
sed -i 's/ //' extract_qc_temp/extract_qc_temp_3.txt

echo "created extract_qc_temp/extract_qc_temp_3.txt. Content:"
cat "extract_qc_temp/extract_qc_temp_3.txt"
echo ""
run_name=$(grep "protocol_group_id" "extract_qc_temp/extract_qc_temp_3.txt" | cut -d "," -f 2)
echo "Starting convert_qc.py"
python "${convert_qc_path}"/convert_qc.py "extract_qc_temp/extract_qc_temp_3.txt" "convert_qc_output_${run_name}.tsv"
echo "convert_qc.py finished"
echo ""
echo "Removing temporary files"
rm -r  extract_qc_temp
echo "End of script"
