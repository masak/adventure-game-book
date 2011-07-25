# Signatures

We haven't implemented a [Fibonacci](http://en.wikipedia.org/wiki/Fibonacci_number) subroutine yet. Let's do that.

    sub fib($n) {
        return 0 if $n == 0;
        return 1 if $n == 1;

        return fib($n - 1) + fib($n - 2);
    }

Yes, it's *recursive*, meaning that it calls itself. That's perfectly fine; we just have to make sure that it bottoms out in some base case or other. That's why we have the first two lines in there, as our base cases.

(It's not a very efficient implementation. It will get unbearably slow for larger values of `$n`. There are better ways to implement `fib`, but what this version has going for it is that it's short and clear.)

But wait! There's a terrible thing that can happen to this subroutine. If we call `fib(2.5)` it will call `fib(1.5)`, which will call `fib(0.5)`, which will call `fib(-0.5)`, and so on down to minus infinity, which is very far down indeed.

No problem, though. We just adorn `fib`'s parameter `$n` with a type:

    sub fib(Int $n) {
        ... # (same)
    }

The only thing that changed there is the `Int` in front of the `$n` on the first line. Now when we try to call `fib(2.5)`, we get

    Nominal type check failed for parameter '$n'; expected Int but got Rat instead

Yep, 2.5 is a `Rat`. Short for "rational number". Now you know. Also, the thing that we just put the type in is called a *signature*. Hence the name of this post. Every subroutine has a signature, even if it's an empty one. The signature is like a guard that makes sure only values of the right type get through the door into the subroutine.

So, that's that problem solved. But... oh no! There's another way `fib` could loop infinitely. (As if it wasn't already slow enough...) What would happen if we passed in a negative integer, like `fib(-1)`.

Well, it wouldn't get stuck in any of the base cases; it's already below them. We realize that we never really meant for someone to call `fib` with a negative integer argument. Argh.

What's worse, we can't just solve this by slapping a `NonNegativeInt` type on `$n` either, because there is no such type in Perl 6. Instead, we can do one of two things.

The first thing we can do is to use a `where` clause:

    sub fib(Int $n where { $n >= 0 }) {
        ...
    }

Now people will get this when they try to call `fib(-1)`:

    Constraint type check failed for parameter '$n'

I guess you can see how `where` clauses complement named types quite nicely. We can check anything we want inside of those. And it's shorter than writing something like this:

    sub fib(Int $n) {
        die "fib can't handle negative numbers!"
            unless $n >= 0;

        ...
    }

The second thing we can do is *define* a `NonNegativeInt`:

    subset NonNegativeInt of Int where { $_ >= 0 };
    
    sub fib(NonNegativeInt $n) {
        ...
    }

So... `subset` gives us the ability to create new, narrower types. We'll see lots more about type creation in the next few days.

`subset`, as it happens, also uses a `where` clause. Of course that's because we're still doing essentially the same check, only we're declaring it outside of the signature. Note how we can't use `$n` inside the `where` clause, because `$n` only exists within the context of `fib`. But the topic variable `$_` within `where` clauses means "the value we're talking about", and that's what we need.

When should you use `where` clauses directly in the signature, and when should you define subtypes? There's no right or wrong here, but it makes a lot of sense to declare a subtype if you plan to use that particular constraint in a lot of different situations.

Let's end today's post with a nice feature that we're now prepared to fully appreciate: *multi subs*. They're simply subroutines with the same name but different signatures:

    multi sub fib(Int $n where { $n == 0 }) { 0 }
    multi sub fib(Int $n where { $n == 1 }) { 1 }
    
    multi sub fib(Int $n where { $n  > 1 }) { fib($n - 1) + fib($n - 2) }

Clearly, it gets rid of a bit of conditionals, by pushing things into signatures instead. In fact, we can write the first two multis even shorter:

    multi sub fib(0) { 0 }
    multi sub fib(1) { 1 }
    
    multi sub fib(Int $n where { $n > 1 }) { fib($n - 1) + fib($n - 2) }

Look [how close that is](http://en.wikipedia.org/wiki/Fibonacci_number) to the definition at the top of the Wikipedia page.

Multis are a great way to divide related but different behaviors into different subs. More about clever ways of subdividing things tomorrow, when we talk about classes.
