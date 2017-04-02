---
layout: post
title: "Lets get functional using scalaz"

meta:
  nav: blog
  author: morpheyesh
  pygments: true
  mathjax: true
---


Last week I gave a talk on building a RESTful API server using play/scalaz([slide](http://www.slideshare.net/YeshwanthKumar7/restful-api-using-scalaz-3)) in functionalConf 2015. It was two days full of programmers talking/sharing about writing code in a paradigm that many dread to even start, especially people from an object oriented background. Whenever I ask people about fp, they all have the idea that you need a Ph.D or similar sort, to write functional code, which is not true at all. I will be(try) writing a series of articles that focuses on helping developers write pure functional code and will make sure to stick to the usecases and how they can be used more than the scary theory behind it.

<!-- more -->

### Scalaz aka 'gateway drug'

scalaz is sometimes considered to be the gateway drug to the functional programming world. Yes, scalaz does help you get started and slowly move from OO to fp style. If you are an haskell or erlang programmer, I suggest you just stop reading this right away and move on.

### Why functional programming?

If you are a novice in fp, You might wonder what is wrong with object oriented programming? There is  nothing wrong with the OO style of programming, they both are good paradigms with which softwares can be build, and they both have their own pros and cons.
Complexity of software increases which demands for software to be very well structured. When I say they need to be very well structured, they should have ..

* No side-effects

* Concise code

* easy tests

### No side-effects!

In functional programming, you construct a program using *pure functions*. Pure functions are basically functions that has got no side effects. Now, the question..

#### what are pure functions?

Well, when you write a piece of code, you would have to modify a variable or a data structure, perform IO operations, handle exceptions etc. When a function contains all these, they are considered to be impure functions and these are considered to be side-effects.

When a function f takes a type A and does some computation and give our result B, it is said to be a pure function.

```
  f() = { A => B }
```

Pure functions are generally easy to test and they have no mutable variables.
Since they use immutable variables, the order of execution becomes irrelevant too.


#### what does this lead to?

When a program containes immutable variables(when assigned, it cannot changed), with no side effects, they help in structuring the code as tiny blocks(functions) which increases efficiency and makes it easier to scale.

#### Is Scala a functional programming language?

Absolutely, scala is a statically type object oriented programming language, with support for functional programming that compiles to the JVM. Let us now see why scala is the perfect language for fp

* <b>Option[Type]</b>
  This can be thought as a list that contains atmost one element. Very handly when you are handling errors(no more annoying nulls that you find in java), its either Some() or None.


* <b>Map</b>

```scala
  def Two(x: Int) = List(x + 1)
  val NewL = List(1,2)
  NewL.map(x => Two(x))
  //will give you a List of Lists.
```
Map is very powerful, will explain map in depth on the following articles. Other than that the code is pretty straightforward.

* <b>flatMap</b>

```scala
..
NewL.flatMap(x => Two(x))
// this would return a list and not a list of lists.
```
flatmap flattens the inner type and returns the List only.

* <b>for comprehension</b>

One of my favourite in scala itself. Instead of using a series of maps and flatmaps,
you can use a for-comprehension to perform a chain of computations.

```scala
 for {
   step1 <- score()
   step2 <- crush()
   step3 <- roll()
 } yield {
   println("trip time!")
 }
```

A for-comprehension consist of a series of bindings, the compiler desugars the bindings by performing flatmaps and finally performs a map(yield). We will again see how this can be used to chain computations etc.

### Typeclasses

Any fp blog post would be incomplete if it does not contain typeclasses. Typeclasses are confusing at first, but you get used to as you start using them.

 <code>***Definition: if Typeclass A -> defines behaviour(operations) -> type T supports***</code>
<code>***then T -> member -> A***</code>

* **Order Typeclass**

In your REPL try,

```scala
import scalaz._
import Scalaz._
3 ?|? 2
// will return scalaz.Ordering = GT
```

Now try,

```
3 ?|? "yolo!"
//will throw a type mismatch error
```

The order typeclass is a simple typeclass which supports GT, LT, EQ, MAX, MIN etc.

* **Show Typeclass**

```scala
"iamgod".show
//will return show becuase string supports show method
```
Now if you use show on Thread class, it is going to throw an error.

```scala
new Thread().show
//it will throw an error, but..

implicit val showT = Show.shows[Thread]{_.getName}
new Thread().show

//will not return the name
```

These are extremely simple typeclasses and you can ask what is the big deal? In the above example, it is very important to notice that type plays a major role. scalaz does not let it compile if the types do not match.

Let us look into another simple example, fire up your REPL and type

```scala
"2" == "string"
```
The above code will perfectly compile returning Boolean = false, now..

```scala
import scalaz._
import Scalaz._
"2" === "string"
```

Now this would throw and type mismatch error and the compiler will not compile. The point is, when you write functional code, it automatically becomes type-safe and hence all the errors are trapped at the compile time itself.
I will try to write more articles on lenses, validationNels and how to use them in the future posts. Stay tuned!
