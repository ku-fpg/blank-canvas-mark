# update the csv files


boot:: $(patsubst %.json,%.csv,$(wildcard *.json))

%.csv: %.json
	../dist/build/diet-criterion/diet-criterion $< $@

