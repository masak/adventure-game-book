# Connect 4

Today we'll implement [Connect 4](http://en.wikipedia.org/wiki/Connect_4). In our version, it's played between players `X` and `O` on a 7 ⨯ 6 grid.

The game is a bit bigger than what we've seen so far, but all of the individual pieces are (mostly) straightforward. As usual, comments come at the end.

First, here's how the end of a game might look:

    |   |   |   |   |   |   |   |
    |   |   |   |   |   |   |   |
    |   |   |   |   |   |   |   |
    |   |   | X | O |   |   |   |
    |   | O | X | X | X |   |   |
    | O | X | O | X | O |   |   |
    |---------------------------|
    | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
    
    Player O, your move: 6
    
    |   |   |   |   |   |   |   |
    |   |   |   |   |   |   |   |
    |   |   |   |   |   |   |   |
    |   |   | X | O |   |   |   |
    |   | O | X | X | X |   |   |
    | O | X | O | X | O | O |   |
    |---------------------------|
    | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
    
    Player X, your move: 6
    
    |   |   |   |   |   |   |   |
    |   |   |   |   |   |   |   |
    |   |   |   |   |   |   |   |
    |   |   | X | O |   |   |   |
    |   | O | X | X | X | X |   |
    | O | X | O | X | O | O |   |
    |---------------------------|
    | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
    
    Player X won.
    Thanks for playing!

And here's the source code:

%%% include games/connect-4

Ok, lots to comment on here:

* Note how we create `@board`. It's an array of arrays (since the board is two-dimensional), so we construct it with a `map` of `map`s.

* `show_board` is straightforward. We're using our new friend `.fmt` to avoid a few `for` loops when representing each row.

* We haven't seen *chained comparisons* before, as in `pile_height`, but they're easy: `0 <= $column < $WIDTH` simply means `0 <= $column && $column < $WIDTH`. We're used to seeing this notation from maths.

* `unless` shows up a lot in this code, both in its block form and as a statement modifier. The cousin of `if`, it is most often used when we want to bail out of something because of broken preconditions. Thus we `die` in `pile_height` if an out-of-range `$column` was passed in, and we `return` early from `input_move` if the move entered isn't quite right.

* Why do we `die` in one subroutine and `return` from another? Well, we want the game to keep running even if one of the players slips on the keyboard, so it makes sense to be a bit nicer in `input_move`. But `pile_height` is more of an "internal" routine, and a faulty parameter there usually means the whole program is wrong somehow. (This actually happened as I was writing the program.) So it makes sense to be more strict in `pile_height`.

* The subs `pile_is_full` and `board_is_full` are "unnecessary" in that we might as well have inlined the expressions they contained right in the code. But look what difference it makes to actually *define* those terms. Never underestimate the power of a good name for a concept.

* Note how `$move - 1` happens here and there. This is the usual translation between player-facing coordinates (1-based) and array indices (0-based). It only happens for columns and not for rows, since those are not exposed to the player.

* The `was_win` subroutine checks all the possible straights that the move *could* have made. It doesn't check the whole board. For straights of length 4, it checks up to 16 possible straights. (4 vertical, 4 horizontal, and 8 diagonal.)

* Notice that `was_win` defines four subroutines *inside* of itself. Those subroutines are purely for internal use by `was_win` &mdash; they're not even visible from the outside. They also cunningly use variables from outside of themselves; `$row` and `$column` are parameters to `was_win`, but are used within `was_vertical_win`, for example.

* In fact, another variable that's used inside the subroutines but defined outside, is `@board`. It should figure as a parameter to *all* the subroutines in the program if we wanted to make them independent of their environment. It's slightly bad practice not to make it a parameter, because that code is now *coupled* to `@board`... but it was felt that it would hurt exposition too much to be 100% kosher in this case. Programming is full of trade-offs.

* The `uniform` subroutine inside of `was_win` contains two things that we haven't seen yet. `@values».defined` means the same as `map { .defined }, @values`; it's just a shorter way of writing it. `[eq] @values` tests all values in `@values` with the `eq` operator. In summary, the `uniform` function checks that all values in `@values` are defined (which happens when none of the coordinates was outside of the board), and that they're all string-equal (which happens when someone made a winning straight).

* Notice how we use `map` in the `was_*_win` functions to translate from the "coordinates" 0..3 to actual positions along a line in `@board`. That should give a taste of how versatile `map` can actually be: we want to talk about the contents of the things on a line on the board, so we just transform 0..3 to that line.

* Because we have put all of the nitty-gritty details in subroutines, the actual game loop is fairly short. Show the board, input a move, place a piece, check the two possible ending conditions, and switch player. And it reads well, too: `if board_is_full` &mdash; isn't that nice?

Phew! That's it for today. Now we're heading straight for our final goal: the text adventure game.
