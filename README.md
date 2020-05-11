<p align="center">
  <img src="logo.png" width="400">
</p>

# Notify

Notify is a ruby script that will periodically watch a web page and notify you based on changing web content

For example - you would like to know when a certain product page no longer displays the text "Not in stock"

## Installation

(only macOS currently)

- Install [chromedriver](https://chromedriver.chromium.org/)
- Fetch dependencies:

```bash
bundle install
```

## Usage

```bash
ruby ./main.rb watch data.json
```

```json
{
  "url": "<Some valid URL to watch>",
  "criteria": {
    "js_selector": "<The specific element you want to watch>",
    "match": "<The string you DON't want to match against (poor naming I know - will fix)>"
  },
  "interval": 60
}
```

Command helper:
```bash
ruby ./main.rb help 
```