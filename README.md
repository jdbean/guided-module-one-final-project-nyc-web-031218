# CLI MANAGER README

The CLI Agenda Manager is a CLI application that allows users to create, read, update and delete events on their agenda. It makes use of ActiveRecord to easily relate a User class to its calendars and events as well as make other necessary relationships.

## Running the Program

To run this program, simply fork or clone this repository. Then, run `bundle install` and `rake db:migrate` in that order. If you would like seeded data to manipulate, simply run `rake db:seed` to populate the database. Then, run the `run.rb` file in the `bin` directory.

## Viewing Seeded Data

A sample account is available with username "demo" and password "demo". Enter these credentials at the login prompt to view an account pre-populated with some sample content.

## Notable Dependencies

CLI Agenda Manager makes use of the `colorize` Gem for painting terminal text in ANSI color-set colors and the `highline` Gem for building menus and dialogues. We also implemented menus using the `tty-prompt` gem.

## A Note on Password Security

Although user passwords are never printed to the screen in the program they are currently stored in a database in plaintext.

## Contributions

This project is not being actively maintained and is not accepting contributions at this time.
