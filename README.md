# Intial Setup

    docker-compose build
    docker-compose up mariadb
    # Once mariadb says it's ready for connections, you can use ctrl + c to stop it
    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml build

# To run migrations

    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml run short-app-rspec rails db:test:prepare

# To run the specs

    docker-compose -f docker-compose-test.yml run short-app-rspec

# Run the web server

    docker-compose up

# Adding a URL

    curl -X POST -d "full_url=https://google.com" http://localhost:3000/short_urls.json

# Getting the top 100

    curl localhost:3000

# Checking your short URL redirect

    curl -I localhost:3000/abc

# Algorithm used to shorten URL

    In order to generate the shortest possible length relative to the number of links currently in the database, I did some deep research on which algorithm was the best to do this. From this search I managed to find that one of the most used methods was to convert the "id" column to a base 62 code. 
    Therefore, for this project, the shortcodes are represented in base62 with the character set that includes the following: 0-9, a-z, and A-Z. This choice is correct because 62 is a high enough base value that you will reach your database's limit for integer values within 10 or 11 characters, allowing larger numbers to be represented with fewer characters relative to the "id" equivalent.
    So the way I use to convert the "id" to a shortened url is as follows:

    1. I create the "short_code" method that will be called when a POST of a url is made.
    2. Inside the method, the string variable "code" is initialized with an empty string value. This variable will be used to store the "short code".
    3. The "length" variable is initialized with the number of characters that the "CHARACTERS" set has.
    4. Start a loop and test if number(id) is positive. Inside the loop, the following is done:
        4.1. The remainder of the division between "id" and "length"(62) is returned.
        4.2. The remainder is used to find a character within the set "CHARACTERS" at the specified index.
        4.3. The character is added to the variable "code". 
        4.4. "id" is divided by "length" (62) and the output of that expression is used to reassign "id".
        4.5. The loop repeats until "id" is zero, so you can no longer divide.
    5. The string variable "code" is returned.

    In the opposite direction, the way I use to convert the "short code" to an "id" is the following:

    1. I create the "decode_short_code" method that will be called when a url is redirected from the "short code" given by the user.
    2. Inside the method, the variable "number" is initialized with a value of zero. This variable will be used to store the "id".
    3. The "length" variable is initialized with the number of characters that the "CHARACTERS" set has.
    4. Begin a loop, looping each character from left to right iteratively. Inside the loop, the following is done:
        4.1. The variable "number" is multiplied by "length"(62).
        4.2. The index of a character is inside the set "CHARACTERS".
        4.3. The index is added to the output of the multiplication between "number" and "length".
        4.4. The variable "number" is reassigned the new value.
        4.5. The loop continues until there are no more characters left inside "code".
    5. The variable "number" is returned.

