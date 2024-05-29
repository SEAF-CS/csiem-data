diary Benchmark.txt
fList = {...
@()import_imos_profile_2_2010_csv_OLD()
@()import_imos_profile_2_2010_csv()
@()import_imos_profile_2_csv_Old()
@()import_imos_profile_2_csv()
@()import_imos_temp_sal_Old()
@()import_imos_temp_sal()...
}
Names = {...
'import_imos_profile_2_2010_csv_OLD'
'import_imos_profile_2_2010_csv'
'import_imos_profile_2_csv_Old'
'import_imos_profile_2_csv'
'import_imos_temp_sal_Old'
'import_imos_temp_sal'...
}

for i = 1:2:6
    disp('The Old code:');
    disp(Names{i})
    timeit(fList{i})

    disp('New version:')
    disp(Names{i+1})
    timeit(fList{i+1})
end

