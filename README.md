# cipherTester
Tests the assigned crypt.sh with the public script for all valid types of input

How to use
----------
To use, just copy the script into the directory where your crypt.sh file is 
stored (presumabley ~/homework/script1/), chmod to add execute permissions, then
run the script with ./tester.sh 

What it does/How it works
-------------------------
A total of 4 possible options exist for each operation:
	read c write c
	read c write f
	read f write c
	read f write f
These 4 cases applied to the 2 types of operations (Encrypt or Decrypt) 
essentially translates to 8 total types of tests to perform with however many
trials you want to run for each type of test

Testing will take place in the order desribed above, chosen for what I believed
to be the simplest to most complex type of input to script was made to handle, 
and interrupting tseting if any of these tests fail (Recommend fixing the simple
cases before mobingg on to the more complex tests

The tester script has a built in array of keys and message to work with, which
provides 3 trials for each case (9 trials in some cases) but you are free to
add as many extra keys or messages you want to expand on trials you wish to run

Final Notes
-----------

Keep in mind that the instructors have reiterated countless times that only 
valid input are expected to be handled by your code - I have no say over how 
well my little tester script will react to invalid trials in key or message.

One final note is that this tester is SUPER jumpy and will most likely call out
differences between your script and the public driver. If this is the case, just
let it open up vimdiff and check out the differences yourself. If you want to be
extra and try to match driver behaviour EXACTLY (e.g. same number of newlines
after prompts), then the tester script will acknowledge it and print out a small
"Awesome possum!". For the most part though, the instructors have stated that 
only core functionality is being tested - Piazza post @369!, so as long as you
check out that the differences are only in the spacing and prompts you should be
good!

