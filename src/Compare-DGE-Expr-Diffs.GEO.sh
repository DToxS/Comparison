#!/usr/bin/env bash
# This script compares the difference of gene expressions for DGE dataset.

# Initialize error code.
EXIT_CODE=0

# Set top directory.
DATASET_DIR="${HOME}/LINCSData/Datasets/Difference/LINCS.Dataset/Coen-Paper/DGE-GEO-Depot"
PROG_DIR="${DATASET_DIR}/Programs/Differential-Comparison"

# Set executable programs and function directory.
PROG_FILE_NAME="Compare-Expr-Diffs.GEO.sh"
PROG_FILE_PATH="${PROG_DIR}/${PROG_FILE_NAME}"
ANLYS_PROG_FILE_NAME="Compare-Molecule-Expression.R"
ANLYS_PROG_FILE_PATH="${PROG_DIR}/${ANLYS_PROG_FILE_NAME}"
FUNC_DIR="${PROG_DIR}/Library"

# Set the name pattern of configuration file.
CONFIG_FILE_MAIN_NAME_PREFIX="DGE-RNAseq-Configs"
CONFIG_FILE_EXT_NAME="tsv"
CONFIG_FILE_NAME_PTRN="${CONFIG_FILE_MAIN_NAME_PREFIX}*\.${CONFIG_FILE_EXT_NAME}"

# Set the main name of the configs and results directories.
CONFIG_DIR_NAME="Configs"
RESULTS_DIR_NAME="Results"

DATASET_SERIES_NAMES=("Dataset-20150409" "Dataset-20150503" "Dataset-20151120" "Dataset-20161108")
for DATASET_SERIES_NAME in "${DATASET_SERIES_NAMES[@]}"; do
    # Set the drectory of current dataset series as the repository.
	REPO_DIR="${DATASET_DIR}/${DATASET_SERIES_NAME}"
	if [ -d "${REPO_DIR}" ]; then
		DATE_SERIES_NAME="$(echo ${DATASET_SERIES_NAME} | cut -d - -f 2)"
		CONFIG_DIR="${REPO_DIR}/${CONFIG_DIR_NAME}"
		if [ -d "${CONFIG_DIR}" ]; then
			for CONFIG_FILE_PATH in $(find "${CONFIG_DIR}" -maxdepth 1 -type f -name "${CONFIG_FILE_NAME_PTRN}" -print); do
				# Generate the name of the Results directory.
				RESULTS_DIR="${REPO_DIR}/${RESULTS_DIR_NAME}"
				CONFIG_FILE_NAME="$(basename ${CONFIG_FILE_PATH})"
				CONFIG_FILE_MAIN_NAME="${CONFIG_FILE_NAME%.*}"
				CONFIG_FILE_MAIN_NAME_VARNT="$(echo ${CONFIG_FILE_MAIN_NAME} | sed "s/^${CONFIG_FILE_MAIN_NAME_PREFIX}-${DATE_SERIES_NAME}//g")"
				RESULTS_DIR_NAME_VARNT="${RESULTS_DIR_NAME}${CONFIG_FILE_MAIN_NAME_VARNT}"
				RESULTS_DIR_VARNT="${REPO_DIR}/${RESULTS_DIR_NAME_VARNT}"
				# To avoid overwriting any exisiting data, run the DEG anlaysis only
				# if neither results directory nor temporary result directory exists.
				if [ ! -d "${RESULTS_DIR}" ] && [ ! -d "${RESULTS_DIR_VARNT}" ]; then
					# Create a temporary Results directory.
					mkdir "${RESULTS_DIR}"
					EXIT_CODE=$?
					if [ ${EXIT_CODE} -ne 0 ]; then
						echo "ERROR: cannot create a temporary result directory ${RESULTS_DIR}!" 1>&2
						break
					fi
					# Launch the DEG anlaysis.
					echo "Calculating the DEGs using ${CONFIG_FILE_PATH} ..."
					"${PROG_FILE_PATH}" "${ANLYS_PROG_FILE_PATH}" "${CONFIG_FILE_PATH}" "${REPO_DIR}" "${FUNC_DIR}"
					EXIT_CODE=$?
					if [ ${EXIT_CODE} -eq 0 ]; then
						# Save the Results directory for the DEG analysis.
						if [ "${RESULTS_DIR_VARNT}" != "${RESULTS_DIR}" ]; then
							mv "${RESULTS_DIR}" "${RESULTS_DIR_VARNT}"
						fi
					else
						echo "ERROR: an error occurred in calculating the DEGs using ${CONFIG_FILE_PATH}!" 1>&2
						break
					fi
				else
					if [ -d "${RESULTS_DIR}" ]; then
						echo "ERROR: the temporary results directory ${RESULTS_DIR} already exists!" 1>&2
					fi
					if [ -d "${RESULTS_DIR_VARNT}" ]; then
						echo "ERROR: the results directory ${RESULTS_DIR_VARNT} already exists!" 1>&2
					fi
					EXIT_CODE=1
				fi
			done
			[ ${EXIT_CODE} -ne 0 ] && break
		else
			echo "ERROR: the config directory ${CONFIG_DIR} is not found!" 1>&2
			EXIT_CODE=1
		fi
	else
		echo "WARNING: the dataset directory ${REPO_DIR} is not found!" 1>&2
	fi
	[ ${EXIT_CODE} -ne 0 ] && break
done

# Exit with error code.
exit ${EXIT_CODE}
