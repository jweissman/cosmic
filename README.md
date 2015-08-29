# cosmic

## Description

Simulate a universe!

## Features

  - Lazily constructs a universe as you explore the object graph

## Examples

    ```ruby
    [1] pry(main)> include Cosmic
    => Object

    [2] pry(main)> universe = Universe.new
    => a universe named 'Ea'

    [3] pry(main)> people = universe.leaves
    => #<Enumerator::Lazy: ...>

    [4] pry(main)> people.first(5)
    => [person Dora Wang Quinn Martinez (willing female game developer) [gymnast] [violinist] [hiker],
     person Liam Jones (loyal male firefighter) [tool collector] [gunsmith] [storyteller],
     person Karim Khan Martin Mitchell (intelligent male administrator) [puzzler] [kayaker] [people watcher],
     person Jeanne Moore Thompson (placid female teaching assistant),
     person Isabella Thompson (affectionate female statistician) [hunter] [reader] [birdwatcher] [ghosthunter]]

    [5] pry(main)> people.select(&:puzzler?).reject(&:placid?).first(3)
    => [person Karim Khan Martin Mitchell (intelligent male administrator) [puzzler] [kayaker] [people watcher],
     person Hiroto Rodriguez Li (courteous male art historian) [pet owner] [puzzler] [coin collector],
     person Rachel Wood Sun Sanders (gentle female software analyst) [hang-glider] [cyclist] [violinist] [puzzler] [tea taster]]

    [6] pry(main)> people.first.ancestors(depth: 5)
    => [Headland Table Bus (transport building), a lot named 'Table', a block named 'Headland Coast', a neighborhood named 'Spin Rock', a settlement named 'Hollow Blowhole Splay']

    [7] pry(main)> people.first.ancestors(depth: 20)
    => [Headland Table Bus (transport building),
     a lot named 'Table',
     a block named 'Headland Coast',
     a neighborhood named 'Spin Rock',
     a settlement named 'Hollow Blowhole Splay',
     a region named 'Highland',
     a continent named 'Sea',
     a planet named 'Crucis Pegasi Gamma',
     a sun named 'Eta',
     a galaxy named 'Persei Ursae',
     a supercluster named 'Persei Pegasi Gamma',
     a sector named 'Epsilon',
     a universe named 'Ea']
     ```

## Requirements

  Ruby 2.x should be enough!

## Install

  $ gem install cosmic

## Copyright

Copyright (c) 2015 Joseph Weissman

See LICENSE.txt for details.
