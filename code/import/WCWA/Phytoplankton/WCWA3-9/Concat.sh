#!bin/bash
INPUT=${1:-"/GIS_DATA/csiem-data-hub/data-warehouse/csv/wcwa/ploom/phy/"}
OUTPUT=${2:-"/GIS_DATA/csiem-data-hub/data-warehouse/csv/wcwa/ploom/phy/All/"}

rm $OUTPUT*.csv

FILES=$(find $INPUT -type f -name "*DATA.csv")
for f in $FILES
do
	#echo "Processing $f"
    base_name=$(basename $f)
    tail -n -1 $f >> "${OUTPUT}${base_name}"
done

FILES=$(find $INPUT -type f -name "*HEADER.csv")
for f in $FILES
do
    base_name="$OUTPUT$(basename $f)"
    cat $f > ${base_name}
done

FILES=$(ls $OUTPUT*DATA.csv)
for f in $FILES
do
	#echo "Processing $f"
    TEXT=$(cat $f)
    echo "Date,Depth,Data,QC"> $f
    echo "$TEXT" >> $f
done
