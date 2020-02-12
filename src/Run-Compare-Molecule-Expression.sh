#!/usr/bin/env bash

DATASET_DIR_PATH="${HOME}/LINCSData/Datasets/Difference/LINCS.Dataset/Coen-Paper/Conv-GEO-Depot"
PROG_DIR_PATH="${DATASET_DIR_PATH}/Programs/Compare-Molecule-Expression"
LIB_DIR_PATH="${PROG_DIR_PATH}/Library"
CONFIG_DIR_PATH="${DATASET_DIR_PATH}/Configs"
PROG_FILE_PATH="${PROG_DIR_PATH}/Compare-Molecule-Expression.R"
CONFIG_FILE_PATH="${CONFIG_DIR_PATH}/Conv-RNAseq-Configs.tsv"

Rscript "${PROG_FILE_PATH}" "${CONFIG_FILE_PATH}" "${DATASET_DIR_PATH}" "${LIB_DIR_PATH}"

exit $?
