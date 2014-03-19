#! /bin/bash
_now=$(date +"%m-%d-%Y_%T")
_file="/home/pi/rng/dieharder_suite_$_now"
_now=$(date +"%m-%d-%Y_%T")
echo "Starting dieharder test # 0 at $_now"
dieharder -d 0 > "$_file"
_now=$(date +"%m-%d-%Y_%T")
echo "Finished dieharder test # 0 at $_now"
for i in {1..4} 
  do
    _now=$(date +"%m-%d-%Y_%T")
    echo "Starting dieharder test # $i at $_now"
    dieharder -d "$i" >> "$_file"
    _now=$(date +"%m-%d-%Y_%T")
    echo "Finished dieharder test # $i at $_now"
done
for i in {8..13} 
  do
    _now=$(date +"%m-%d-%Y_%T")
    echo "Starting dieharder test # $i at $_now"
    dieharder -d "$i" >> "$_file"
    _now=$(date +"%m-%d-%Y_%T")
    echo "Finished dieharder test # $i at $_now"
done
for i in {15..17} 
  do
    _now=$(date +"%m-%d-%Y_%T")
    echo "Starting dieharder test # $i at $_now"
    dieharder -d "$i" >> "$_file"
    _now=$(date +"%m-%d-%Y_%T")
    echo "Finished dieharder test # $i at $_now"
done
for i in {100..102} 
  do
    _now=$(date +"%m-%d-%Y_%T")
    echo "Starting dieharder test # $i at $_now"
    dieharder -d "$i" >> "$_file"
    _now=$(date +"%m-%d-%Y_%T")
    echo "Finished dieharder test # $i at $_now"
done
_now=$(date +"%m-%d-%Y_%T")
echo "Starting dieharder test # 200 at $_now"
dieharder -d 200 -n 5 >> "$_file"
_now=$(date +"%m-%d-%Y_%T")
echo "Finished dieharder test # 200 at $_now"
for i in {202..209} 
  do
    _now=$(date +"%m-%d-%Y_%T")
    echo "Starting dieharder test $i at $_now"
    dieharder -d "$i" >> "$_file"
    _now=$(date +"%m-%d-%Y_%T")
    echo "Finished dieharder test $i at $_now"
done
echo "Test results were written to $_file"

