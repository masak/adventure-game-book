# A moon lander

The good news: you've made it all the way to the moon. Congratulations!

The bad news: due to a terrible misjudgment, your moon lander doesn't have as much fuel available as would be desirable. It will take all your concentration to make a soft touch-down. Use the fuel you have, by all means, but *not too soon*! (Also, don't use it too late.)

Here we go.

%%% include games/moon-lander

Slightly longer than we've seen so far, but that's just because it's quite a nice game. There's nothing especially new in there.

Well, there are a few things that deserve a mention:

* We've used capitals for the variables `$LANDER` and `$GROUND` because we don't expect them to change during the course of the program. That's a way of indicating that they're really constants.

* The `$int_alt` variable is there merely for esthetic purposes. `.Int` converts the altitude to an integer (a whole number), which comes out nicer when we use it for building strings on the next line. Sometimes the altitude is something-point-five, which makes the ground wobble a little. We don't want that.

* We don't bother saving `prompt "command> "` into a variable this time &mdash; we just throw it straight into a `given` statement. That's quite alright.

* Recall that `$velocity += 3` means `$velocity = $velocity + 3`. It's just a short form for when we have the same variable on both sides of the assignment.

* Yeah, we're cheating a bit with the `"help"` command. We're putting it in a `default` clause, so that it actually catches all miscellaneous commands... including `"help"`.

* You'll recall that `last` immediately takes us out of a loop. `redo`, on the other hand, immediately restarts the loop. Which is what we want after showing the list of available commands, rather than crashing into the moon.

* There are a number of better ways to write the big `loop {}`, in this case, because we know when the game is over: when the altitude gets nonpositive. We could write any of these ways instead: `while $altitude > 0 { ... }` or `until $altitude <= 0 { ... }` or `repeat until $altitude <= 0 { ... }` or `repeat { ... } until altitude <= 0` (or other obvious permutations). The presence of the `repeat` keyword would simply guarantee that we run the loop at least once.

Have fun playing! I know I did. The moon is harder than it looks. `:-)`
