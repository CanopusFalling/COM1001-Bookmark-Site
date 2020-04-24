Hello! Welcome to the project.

===== 1st time install =====

Please run the following while in the project directory:

bundle install

===== System testing =====

cucumber

rake unittest

Note: The cucumber and unit tests should have no errors if you are on the master branch, if there are errors then the machine is likely set up wrong.

==== Run system =====

You can run either

rake run

or 

rake testrun

I recomend testrun as that resets the database into a testing data mode and undoes anything that the cucumber or unittests may have done.

===== Enjoy :D =====
