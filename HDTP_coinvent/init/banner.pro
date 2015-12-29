% message that is printed after hdtp is loaded and invokes welcome message 
print_banner :- print('HDTP Coinvent version '),hdtp_version(Version),hdtp_copyright_year(Year),print(Version),print(' , Copyright (C) '),print(Year),print(' '),hdtp_authors(Authors),print(Authors),nl,print_welcome.

print_welcome :- print('type examples. to see example queries'),nl.
                      