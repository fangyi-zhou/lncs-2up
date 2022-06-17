#!/bin/bash
# Partly taken from
# https://procrastiblog.com/2007/01/17/printing-lncs-format-pdfs/
# with modifications
set -euo pipefail

require() {
  if [[ "$(which "$1")" = "" ]]
  then
    echo "Requires $1"
    exit 1
  fi
}

usage() {
  echo "Usage: $0 FILE"
  exit 1
}

require pstops
require ps2pdf
require pdf2ps

if [[ "$#" = 0 ]]
then
  usage
  exit 1
fi

TMPDIR=$(mktemp -d)
INPUTFILE=$(basename -- "$1")
OUTPUTDIR=$(dirname -- "$1")

cp "$1" "$TMPDIR/input.pdf"
pdf2ps "$TMPDIR/input.pdf" "$TMPDIR/input.ps"
pstops '2:0L@.95(8.75in,0in)+1L@.95(8.75in,6in)' "$TMPDIR/input.ps" "$TMPDIR/output.ps"
ps2pdf "$TMPDIR/output.ps" "$TMPDIR/output.pdf"
cp "$TMPDIR/output.pdf" "$OUTPUTDIR/${INPUTFILE%.*}_out.pdf"
