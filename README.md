Experimental Perl Exercises for http://perlmaven.com/
=====================

Either clone this repository or download the zipped version of it.

To see the list of available exercises run

   perl bin/exercise.pl --list

Create your solution in the main directory.

To check if you have solved the 'hello_world' exercise properly run

   perl bin/exercise.pl hello_world





Adding more exercises:
================

Each EXERCISE has a directory (e.g. hello_world)
   In that directory there is a file called Exercise.pm that subclasses the Exercises module found in lib/.
   In this module we need to override the 'setup' method  and set the 'exe' attribute to the name of the main executable file we are expecting.
       The 'files' attribute should be an array reference with the list of all the 'other' files.

   In that directory there is a subdirectory called 'EXERCISE/solutions' Each solution has a subdirectory in there called 01, 02, etc. with all the files needed for that solution.
   There is also a directory called 'EXERCISE/test_cases' with various black-box test cases.
       0.err  is the expected output for when we run 'perl bin/exercise.pl EXERCISE'  without any files being created for the current exercise.
              It should list all the files needed for this exercise.
       For each additional test_case we have one or more of the followin files: N.in N.argv N.out N.err 
       When the student runs 'perl bin/exercise.pl EXERCISE' we will run the main script of the exercise like this:
         perl solution.pl [the content of N.argv] < N.in > out 2> err
       and then we'll compare N.out to the content of out and N.err to the content of err.
       If either of N.our or N.err does not exists we compare the respective out/err file to the empty string.

   There is also a directory called 'EXERCISE/bad_solutions' (and we still need to figure out what to have in there) 

