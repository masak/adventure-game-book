# `given`

`if` statements are great, but after a while they start looking like this:

    my $animal = prompt "What's your favorite animal? ";
    
    if ($animal eq "tiger") {
        say "Roar!";
    }
    elsif ($animal eq "cow") {
        say "Mooo!";
    }
    elsif ($animal eq "parrot") {
        say "Ka-kaw!";
    }
    elsif ($animal eq "butterfly") {
        say "*flap* *flap*";
    }
    else {
        say "I'm sorry, I do not know that animal.";
    }

There's a lot of repetition in there:

* Lots of `if` and `elsif`.
* Lots of `$animal eq`. We're checking the same variable all the time, and still we have to repeat that that's what we're doing.

There's a construct that's specially designed to reduce this kind of needless "boilerplate" repetition: the *switch statement*, or *`given` statement*. Here's how the same program would look using that:

    my $animal = prompt "What's your favorite animal? ";

    given $animal {
        when "tiger"     { say "Roar!"; }
        when "cow"       { say "Mooo!"; }
        when "parrot"    { say "Ka-kaw!"; }
        when "butterfly" { say "*flap* *flap*"; }
    
        default { say "I'm sorry, I do not know that animal."; }
    }

This way of writing takes less space, no doubt. Now, that's partly because we now write the `{ ... }` blocks on the same line as the condition &mdash; we could do that with the `if` statements and save some space that way, too. But it's much more accepted with the `given` statement.

The other big saving is that we now write `$animal` once at the top, and then no more. It's *implicit* that we're comparing `$animal` against `"tiger"` and `"cow"` and `"parrot"`... we don't need to state it and re-state it. Even the `eq` is now implicit.

Wait a minute! How *does* that work, really? We already know that there's a difference between numerical equivalence (`==`) and string equivalence (`eq`) &mdash; how does Perl 6 know which one to choose here?

It knows which one to choose by looking at the type of the thing it's comparing. So `"tiger"` causes a string comparison, whereas `42` would cause a numerical comparison. There's a special operator called *smartmatch*, which embodies this type-aware kind of comparison:

    say $answer ~~ "tiger";     # means '$answer eq "tiger"'    
    say $answer ~~ 42;          # means '$answer == 42'

The smartmatch comes back again and again in Perl 6, even when you can't see it. For example, the `when` clauses above use smartmatching under the hood:

    when "cow" { ... }          # really means 'if $_ ~~ "cow" { ... }'

That `$_` variable there is a little darling. The fact that it doesn't start with a letter, but is just a dollar and an underscore, tells us that it's a somewhat special variable. Just like with smartmatches, the strength of `$_` is that it doesn't always have to be written out. We'll see more examples of that as we go along, but the `when` clause above is one such example.

Of course, this whole thing would only work if `$_` contained the value of `$animal` somehow... and that's exactly what `given` does for us. It (temporarily) sets `$_` to the value that we give it.

The extra little feature of `when` blocks is that when they match, they take you out of the surrounding `given` block. (Or more generally, the surrounding block that sets `$_`.) Same thing goes for the `default` block... which doesn't do much else, really. It always matches.

It's often the case that nifty features in Perl 6 are built up of smaller, simpler nifty features. The `given`/`when` statement is one such feature, as it turns out that it really uses `$_` and smartmatching underneath.

Now we're ready to tackle our next game. See you tomorrow on another celestial body.
