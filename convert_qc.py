import sys
import csv

def parse_input_file(filename):
    data = {}
    with open(filename, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        for row in reader:
            if len(row) < 2:
                continue
            key = row[0].strip()
            val = row[1].strip()
            if val == '':
                continue
            data[key] = val
    return data

def convert_to_float(value):
    try:
        return float(value)
    except:
        return None

def main(input_file, output_file):
    data = parse_input_file(input_file)

    # Extrahera och räkna om värden
    protocol_group_id = data.get('protocol_group_id', '').rstrip(',')
    lopnummer = data.get('Löpnummer', '')
    flow_cell = data.get('user_specified_flow_cell_id', '')
    plexnivå = data.get('plexnivå_skip', '')
    start_time = data.get('start_time', '')
    end_time = data.get('end_time', '')
    model_type = data.get('model_type', "")
    Experiment_path = data.get('Experiment_path')

    estimated_bases = convert_to_float(data.get('estimated_selected_bases', ''))
    read_count = convert_to_float(data.get('read_count', ''))
    n50 = convert_to_float(data.get('n50', ''))
    basecalled_pass_read_count = convert_to_float(data.get('basecalled_pass_read_count', ''))
    basecalled_fail_read_count = convert_to_float(data.get('basecalled_fail_read_count', ''))
    basecalled_fail_bases = convert_to_float(data.get('basecalled_fail_bases', ''))
    basecalled_pass_bases = convert_to_float(data.get('basecalled_pass_bases', ''))

    # Omräkningar
    estimated_bases_mb = f"{estimated_bases / 1_000_000:.2f}" if estimated_bases is not None else ''
    reads_generated_m = f"{read_count / 1_000_000:.3f}" if read_count is not None else ''
    estimated_n50_kb = f"{n50 / 1000:.2f}" if n50 is not None else ''
    reads_called_pass_m = f"{basecalled_pass_read_count / 1_000_000:.3f}" if basecalled_pass_read_count is not None else ''
    reads_called_fail_k = f"{basecalled_fail_read_count / 1_000:.3f}" if basecalled_fail_read_count is not None else ''
    bases_called_failed_mb = f"{basecalled_fail_bases / 1_000_000:.3f}" if basecalled_fail_bases is not None else ''
    bases_called_pass_gb = f"{basecalled_pass_bases / 1_000_000_000:.3f}" if basecalled_pass_bases is not None else ''

    headers = [
        "Körning", "Löpnummer", "Flödescell", "Plexnivå",
        "Estimated Bases (Mb)", "Reads generated M", "Estimated N50 (kb)",
        "Reads called Pass (M)", "Reads called Fail (k)",
        "Bases called  Failed (Mb)", "Bases called  Pass  (Gb)", "Resultat_lokalisation", "start_time",
        "end_time", "model_type"
    ]

    values = [
        protocol_group_id, lopnummer, flow_cell, plexnivå,
        estimated_bases_mb, reads_generated_m, estimated_n50_kb,
        reads_called_pass_m, reads_called_fail_k,
        bases_called_failed_mb, bases_called_pass_gb, Experiment_path, start_time,
        end_time, model_type
    ]

    # Skriv ut TSV
    with open(output_file, 'w', encoding='utf-8', newline='') as out_f:
        writer = csv.writer(out_f, delimiter='\t')
        writer.writerow(headers)
        writer.writerow(values)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Usage: python {sys.argv[0]} inputfile outputfile")
        sys.exit(1)

    main(sys.argv[1], sys.argv[2])

