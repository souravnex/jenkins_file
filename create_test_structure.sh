#!/bin/bash

# Root folders
mkdir -p oozie/json_output
mkdir -p oozie/nifi

# Oozie Dashboard structure
mkdir -p oozie/dashboard/bi/dashboard_daily_bi
mkdir -p oozie/dashboard/bi/dashboard_monthly_bi
echo "-- SQL content placeholder" > oozie/dashboard/bi/dashboard_monthly_bi/dashboard_monthly_bi.sql
echo '{ "json": "placeholder" }' > oozie/dashboard/bi/dashboard_monthly_bi/smart_dashboard_bi_monthly.json
mkdir -p oozie/dashboard/bi/dashboard_weekly_bi

mkdir -p oozie/dashboard/gtpc/dashboard_daily_gtpc
echo "-- SQL content placeholder" > oozie/dashboard/gtpc/dashboard_daily_gtpc/dashboard_daily_gtpc.sql
echo '{ "json": "placeholder" }' > oozie/dashboard/gtpc/dashboard_daily_gtpc/smart_dashboard_gtpc_daily.json
mkdir -p oozie/dashboard/gtpc/dashboard_weekly_gtpc

mkdir -p oozie/dashboard/gtpu
mkdir -p oozie/dashboard/lte
mkdir -p oozie/dashboard/ss7

# Monitor structure (all inside oozie)
mkdir -p oozie/monitor-monthly/data_daily

mkdir -p oozie/monitor-monthly/gtpc_daily
echo "-- SQL content placeholder" > oozie/monitor-monthly/gtpc_daily/gtpc_daily.sql
echo '{ "json": "placeholder" }' > oozie/monitor-monthly/gtpc_daily/smart_dashboard_gtpc_daily.json

mkdir -p oozie/monitor-monthly/gtpu_daily
mkdir -p oozie/monitor-monthly/lte_daily
mkdir -p oozie/monitor-monthly/ss7_daily
echo "-- HQL content placeholder" > oozie/monitor-monthly/aggregate_daily.hql

# More random folders & files
for i in {1..5}; do
  rand_dir="oozie/dashboard/random_section_$RANDOM"
  mkdir -p "$rand_dir"
  echo "-- random SQL" > "$rand_dir/random_file_$RANDOM.sql"
  echo '{ "random": "json" }' > "$rand_dir/random_json_$RANDOM.json"
done

for i in {1..3}; do
  rand_dir="oozie/monitor-monthly/random_monitor_$RANDOM"
  mkdir -p "$rand_dir"
  echo "-- HQL test $i" > "$rand_dir/monitor_query_$RANDOM.hql"
done

echo "✅ Oozie folder structure with random files/folders created."
