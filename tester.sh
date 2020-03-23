#!/bin/bash

# 2 different options input, output, and enc/dec: f or c
#	4 total possible options: read c write c
#														read c write f
#														read f write f
#														read f write c
# Thus 4 options for encrypt and decrypt translate to 8 total types of tests
# Testing will take place from what I believed was the simplest to the more
# complex types of input the script was made to handle, interrupting testing
# if any of the test fail (fix the simple ones before moving on to complex tests)

# test cases to use will use following keys and messages
# feel free to add you own keys and messages if you want further testing!!
keys=("TESTER" "EXAMPLE" "SHORTKEY")
messages=("HELLO THERE BOB" "THIS WILL GET ENCRYPTED" "MUCH LONGER WORD THAN KEY"
		" THERE IS A WHITESPACE BEFORE")

# inp, driverCout, and scriptCout must be reset to empty files manually
# all other output files just need to exist - it is the task of encrypt/decrypt
# to empty them out
> inp
> driverCout 
> scriptCout
touch inp.enc scriptOut.enc driverOut.enc	scriptOut driverOut

# Fills up inp with the tester messages above
for i in "${messages[@]}"
do
	printf "$i\n">>inp
done

# ENCRYPTION PORTION OF TESTING
# FIRST TEST: read c write c 
for i in ${!keys[@]}
do
	printf "e\n${keys[$i]}\nc\nc\n${messages[$i]}\n" | ./crypt.sh >> scriptCout
	printf "e\n${keys[$i]}\nc\nc\n${messages[$i]}\n" | crypt_driver >> driverCout 
done

if [ "`diff scriptCout driverCout`" != "" ]
then
	echo "There were discrepencies when testing ENCRYPT: read C write C"
	read -p "Press Enter to open vimdiff to view these differences"
	vimdiff scriptCout driverCout
else
	echo "Awesome possum! No differences from driver for Encrypt from C to C"
fi

# SECOND TEST: read c write f [write to out.enc]
for i in ${!keys[@]}
do
	printf "e\n${keys[$i]}\nc\nf\nscriptOut\n${messages[$i]}\n" | ./crypt.sh >> /dev/null
	printf "e\n${keys[$i]}\nc\nf\ndriverOut\n${messages[$i]}\n" | crypt_driver >> /dev/null
done

if [ "`diff scriptOut.enc driverOut.enc `" != "" ]
then
	echo "There were discrepencies when testing ENCRYPT: read C write F"
	read -p "Press Enter to open vimdiff to view these differences"
	vimdiff scriptOut.enc driverOut.enc
else
	echo "Awesome possum! No differences from driver for Encrypt from C to F"
fi

# THIRD TEST: read f write c [read from inp]
# NOTE: reading from f will apply each key to each of the input
# clear script and driver Cout files before appending to them again 
> scriptCout
> driverCout
for i in ${!keys[@]}
do
	printf "e\n${keys[$i]}\nf\ninp\nc\n" | ./crypt.sh >> scriptCout
	printf "e\n${keys[$i]}\nf\ninp\nc\n" | crypt_driver | sed 's:.[[]1.*\|W.*[.]\|.[[]0m::g' >> driverCout
done

if [ "`diff scriptCout driverCout`" != "" ]
then
	echo "There were discrepencies when testing ENCRYPT: read F write C"
	read -p "Press Enter to open vimdiff to view these differences"
	vimdiff scriptCout driverCout
else
	echo "Awesome possum! No differences from driver for Encrypt from F to C"
fi

# FOURTH TEST: read f write f [read from inp | write to inp.enc]
# NOTE: reading from f will apply each key to each of the input
for i in ${!keys[@]}
do
	printf "e\n${keys[$i]}\nf\ninp\nf\n" | ./crypt.sh >> /dev/null
	cp inp.enc scriptOut.enc
	printf "e\n${keys[$i]}\nf\ninp\nf\n" | crypt_driver >> /dev/null
	cp inp.enc driverOut.enc
# above copying must to be done as both functions will auto write to inp.enc
# no need to copy to driverOut.enc but done so for uniformity 
done

if [ "`diff scriptOut.enc driverOut.enc`" != "" ]
then
	echo "There were discrepencies when testing ENCRYPT: read F write F"
	read -p "Press Enter to open vimdiff to view these differences"
	vimdiff scriptOut.enc driverOut.enc
else
	echo "Awesome possum! No differences from driver for Encrypt from F to F"
fi

# END OF ENCRYPTION PORTION OF TESTING

# As the last encryption testing was read from inp and write to file was called
# using the public driver, we can use the inp.enc file created as input for 
# the following decrypt tests

# DECRYPTION PORTION OF TESTING

# FIRST TEST: read c write c
# clear script and driver Cout files before appending to them again
> scriptCout
> driverCout
for i in ${!keys[@]}
do
	printf "d\n${keys[$i]}\nc\nc\n${messages[$i]}\n" | ./crypt.sh >> scriptCout
	printf "d\n${keys[$i]}\nc\nc\n${messages[$i]}\n" | crypt_driver >> driverCout
done

if [ "`diff scriptCout driverCout`" != "" ]
then
	echo "There were discrepencies when testing DECRYPT: read C write C"
	read -p "Press Enter to open vimdiff to view these differences"
	vimdiff scriptCout driverCout
else
	echo "Awesome possum! No differences from driver for Decrypt from C to C"
fi

# SECOND TEST: read c write f [write to out]
for i in ${!keys[@]}
do
	printf "d\n${keys[$i]}\nc\nf\nscriptOut\n${messages[$i]}\n" | ./crypt.sh >> /dev/null
	printf "d\n${keys[$i]}\nc\nf\ndriverOut\n${messages[$i]}\n" | crypt_driver >> /dev/null
done

if [ "`diff scriptOut driverOut`" != "" ]
then
	echo "There were discrepencies when testing DECRYPT: read C write F"
	read -p "Press ENTER to open vimdiff to view these differences"
	vimdiff scriptOut driverOut
else
	echo "Awesome possum! No differences from driver for Decrypt from C to F"
fi

# THIRD TEST: read f write c [read from inp.enc]
# NOTE: reading from f will apply each key to each of the input 
# clear script and driver Cout riles before appending to them again
> scriptCout
> driverCout
for i in ${!keys[@]}
do
	printf "d\n${keys[$i]}\nf\ninp\nc\nn" | ./crypt.sh >> scriptCout
	printf "d\n${keys[$i]}\nf\ninp\nc\nn" | crypt_driver | sed 's:.[[]1.*\|W.*[.]\|.[[]0m::g' >> driverCout
done

if [ "`diff scriptCout driverCout`" != "" ]
then
	echo "There were discrepencies when testing DECRYPT: read F write C"
	read -p "Press Enter to open vimdiff to view these differences"
	vimdiff scriptCout driverCout
else
	echo "Awesome possum! No differences from driver for Decrypt from F to C"
fi

# FOURTH TEST: read f write f [read from inp.enc | write to inp]
# NOTE: reading from f will apply each key to each of the input 
for i in ${keys[@]}
do 
	printf "d\n${keys[$i]}\nf\ninp.enc\nf\n"	| ./crypt.sh >> /dev/null
	cp inp scriptOut
	printf "d\n${keys[$i]}\nf\ninp.enc\nf\n"	| crypt_driver >> /dev/null
	cp inp driverOut
# above copying must to be done as both functions will auto write to inp
# no need to copy to driverOut but done so for uniformity
done

if [ "`diff scriptOut driverOut`" != "" ]
then
	echo "There were discrepencies when testing DECRYPT: read F write F"
	read -p "Press Enter to open vimdiff to view these differences"
	vimdiff scriptOut driverOut
else
	echo "Awesome possum! No differences from driver for Decrypt form F to F"
fi

# END OF DECRYPTION PORTION OF TESTING
