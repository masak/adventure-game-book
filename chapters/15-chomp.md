# chomp!

The good news: You have a chocolate bar, and you're sharing it with a friend!

The bad news: the upper left corner of the chocolate bar is poisoned! Oh noes!

So now you're both in a really odd game were you're taking turns biting lower-right chunks off the chocolate bar, each of you plotting your way to not being the one with the poisoned corner. Oh man, how did it end up this way? No-one knows.

%%% include games/chomp

A few things are worth pointing out in the above code.

* There are a lot of ways we could represent the chocolate bar, but having it as an array of strings which we can the just print out seems like a nice compromise. Taking bites of the bar then corresponds to taking `substr`s of the strings. Which isn't too bad.

* There's a loop in our loop. We need to `redo` and `last` on both of them, and things can turn a bit confusing. So we put *labels* on the loops, and then we can use them to identify them. Look "how well things read" after we do that: `redo INPUT` (when the input wasn't kosher), `last PLAYER` (when the game is lost), `last INPUT` (when we get the input right).

* Pay especial notice to how, in `$row > @bar.elems || $column > @bar[$row - 1].chars`, we are making implicit use of the short-curcuiting behavior of the `||` operator. On the left side, we're checking if `$row` is out of range, and *only if it's not* do we proceed and actually use it on the right side to index the array. This is one of the most common uses of short-circuiting.

* There are a bunch of `$var - 1` strewn across the latter part of the main game loop. That's because we expose a 1-based coordinate system to the players of the game, but our array and strings are all 0-based, because that's the way Perl does things. That kind of "model compensation" between slightly different world views is very common, as well. Get used to it. `:-)`

That's it for today; enjoy your chocolate. I'd tell you what we're heading for next, but I don't know yet. Have to make the second half of the schedule first.
