# digital-terrain-mc-server

## Getting Started
Ensure you have the correct environment and system dependencies.
Ruby: `2.6.3`
Node/npm: `lts/dubnium`
Rubocop: Latest version. `gem install rubocop`

1. clone this project into `$directory`
2. cd into `$directory`
3. run `bundle install`
4. run `npm install`
5. run `npm run rails-server` to build and run the web server
6. Navigate to http://localhost:3000

## Available npm scripts

### `npm run rails-server`
Webpacks javascript dependencies and starts the puma web server. Navigate to http://localhost:3000 after running this command to access the webserver in your browser

## Linting
This project uses [rubocop](https://docs.rubocop.org/rubocop/0.85/index.html) for linting.

Before proposing changes in a pull request and especially before merging you should ensure you have introduced no new linting errors no discussed in the pull request discussion. To lint the project run `rubocop` and investigate the output for fixing the error. Compare with #dev if you're unsure if something is new.

If you're having issues understand what an error means or how to fix it Googling `rubocop [lint rule] is a good way to find documentation on that exact rule and how to fix it.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change. 
Ensure tests are updated and passing. Ensure you introduced no new linting errors or warnings without reason.

## License
[MIT](https://choosealicense.com/licenses/mit/)
