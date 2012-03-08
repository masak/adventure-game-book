# Hangman

In the game "Hangman", one person guesses letters in a hidden word, while another person keeps track of the guessed letters, and penalizes wrong guesses with increments of a drawing of a stick figure in an unfortunate situation:

%%% include games/states

Let's put all those drawings in a file and call the file `states`; they're the states that the game can be in.

Then we need a list of juicy, sufficiently long words:

%%% include games/words

Let's put *that* in a file and call it `words`.

Finally, we have the game itself. Look how short it is! (Of course, partly because we put all the data in files...)

%%% include games/hangman

Make sure to copy the game to your own computer and run it. It's a nice little game, if I may say so myself.

Some diverse comments:

* The way we build `@guessed_word` is simple, but a bit long. There are shorter, nicer ways to do it which we haven't touched on yet.

* The junctions `none` and `any` really help to bring the code size down by avoiding loops. And they blend into the code quite well, too. It's easy to realize what their purpose is.

* There are a few cases of the methods `.uc` (uppercase) and `.lc` (lowercase). This is another case of wanting to keep one internal representation of things, and one external. We want to print all the letters as uppercase when we print them, but we also want to compare letters internally without regard to case. When making a caseless comparison, it's prudent to lowercase both sides, rather than to uppercase them.

* Look how we're actually "eating" states as we go along, `shift`ing and `say`ing the next one in one go. Then we can simply loop until `@states` is empty, which is what `while @states` does.

Next game we're aiming for is called "Animals". It'll be wild.
